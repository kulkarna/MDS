using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Services.Protocols;

using EnrollmentBusiness;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using SmucRunDto;
using SmucRunDataAccessLayer;
using VOHBMSQLSERVER;
using VOHBMSQLSERVERHistoricalData;

using UtilityLogging;
using UtilityUnityLogging;
using Utilities;


namespace SmucRunBusinessLayer
{

    public class BulkEdiRequestResponse
    {
        #region public properties
        public bool ReturnValue { get; set; }
        public Dictionary<string, string> Results { get; set; }
        #endregion

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            bool isFirstTime = true;
            foreach (string key in Results.Keys)
            {
                if (!isFirstTime)
                {
                    stringBuilder.Append(",");
                }
                stringBuilder.AppendFormat("(Key:{0};Value:{1})", key, Results[key]);
                isFirstTime = false;
            }
            return string.Format("ReturnValue:{0};Results:[{1}]", ReturnValue, stringBuilder);
        }
    }

    public class BusinessLayer : IBusinessLayer
    {
        #region private variables
        private const string NAMESPACE = "SmucRunBusinessLayer";
        private const string CLASS = "BusinessLayer";
        private const string ICAP_SELECT_STATEMENT = "select ICap, TimeStampInsert DateCreated, UtilityCode Utilityid from LP_Transactions.dbo.EdiAccount (nolock) a where a.UtilityCode = '{0}' and a.AccountNumber = '{1}' and a.icap is not null";
        private const string TCAP_SELECT_STATEMENT = "select TCap, TimeStampInsert DateCreated, UtilityCode Utilityid from LP_Transactions.dbo.EdiAccount (nolock) a where a.UtilityCode = '{0}' and a.AccountNumber = '{1}' and a.tcap is not null";
        private const string ZONE_SELECT_STATEMENT = "select ZoneCode Zone, TimeStampInsert DateCreated, UtilityCode Utilityid from LP_Transactions.dbo.EdiAccount (nolock) a where a.UtilityCode = '{0}' and a.AccountNumber = '{1}' and ZoneCode is not null";
        private const string LOAD_PROFILE_SELECT_STATEMENT = "select fieldvalue AS LoadProfile, TimeStampInsert DateCreated, UtilityCode Utilityid from LP_Transactions.dbo.EdiAccount (nolock) a where a.UtilityCode = '{0}' and a.AccountNumber = '{1}' and a.loadprofile is not null";
        private const string RATE_CLASS_SELECT_STATEMENT = "select fieldvalue AS RateClass, TimeStampInsert DateCreated, UtilityCode Utilityid from LP_Transactions.dbo.EdiAccount (nolock) a where a.UtilityCode = '{0}' and a.AccountNumber = '{1}' and a.rateclass is not null";
        private const string TARIFF_CODE_SELECT_STATEMENT = "select fieldvalue AS TariffCode, TimeStampInsert DateCreated, UtilityCode Utilityid from LP_Transactions.dbo.EdiAccount (nolock) a where a.UtilityCode = '{0}' and a.AccountNumber = '{1}' and a.tariffcode is not null";
        private const string workspaceConnStr = "Data Source=LPCNOCSQLINT1\\PROD;Initial Catalog=Workspace;user id=sa;password=Sp@c3ch@1r";
        private const string ICAP = "icap";
        private const string TCAP = "tcap";
        private const string ZONE = "zone";
        private const string LOAD_PROFILE = "loadprofile";
        private const string RATE_CLASS = "rateclass";

        private string offerEngineConnStr = @"Data Source=LPCNOCSQLINT1\PROD;Initial Catalog=OfferEngineDB;user id=sa;password=Sp@c3ch@1r";
        private ILogger _logger;
        private IDal _dal = null;
        #endregion

        public StringBuilder Output { get; set; }
        public List<string> ListOfUtilityAccountNumberCombinations { get; set; }

        #region public constructors
        public BusinessLayer()
        {
        }

        public BusinessLayer(string messageId, ILogger logger, IDal dal)
        {
            string method = "BusinessLayer(messageId, logger, dal)";
            try
            {
                if (logger == null)
                {
                    _logger = UnityLoggerGenerator.GenerateLogger();
                }
                else
                {
                    _logger = logger;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                _dal = dal;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion


        #region public methods
        public void GetTransactionsData(string messageId, string utilityCode, string accountNumber)
        {
            string method = string.Format("GetTransactionsData(messageId,utilityCode:{0},accountNumber:{1})", Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(accountNumber));
            try
            {
                DateTime beginDateTime = DateTime.Now;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                ResultData resultData = new ResultData(messageId, _logger);

                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Calling Stored Procedures", NAMESPACE, CLASS, method));
                DataSet iCapDataSet = _dal.usp_EdiAccountICapByUtilityCodeAndAccountNumber(messageId, utilityCode, accountNumber);
                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Called usp_EdiAccountICapByUtilityCodeAndAccountNumber Stored Procedures", NAMESPACE, CLASS, method));
                DataSet tCapDataSet = _dal.usp_EdiAccountTCapByUtilityCodeAndAccountNumber(messageId, utilityCode, accountNumber);
                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Calling usp_EdiAccountTCapByUtilityCodeAndAccountNumber Stored Procedures", NAMESPACE, CLASS, method));
                DataSet zoneDataSet = _dal.usp_EdiAccountZoneByUtilityCodeAndAccountNumber(messageId, utilityCode, accountNumber);
                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Calling usp_EdiAccountZoneByUtilityCodeAndAccountNumber Stored Procedures", NAMESPACE, CLASS, method));
                DataSet loadProfileDataSet = _dal.usp_EdiAccountLoadProfileByUtilityCodeAndAccountNumber(messageId, utilityCode, accountNumber);
                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Calling usp_EdiAccountLoadProfileByUtilityCodeAndAccountNumber Stored Procedures", NAMESPACE, CLASS, method));
                DataSet rateClassDataSet = _dal.usp_EdiAccountRateClassByUtilityCodeAndAccountNumber(messageId, utilityCode, accountNumber);
                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Calling usp_EdiAccountRateClassByUtilityCodeAndAccountNumber Stored Procedures", NAMESPACE, CLASS, method));

                resultData = PopulateResultData(messageId, iCapDataSet, ICAP, resultData);
                resultData = PopulateResultData(messageId, tCapDataSet, TCAP, resultData);
                resultData = PopulateResultData(messageId, zoneDataSet, ZONE, resultData);
                resultData = PopulateResultData(messageId, loadProfileDataSet, LOAD_PROFILE, resultData);
                resultData = PopulateResultData(messageId, rateClassDataSet, RATE_CLASS, resultData);
                string key = string.Format("{0};{1}", utilityCode, accountNumber);
                if (!ListOfUtilityAccountNumberCombinations.Contains(key))
                {
                    ListOfUtilityAccountNumberCombinations.Add(key);
                    Output.AppendLine(resultData.ToString());
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDateTime).Milliseconds.ToString()));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public ResultData PopulateResultData(string messageId, DataSet dataSet, string fieldName, ResultData resultData)
        {
            if (dataSet != null && dataSet.Tables != null && dataSet.Tables.Count > 0 && dataSet.Tables[0] != null & dataSet.Tables[0].Rows != null && dataSet.Tables[0].Rows.Count > 0 && dataSet.Tables[0].Rows[0] != null)
            {
                foreach (DataRow dataRow in dataSet.Tables[0].Rows)
                {
                    resultData.PopulateDataRow(messageId, dataRow, fieldName);
                }
            }
            return resultData;
        }


        public MemoryStream Process(string messageId, byte[] byteArray)
        {
            string method = "MemoryStream Process(string messageId, byte[] byteArray)";
            DateTime beginDate = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                //TextToResultDataConverter textToResultDataConverter = new TextToResultDataConverter();
                string fileText = System.Text.Encoding.UTF8.GetString(byteArray);
                List<string> stringList = fileText.Replace("\r\n", ";").Split(';').ToList<string>();
                ListOfUtilityAccountNumberCombinations = new List<string>();

                Output = new StringBuilder();
                Output.AppendLine("UtilityCode,AccountNumber,AllValuesValid,ICapValue,ICapDate,IsNoICapPresent,TCapValue,TCapDate,IsNoTCapPresent,ZoneValue,ZoneDate,IsNoZonePresent,LoadProfileValue,LoadProfileDate,IsNoLoadProfilePresent,RateClassValue,RateClassDate,IsNoRateClassPresent");//,TariffCodeValue,TariffCodeDate,IsNoTariffCodePresent");

                foreach (string item in stringList)
                {
                    string[] recordItems = item.Split('\t');
                    if (recordItems.Length == 2)
                    {
                        GetTransactionsData(messageId, recordItems[1], recordItems[0]);
                    }
                }

                DateTime now = DateTime.Now;
                string outputName = string.Format("SmucKing{0}{1}{2}{3}{4}{5}{6}", now.Year, now.Month, now.Day, now.Hour, now.Minute, now.Second, now.Millisecond);

                MemoryStream memoryStream = ConvertStringToMemoryStream(messageId, Output.ToString());

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} TimeElapsed:{3} return memoryStream END", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
                return memoryStream;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public BulkEdiRequestResponse BulkEdiRequestWithResponse(string messageId, byte[] byteArray)
        {
            string method = "BulkEdiRequestWithResponse(messageId, byteArray)";
            DateTime beginDate = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                BulkEdiRequestResponse bulkEdiRequestResponse = new BulkEdiRequestResponse();
                bulkEdiRequestResponse.Results = new Dictionary<string, string>();
                try
                {

                    string fileText = System.Text.Encoding.UTF8.GetString(byteArray);
                    List<string> stringList = fileText.Replace("\r\n", ";").Split(';').ToList<string>();
                    string exceptions = string.Empty;
                    List<BulkEdiRequestResponse> response = new List<BulkEdiRequestResponse>();

                    foreach (string item in stringList)
                    {
                        ResultData resultData = new ResultData(messageId, _logger);
                        string[] recordItems = item.Split('\t');
                        if (recordItems.Length == 2 && recordItems[1].ToLower() != "utilitycode")
                        {
                            string accountNumber = recordItems[0];
                            string utilityCode = recordItems[1];

                            try
                            {
                                LibertyPower.DataAccess.WebServiceAccess.IstaWebService.UsageService.SubmitHistoricalUsageRequest(accountNumber, "", "SMUC", utilityCode);
                                bulkEdiRequestResponse.Results.Add(accountNumber, "Successfully submitted");
                            }
                            catch (Exception ex)
                            {
                                InsertResult(messageId, "", ex.Message, DateTime.Now);
                                bulkEdiRequestResponse.Results.Add(accountNumber, ex.Message);
                            }
                        }
                    }
                }
                catch (Exception exc)
                {
                    InsertResult(messageId, "", exc.Message, DateTime.Now);
                    throw;
                }
                bulkEdiRequestResponse.ReturnValue = true;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} TimeElapsed:{3} return bulkEdiRequestResponse END", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
                return bulkEdiRequestResponse;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }




        public bool BulkEdiRequest(byte[] byteArray)
        {
            string messageId = Guid.NewGuid().ToString();
            try
            {
                string fileText = System.Text.Encoding.UTF8.GetString(byteArray);
                List<string> stringList = fileText.Replace("\r\n", ";").Split(';').ToList<string>();
                string exceptions = string.Empty;

                foreach (string item in stringList)
                {
                    ResultData resultData = new ResultData(messageId, _logger);
                    string[] recordItems = item.Split('\t');

                    if (recordItems.Length == 2 && recordItems[1].ToLower() != "utilitycode")
                    {
                        InsertResult(messageId, recordItems[0], "if", DateTime.Now);
                        string accountNumber = recordItems[0];

                        string utilityCode = recordItems[1];

                        InsertResult(messageId, accountNumber, "call", DateTime.Now);
                        try
                        {
                            LibertyPower.DataAccess.WebServiceAccess.IstaWebService.UsageService.SubmitHistoricalUsageRequest(accountNumber, "", "SMUC", utilityCode);
                        }
                        catch (Exception ex)
                        {
                            InsertResult(messageId, "", ex.Message, DateTime.Now);
                        }
                        InsertResult(messageId, accountNumber, "after call", DateTime.Now);

                    }
                }
            }
            catch (Exception exc)
            {
                InsertResult(messageId, "", exc.Message, DateTime.Now);
                throw;
            }
            return true;
        }


        public bool BulkScraperRequest(string messageId, byte[] byteArray)
        {
            string method = "BulkScraperRequest(messageId,byteArray)";
            DateTime beginDate = DateTime.Now;

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                string fileText = System.Text.Encoding.UTF8.GetString(byteArray);
                List<string> stringList = fileText.Replace("\r\n", ";").Split(';').ToList<string>();

                foreach (string item in stringList)
                {
                    string exceptions = string.Empty;
                    ResultData resultData = new ResultData(messageId, _logger);
                    string[] recordItems = item.Split('\t');
                    if (recordItems.Length == 2 && recordItems[0].ToLower() != "accountnumber" && recordItems[1] != "utilitycode")
                    {
                        string account = recordItems[0];
                        string utility = recordItems[1];

                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} account:{3} utility:{4}", NAMESPACE, CLASS, method, account, utility));

                        try
                        {
                            _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Calling Scraper", NAMESPACE, CLASS, method));
                            var actual = ScraperFactory.RunScraper(account, utility, "", out exceptions);
                            _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Scraper Called", NAMESPACE, CLASS, method));
                        }
                        catch (Exception exc)
                        {
                            _logger.LogError(messageId, string.Format("{0}.{1}.{2} Scraper ERROR exc.Message:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                            exceptions = exc.Message;
                        }

                        InsertResult(messageId, account, exceptions, DateTime.Now);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return true END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));

                return true;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion


        #region
        private void InsertResult(string messageId, string accountNumber, string result, DateTime dateCreated)
        {
            string method = string.Format("InsertResult(messageId,accountNumber:{0},result:{1},dateCreated:{2})", Utilities.Common.NullSafeString(accountNumber), Utilities.Common.NullSafeString(result), Utilities.Common.NullSafeDateToString(dateCreated));
            DateTime beginDate = DateTime.Now;

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                using (SqlConnection cn = new SqlConnection(workspaceConnStr))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = cn;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_zzzIcapUpdateResultsInsert";

                        cmd.Parameters.Add(new SqlParameter("@PricingRequestID", String.Empty));
                        cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                        cmd.Parameters.Add(new SqlParameter("@Result", result));
                        cmd.Parameters.Add(new SqlParameter("@DateCreated", dateCreated));

                        cn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private MemoryStream ConvertStringToMemoryStream(string messageId, string output)
        {
            string method = string.Format("ConvertStringToMemoryStream(messageId,output:{0})", Utilities.Common.NullSafeString(output));
            DateTime beginDate = DateTime.Now;

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                using (MemoryStream memoryStream = new MemoryStream())
                {
                    using (StreamWriter streamWriter = new StreamWriter(memoryStream))
                    {
                        streamWriter.Write(output.ToString());
                        streamWriter.Flush();
                        return memoryStream;
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private void SendISTAUsageRequest(string pricingRequestId, ProspectDealVO prospectDealVO, string meterNumber)
        {
            int nameKeyLength = 0;
            string result = String.Empty;
            string spaces = "              ";
            string customerName = String.Empty;
            string appName = "OfferEngine";
            string accountNumber = prospectDealVO.AccountNumber;
            string messageId = Guid.NewGuid().ToString();

            try
            {
                // concatenate name key and customer name separated by a hyphen
                if (prospectDealVO.NameKey.Trim().Length > 0)
                {
                    try
                    {
                        DataSet ds = new DataSet();

                        using (SqlConnection cn = new SqlConnection(offerEngineConnStr))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = cn;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = "usp_name_key_required_length_by_utility_sel";

                                cmd.Parameters.Add(new SqlParameter("@p_utility_id", prospectDealVO.Utility.Trim()));

                                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                                    da.Fill(ds);
                            }
                        }
                        if (DataSetHelper.HasRow(ds))
                            nameKeyLength = Convert.ToInt32(ds.Tables[0].Rows[0]["required_length"]);
                    }
                    catch (Exception ex)
                    {
                        nameKeyLength = 0;
                    }

                    customerName = ((prospectDealVO.NameKey + spaces)).Substring(0, nameKeyLength) + "-" + prospectDealVO.AcctName;
                }
                else
                {
                    customerName = prospectDealVO.AcctName;
                }

                try
                {

                    LibertyPower.DataAccess.WebServiceAccess.IstaWebService.UsageService.SubmitHistoricalUsageRequest(accountNumber, "", appName, prospectDealVO.Utility);
                    result = "---Usage request successfully sent.";
                }
                catch (SoapException ex)
                {
                    string ie = string.Empty;
                    string ieMessage = string.Empty;
                    string innerException = string.Empty;
                    string innerExpectionMessage = string.Empty;
                    if (ex != null && ex.InnerException != null)
                    {
                        innerException = ex.InnerException.ToString();
                        innerExpectionMessage = ex.InnerException.Message;
                        if (ex.InnerException.InnerException != null)
                        {
                            ie = ex.InnerException.InnerException.ToString();
                            ieMessage = ex.InnerException.InnerException.Message;
                        }
                    }

                    result = "-1-1-1- Error: " + ex.Detail.InnerText + "; " + ex.Message ?? " NULL; " + innerException + "; " + ex.StackTrace ?? "NULL" + " ; " + ie + " ; " + ieMessage;

                }
                catch (Exception ex)
                {
                    string ie = string.Empty;
                    string ieMessage = string.Empty;
                    string innerException = string.Empty;
                    string innerExpectionMessage = string.Empty;
                    if (ex != null && ex.InnerException != null)
                    {
                        innerException = ex.InnerException.ToString();
                        innerExpectionMessage = ex.InnerException.Message;
                        if (ex.InnerException.InnerException != null)
                        {
                            ie = ex.InnerException.InnerException.ToString();
                            ieMessage = ex.InnerException.InnerException.Message;
                        }
                    }

                    result = "-2-2-2- Error: " + //ex.Detail.InnerText + 
                        "; ex.Message:" + ex.Message ?? " NULL" + " ; innerException:" + innerException + " ; ex.StackTrace" + ex.StackTrace ?? "NULL" + " ; id:" + ie + " ; ieMessage:" + ieMessage;
                }
            }
            catch (Exception ex)
            {
                string ie = string.Empty;
                string ieMessage = string.Empty;
                string innerException = string.Empty;
                string innerExpectionMessage = string.Empty;
                if (ex != null && ex.InnerException != null)
                {
                    innerException = ex.InnerException.ToString();
                    innerExpectionMessage = ex.InnerException.Message;
                    if (ex.InnerException.InnerException != null)
                    {
                        ie = ex.InnerException.InnerException.ToString();
                        ieMessage = ex.InnerException.InnerException.Message;
                    }
                }

                result = "-3-3-3- Error: " + //ex.Detail.InnerText + 
                    "; " + ex.Message ?? " NULL; " + innerException + "; " + ex.StackTrace ?? "NULL" + " ; " + ie + " ; " + ieMessage;
            }

            InsertResult(messageId, accountNumber, result, DateTime.Now);
        }
        #endregion
    }
}
