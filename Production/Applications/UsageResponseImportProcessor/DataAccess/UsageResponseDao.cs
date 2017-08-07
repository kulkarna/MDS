using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UsageResponseImportProcessor.DataAccess.Base;
using UsageResponseImportProcessor.Entities;
using UsageResponseImportProcessor.Help;

namespace UsageResponseImportProcessor.DataAccess
{
    public class UsageResponseDao : IUsageResponseDao
    {
        private ISqlRunner runner;

        public UsageResponseDao(ISqlRunner runner)
        {
            if (runner == null)
                throw new ArgumentNullException("runner");

            this.runner = runner;
        }

        #region Constants

        /// <summary>
        /// The max level of inner exceptio to describe.
        /// </summary>
        private const int MaxInnerExeceptionLevel = 3;

        #endregion

        public void Save(UsageResponseFile usageResponseFile)
        {
            var results =
                runner
                .ExecuteProcedure(
                    "usp_UsageResponseFileInsert",
                    new
                    {
                        @FileName = usageResponseFile.FileName,
                        @Status = usageResponseFile.Status
                    }
                );

            if (usageResponseFile.Rows != null)
                usageResponseFile
                .Rows
                .ForEach(row => this.Save(row, results.GetScalarInt()));
        }

        public void Save(UsageResponseFileRow row, int fileId)
        {
            runner
                .ExecuteProcedure(
                    "usp_UsageResponseFileRowInsert",
                    new
                    {
                        @UsageResponseFileId = fileId,
                        @CUSTOMER_PROSPECT_TKN = row.CUSTOMER_PROSPECT_TKN,
                        @CUSTOMER_PROSPECT_ACCOUNT_TKN = row.CUSTOMER_PROSPECT_ACCOUNT_TKN,
                        @TERRITORY_CODE = row.TERRITORY_CODE,
                        @LDC_ACCOUNT_NUM = row.LDC_ACCOUNT_NUM,
                        @STATUS_DESC = row.STATUS_DESC,
                        @CREATE_TSTAMP = row.CREATE_TSTAMP,
                        @TRANS_ID = row.TRANS_ID,
                        @ORIGINAL_TRANS_ID = row.ORIGINAL_TRANS_ID,
                        @TYPE_DESC = row.TYPE_DESC,
                        @REASON_CODE = row.REASON_CODE,
                        @REASON_DESC = row.REASON_DESC,
                        @USAGE_TYPE = row.USAGE_TYPE,
                        @Status = row.Status
                    }
                );
        }

        public void Save(UsageResponse usageResponse)
        {
            runner
                .ExecuteProcedure(
                    "usp_EDI_814_transaction_Insert",
                    new
                    {
                        @account_number = usageResponse.account_number,
                        @external_id = usageResponse.external_id,
                        @utility_id = usageResponse.utility_id,
                        @market_id = usageResponse.market_id,
                        @transaction_type = usageResponse.transaction_type,
                        @action_code = usageResponse.action_code,
                        @service_type2 = usageResponse.service_type2,
                        @transaction_date = usageResponse.transaction_date,
                        @request_date = usageResponse.request_date,
                        @direction = usageResponse.direction,
                        @request_or_response = usageResponse.request_or_response,
                        @reject_or_accept = usageResponse.reject_or_accept,
                        @reasoncode = usageResponse.reasoncode,
                        @reasontext = usageResponse.reasontext,
                        @transaction_number = usageResponse.transaction_number,
                        @reference_transaction_number = usageResponse.reference_transaction_number,
                        @AccountID = usageResponse.AccountID
                    }
                );
        }

        public void Log(Exception exception)
        {
            runner
                .ExecuteProcedure(
                    "usp_UsageResponseImportProcessorLogInsert",
                    new
                    {
                        @Exception = DescribeException(exception)
                    }
                );
        }

        public void Log(Exception exception, string fileName)
        {
            runner
                .ExecuteProcedure(
                    "usp_UsageResponseImportProcessorLogInsert",
                    new
                    {
                        @Exception = DescribeException(exception),
                        @FileName = fileName
                    }
                );
        }

