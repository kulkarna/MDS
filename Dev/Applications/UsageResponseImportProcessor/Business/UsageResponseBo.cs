using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsageResponseImportProcessor.DataAccess;
using UsageResponseImportProcessor.Entities;
using UsageResponseImportProcessor.Help;

namespace UsageResponseImportProcessor.Business
{
    public class UsageResponseBo : IUsageResponseBo
    {
        public UsageResponseBo(IUsageResponseDao usageResponseDao)
        {
            this.usageResponseDao = usageResponseDao;
        }

        #region Private Members - Injections

        private readonly IUsageResponseDao usageResponseDao;

        #endregion

        #region Constants

        private readonly string CUSTOMER_PROSPECT_TKN = "CUSTOMER_PROSPECT_TKN";
        private readonly string CUSTOMER_PROSPECT_ACCOUNT_TKN = "CUSTOMER_PROSPECT_ACCOUNT_TKN";
        private readonly string TERRITORY_CODE = "TERRITORY_CODE";
        private readonly string LDC_ACCOUNT_NUM = "LDC_ACCOUNT_NUM";
        private readonly string STATUS_DESC = "STATUS_DESC";
        private readonly string CREATE_TSTAMP = "CREATE_TSTAMP";
        private readonly string TRANS_ID = "TRANS_ID";
        private readonly string ORIGINAL_TRANS_ID = "ORIGINAL_TRANS_ID";
        private readonly string TYPE_DESC = "TYPE_DESC";
        private readonly string REASON_CODE = "REASON_CODE";
        private readonly string REASON_DESC = "REASON_DESC";
        private readonly string USAGE_TYPE = "USAGE_TYPE";

        private readonly string INTERVAL_USAGE_TYPE = "INTERVAL";

        #endregion

        #region Private Members

        private UsageResponseFile usageResponseFile;
        private List<UsageResponseFileRow> usageResponseFileRows;

        private bool hasInvalidData;
        private bool hasUnexpectedError;

        #endregion

        public bool HeaderIsValid(string fileHeader)
        {
            var array = fileHeader.Split('\t');
            
            return CUSTOMER_PROSPECT_TKN.Equals(array[0], StringComparison.CurrentCultureIgnoreCase) &&
                   CUSTOMER_PROSPECT_ACCOUNT_TKN.Equals(array[1], StringComparison.CurrentCultureIgnoreCase) &&
                   TERRITORY_CODE.Equals(array[2], StringComparison.CurrentCultureIgnoreCase) &&
                   LDC_ACCOUNT_NUM.Equals(array[3], StringComparison.CurrentCultureIgnoreCase) &&
                   STATUS_DESC.Equals(array[4], StringComparison.CurrentCultureIgnoreCase) &&
                   CREATE_TSTAMP.Equals(array[5], StringComparison.CurrentCultureIgnoreCase) &&
                   TRANS_ID.Equals(array[6], StringComparison.CurrentCultureIgnoreCase) &&
                   ORIGINAL_TRANS_ID.Equals(array[7], StringComparison.CurrentCultureIgnoreCase) &&
                   TYPE_DESC.Equals(array[8], StringComparison.CurrentCultureIgnoreCase) &&
                   REASON_CODE.Equals(array[9], StringComparison.CurrentCultureIgnoreCase) &&
                   REASON_DESC.Equals(array[10], StringComparison.CurrentCultureIgnoreCase) &&
                   USAGE_TYPE.Equals(array[11], StringComparison.CurrentCultureIgnoreCase);
        }

        public void SetUsageResponseFile(UsageResponseFile usageResponseFile)
        {
            this.usageResponseFile = usageResponseFile;
            this.usageResponseFileRows = usageResponseFile.Rows;
        }

        public void ValidateRows()
        {
            this.hasInvalidData = false;
            this.hasUnexpectedError = false;

            // Take off records already processed.

            var latestUsageResponseCreatedTimeStamp = this.usageResponseDao.GetLatestUsageResponseCreatedTimeStamp();
            this.usageResponseFileRows = this.usageResponseFileRows.Where(x => x.Date > latestUsageResponseCreatedTimeStamp).ToList();

            // Verify if the any record has data issue which can impact in the process.

            this.usageResponseFileRows
                .ForEach( row => this.ValidateDataIssue(row) );
            
            // Verify if Reason Code and Utility Type are ok to be processed.

            this.usageResponseFileRows
                .Where( row => row.Status == null)
                .ToList()
                .ForEach( row => this.ValidateReasonCodeAndUtilityType(row) );

            // Fill the UsageResponse object for further help.

            this.usageResponseFileRows
                .Where(row => row.Status == null)
                .ToList()
                .ForEach(row => row.UsageResponse = this.GetUsageResponse(row));

            // Verify if usage response already exists on database.

            this.usageResponseFileRows
                .Where(row => row.Status == null)
                .ToList()
                .ForEach(row => this.ValidateDuplicated(row));
            
            // Verify if usage response was recently sent to provider.

            this.usageResponseFileRows
                .Where(row => row.Status == null)
                .ToList()
                .ForEach(row => this.ValidateDateSent(row));
        }