        public void Log(Exception exception, string fileName, int rowNumber)
        {
            runner
                .ExecuteProcedure(
                    "usp_UsageResponseImportProcessorLogInsert",
                    new
                    {
                        @Exception = DescribeException(exception),
                        @FileName = fileName,
                        @RowNumber = rowNumber
                    }
                );
        }
        
        public Utility GetUtilityByTerritoryCode(string territoryCode)
        {
            var results =
                runner
                .ExecuteProcedure(
                    "usp_UtilityManagementCacheByTerritoryCodeSelect",
                    new
                    {
                        @TerritoryCode = territoryCode
                    }
                );

            if (results != null && results.Count() > 0)
            {
                var row = results.GetFirstRow();

                return new Utility
                {
                    UtilityId = row.UtilityID,
                    TerritoryCode = territoryCode,
                    UtilityCode = row.UtilityCode,
                    MarketName = row.Market,
                    MarketId = row.MarketId
                };
            }

            return null;
        }
        
        public int? GetAccountId(string accountNumber, int utilityId)
        {
            var results =
                runner
                .ExecuteProcedure(
                    "usp_AccountInfoByAccountNumberAndUtilityIdSelect",
                    new
                    {
                        @AccountNumber = accountNumber,
                        @UtilityID = utilityId
                    }
                );

            return results != null && results.Count() > 0 ?
                (int)results.GetFirstRow().AccountID : (int?)null;
        }

        public bool Exists(UsageResponse usageResponse)
        {
            var results =
                runner
                .ExecuteProcedure(
                    "usp_EDI_814_transaction_Select",
                    new
                    {
                        @account_number = usageResponse.account_number,
                        @utility_id = usageResponse.utility_id,
                        @transaction_type = usageResponse.transaction_type,
                        @action_code = usageResponse.action_code,
                        @service_type2 = usageResponse.service_type2,
                        @transaction_date = usageResponse.transaction_date,
                        @request_date = usageResponse.request_date,
                        @direction = usageResponse.direction,
                        @request_or_response = usageResponse.request_or_response,
                        @reject_or_accept = usageResponse.reject_or_accept,
                        @reasoncode = usageResponse.reasoncode,
                        @reasontext = usageResponse.reasontext,
                        @transaction_number = usageResponse.transaction_number,
                        @reference_transaction_number = usageResponse.reference_transaction_number
                    }
                );

            return results != null && results.Count() > 0;
        }
        
        public bool IsInLatestSentTransactions(string accountNumber, int utilityId)
        {
            var results =
                runner
                .ExecuteProcedure(
                    "usp_GetLatestSentTransactionsRequest",
                    new
                    {
                        @AccountNumber = accountNumber,
                        @UtilityID = utilityId
                    }
                );

            return results != null && results.Count() > 0;
        }

        public DateTime? GetLatestUsageResponseCreatedTimeStamp()
        {
            var results =
                runner
                .ExecuteProcedure(
                    "usp_GetLatestUsageResponseCreatedTimeStamp",
                    new
                    {
                    }
                );

            if (results != null && results.Count() > 0)
            {
                if (results.GetFirstRow().Date == null)
                    return DateTime.MinValue;
                else
                    return DateTime.Parse(results.GetFirstRow().Date);
                
            }

            return DateTime.MinValue;
        }

        #region Auxiliary

        /// <summary>
        /// Describes the provided exception and it inner exceptions, up to the max level.
        /// </summary>
        /// <param name="exception">Exception to describe.</param>
        /// <param name="level">Level (inner exceptions) currently being described.</param>
        /// <returns>The description fo the supplied exception.</returns>
        private string DescribeException(Exception exception, int level = 1)
        {
            string output = "";

            output += exception.Message + System.Environment.NewLine;
            output += exception.StackTrace + System.Environment.NewLine;
            output += System.Environment.NewLine;

            if (exception.InnerException != null && level < MaxInnerExeceptionLevel)
                output += DescribeException(exception.InnerException, level + 1);

            return output;
        }

        #endregion
    }
}