        public bool HasInvalidData()
        {
            return this.hasInvalidData;
        }

        public bool HasUnexpectedError()
        {
            return this.hasUnexpectedError;
        }

        public void SaveEdiTransactions()
        {
            this.usageResponseFileRows
                .Where(row => row.Status == null)
                .ToList()
                .ForEach(
                    row => 
                    {
                        try
                        {
                            this.usageResponseDao.Save(row.UsageResponse);
                            row.Status = "Inserted";
                        }
                        catch (Exception ex)
                        {
                            this.hasUnexpectedError = true;
                            this.usageResponseDao.Log(ex, this.usageResponseFile.FileName, row.Index);
                        }
                    });
        }

        public void SaveFile()
        {
            string status = null;
            if (this.hasUnexpectedError)
                status = "Processed with Unexpected Error";
            else if (this.hasInvalidData)
                status = "Processed with Data Error";
            else
                status = "Processed Successfully";

            this.usageResponseDao
                .Save(new UsageResponseFile
                {
                    FileName = this.usageResponseFile.FileName,
                    Status = status,
                    Rows = this.usageResponseFileRows
                });
        }

        #region Private Methods

        private void ValidateDataIssue(UsageResponseFileRow row)
        {
            var issues = new List<string>();

            if (string.IsNullOrWhiteSpace(row.TERRITORY_CODE) || this.usageResponseDao.GetUtilityByTerritoryCode(row.TERRITORY_CODE) == null)
                issues.Add("Utility");

            if (string.IsNullOrWhiteSpace(row.LDC_ACCOUNT_NUM))
                issues.Add("Account Number");

            DateTime date;
            string[] formats = { "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss.f" };
            if (string.IsNullOrWhiteSpace(row.CREATE_TSTAMP) || !DateTime.TryParseExact(row.CREATE_TSTAMP, formats, CultureInfo.CurrentCulture, DateTimeStyles.None, out date))
                issues.Add("CREATE_TSTAMP");
            else
                row.CREATE_TSTAMP = date.ToString("yyyy-MM-dd HH:mm:ss");

            if (issues.Count() > 0)
            {
                row.Status = string.Format("Data Issue: {0}", string.Join(", ", issues));
                this.hasInvalidData = true;
            }
        }

        private void ValidateReasonCodeAndUtilityType(UsageResponseFileRow row)
        {
            var issues = new List<string>();

            if (string.IsNullOrWhiteSpace(row.REASON_CODE))
                issues.Add("No Reason Code");
            if (INTERVAL_USAGE_TYPE.Equals(row.USAGE_TYPE))
                issues.Add("Interval Data");

            if (issues.Count() > 0)
                row.Status = string.Join(", ", issues);
        }

        private void ValidateDuplicated(UsageResponseFileRow row)
        {
            if (this.usageResponseDao.Exists(row.UsageResponse))
                row.Status = "Duplicate";
        }

        private void ValidateDateSent(UsageResponseFileRow row)
        {
            if (!this.usageResponseDao.IsInLatestSentTransactions(row.UsageResponse.account_number, row.UsageResponse.utility_id))
                row.Status = "Not from Enrollment in 7 days";
        }

        private UsageResponse GetUsageResponse(UsageResponseFileRow row)
        {
            var utility = this.usageResponseDao.GetUtilityByTerritoryCode(row.TERRITORY_CODE);

            if (utility == null)
                throw new Exception(string.Format("The Utility for the Territory Code '{0}' was not found.", row.TERRITORY_CODE));

            var accountNubmer = this.GetAccountNumberByLdcAccountNum(row.LDC_ACCOUNT_NUM, utility.UtilityCode);

            return new UsageResponse
            {
                account_number = accountNubmer,
                external_id = 0,
                utility_id = utility.UtilityId,
                market_id = utility.MarketId,
                transaction_type = "814",
                action_code = utility.MarketId == 1 ? "27" : "HU",
                service_type2 = "HU",
                transaction_date = row.CREATE_TSTAMP.ToNonNullableDate(),
                request_date = null,
                direction = 1,
                request_or_response = "S",
                reject_or_accept = row.TYPE_DESC.Contains("Reject") ? 
                                   "R" : 
                                   row.TYPE_DESC.Contains("Accept") ? 
                                   "A" : null,
                reasoncode = row.REASON_CODE,
                reasontext = row.REASON_DESC,
                transaction_number = row.TRANS_ID,
                reference_transaction_number = row.ORIGINAL_TRANS_ID,
                AccountID = this.usageResponseDao.GetAccountId(accountNubmer, utility.UtilityId)
            };
        }

        private string GetAccountNumberByLdcAccountNum(string ldc_account_num, string utilityCode)
        {
            var utilities = new string[] { "CL&P", "WMECO" };
            var account = ldc_account_num;
            if (utilities.Contains(utilityCode) && ldc_account_num.Contains('-'))
                account = ldc_account_num.Split('-')[1];

            return account;
        }

        #endregion

    }
}
