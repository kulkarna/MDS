using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UtilityLogging;
using UtilityUnityLogging;
using SmucDataLayer;
using System.Data;
using System.Data.SqlClient;
using SmucBusinessLayer.UsageServiceWcf;
using Utilities;
using System.Configuration;


namespace SmucBusinessLayer
{
    public class BulkRequestResponse
    {
        #region public properties
        public bool ReturnValue { get; set; }
        public Dictionary<string, string> Results { get; set; }
        public bool isScraper { get; set; }
        public bool isEdi { get; set; }
        public DataTable dtTransactions { get; set; }

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
        private const string NAMESPACE = "SmucBusinessLayer";
        private const string CLASS = "BusinessLayer";
        private const string LP_WorkSpace = "Workspace";
        private ILogger _logger;
        private IDal _dal = null;
        private string accountNumber = string.Empty;
        private string utilityCode = string.Empty;
        BulkRequestResponse bulkRequestResponse = new BulkRequestResponse();
        private DataTable dtTransactionID = new DataTable();

        private string _WorkSpaceConnectionString;
        #endregion
        public List<string> lstScrapperUtility = new List<string>() { "AMEREN", "BGE", "COMED", "CONED", "NYSEG", "RGE" };
        public List<string> ListScrapperUtility
        {
            get { return lstScrapperUtility; }
        }
        #region public constructors
        public BusinessLayer()
        {
            bulkRequestResponse.Results = new Dictionary<string, string>();
            _WorkSpaceConnectionString = ConfigurationManager.ConnectionStrings[LP_WorkSpace].ConnectionString;
            dtTransactionID.Columns.Add("TransactionId");
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

                bulkRequestResponse.Results = new Dictionary<string, string>();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _WorkSpaceConnectionString = ConfigurationManager.ConnectionStrings[LP_WorkSpace].ConnectionString;
                _dal = dal;
                dtTransactionID.Columns.Add("TransactionId");
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

        #region Public Methods
        public BulkRequestResponse RunProcess(string messageId, List<DataRecord> records)
        {
            string method = string.Format("RunProcess(List<DataRecord> records)");
            DataTable dt = new DataTable();
            dt = Helper.ConvertToDataTable(records, "TotalRecords");
            dt = _dal.Usp_GetAccountDetails(messageId, dt);

            dynamic lstScrapper = dt.AsEnumerable().Where
                                    (dr => ListScrapperUtility.Contains(Convert.ToString(dr["UtilityCode"])))
                                    .ToList();


            dynamic lstEdi = dt.AsEnumerable().Where
                                    (dr => !ListScrapperUtility.Contains(Convert.ToString(dr["UtilityCode"])))
                                    .ToList();



            if (lstScrapper.Count > 0)
            {
                bulkRequestResponse = BulkRequestWithResponse(messageId, lstScrapper, true, false);


            }

            if (lstEdi.Count > 0)
            {
                bulkRequestResponse = BulkRequestWithResponse(messageId, lstEdi, false, true);

            }
            return bulkRequestResponse;
        }

        public DataSet GetIso(string messageId)
        {
            string method = "GetNyiso(string messageId)";
            DateTime beginDate = DateTime.Now;
            DataSet dsResults;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                dsResults = _dal.Usp_GetIso(messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
            return dsResults;
        }
        public DataSet GetUtility(string messageId, string isoId)
        {
            string method = "GetUtility(string messageId, string isoId)";
            DateTime beginDate = DateTime.Now;
            DataSet dsResults;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                dsResults = _dal.Usp_GetUtilityByIso(messageId, isoId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
            return dsResults;

        }
        public DataSet GetResults(string messageId, string isoId, string utility, string accountNumber)
        {
            string method = string.Format("GetResults(string messageId,string isoId,string utility,string accountNumber )");
            DateTime beginDate = DateTime.Now;
            DataSet dsResults = new DataSet() ;

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                using (SqlConnection cn = new SqlConnection(_WorkSpaceConnectionString))
                {
                  //  using (SqlCommand sqlCommand = new SqlCommand("usp_VerifyIcapEffectiveDateFor2016and2017", cn))
                    using (SqlCommand sqlCommand = new SqlCommand("usp_VerifyIcapEffectiveDateFor2016and2017_test", cn))
                    {
                       
                        sqlCommand.Parameters.Add("@p_ISO", isoId);
                        sqlCommand.Parameters.Add("@p_UtilityCode", utility);
                        sqlCommand.Parameters.Add("@p_AccountNumber", accountNumber);
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dsResults);
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
            return dsResults;
        }


        #endregion

        #region Private Methods

        private void InsertResult(string messageId, string accountNumber, string result, DateTime dateCreated)
        {
            string method = string.Format("InsertResult(messageId,accountNumber:{0},result:{1},dateCreated:{2})", Utilities.Common.NullSafeString(accountNumber), Utilities.Common.NullSafeString(result), Utilities.Common.NullSafeDateToString(dateCreated));
            DateTime beginDate = DateTime.Now;

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                using (SqlConnection cn = new SqlConnection(_WorkSpaceConnectionString))
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

        public DataTable GetProcessingDetailByTransactionId(string messageId, DataTable transactionIds)
        {
            string method = "GetProcessingDetailByRecordId(string messageId, ,DataTable transactionIds)";
            DateTime beginDate = DateTime.Now;
            DataTable dtResults;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                dtResults = _dal.Usp_GetDetailsDetailsByTransactionId(messageId, transactionIds);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
            return dtResults;
        }

        private BulkRequestResponse BulkRequestWithResponse(string messageId, dynamic records, bool isScraperRequest, bool isEdiRequest)
        {
            string method = "BulkRequestWithResponse(string messageId, List<DataRecord> records)";
            DateTime beginDate = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                try
                {

                    string exceptions = string.Empty;
                    foreach (var dataRecord in records)
                    {
                        string accountNumber = dataRecord["AccountNumber"];
                        string utilityCode = dataRecord["UtilityCode"];
                        DataRow drRecord = dtTransactionID.NewRow();
                        try
                        {
                            UsageClient usClient = new UsageClient();
                            if (isScraperRequest)
                            {
                                try
                                {
                                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Calling Scraper", NAMESPACE, CLASS, method));
                                    ScraperUsageRequest scraperUsageRequest = new ScraperUsageRequest();
                                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} ScraperUsageRequest Created.", NAMESPACE, CLASS, method));
                                    string scraperUsageResponse = string.Empty;
                                    scraperUsageRequest.AccountNumber = Common.NullSafeString(accountNumber);
                                    scraperUsageRequest.UtilityId = Common.NullSafeInteger(dataRecord["UtilityId"]);
                                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2}  Calling usClient.RunScraper(scraperUsageRequest :{3}).", NAMESPACE, CLASS, method, ScraperRequestToString(scraperUsageRequest)));
                                    scraperUsageResponse = usClient.RunScraper(scraperUsageRequest);
                                    drRecord["TransactionId"] = scraperUsageResponse;

                                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2}  Called usClient.RunScraper(scraperUsageRequest :{3}) with Response :{4}.", NAMESPACE, CLASS, method, ScraperRequestToString(scraperUsageRequest), scraperUsageResponse));
                                    bulkRequestResponse.Results.Add(accountNumber, string.Format("Successfully Submitted For Scraper With Response Transaction No : {0}", scraperUsageResponse));
                                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Successfully Submitted For Scraper With Response Transaction No : {3}", NAMESPACE, CLASS, method, scraperUsageResponse));
                                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Scraper Called", NAMESPACE, CLASS, method));
                                }
                                catch (Exception exc)
                                {
                                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} Scraper ERROR exc.Message:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                                    exceptions = exc.Message;
                                    InsertResult(messageId, accountNumber, exceptions, DateTime.Now);
                                    bulkRequestResponse.Results.Add(accountNumber, string.Format("Request Fail Error Message : {0}", exceptions));
                                }

                            }
                            else if (isEdiRequest)
                            {
                                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Calling EdiRequest", NAMESPACE, CLASS, method));
                                try
                                {
                                    EdiUsageRequest ediUsageRequest = new UsageServiceWcf.EdiUsageRequest();
                                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Object Created For EdiUsageRequest", NAMESPACE, CLASS, method));
                                    string ediUsageResponse = string.Empty;
                                    ediUsageRequest.AccountNumber = Common.NullSafeString(accountNumber);
                                    ediUsageRequest.UtilityCode = Common.NullSafeString(utilityCode);
                                    ediUsageRequest.UsageType = "HU";
                                    ediUsageRequest.DunsNumber = Common.NullSafeString(dataRecord["DunsNumber"]);
                                    ediUsageRequest.NameKey = Common.NullSafeString(dataRecord["NameKey"]);
                                    ediUsageRequest.BillingAccountNumber = Common.NullSafeString(dataRecord["BillingAccount"]);
                                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Calling usClient.SubmitHistoricalUsageRequest(ediUsageRequest :{3})", NAMESPACE, CLASS, method, EdiRequestToString(ediUsageRequest)));

                                    ediUsageResponse = usClient.SubmitHistoricalUsageRequest(ediUsageRequest);
                                    drRecord["TransactionId"] = ediUsageResponse;
                                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} End Calling usClient.SubmitHistoricalUsageRequest(ediUsageRequest :{3}) with Response :{4}", NAMESPACE, CLASS, method, EdiRequestToString(ediUsageRequest), ediUsageResponse));
                                    bulkRequestResponse.Results.Add(accountNumber, string.Format("Successfully Submitted For Ista With Response Transaction No : {0}", ediUsageResponse));
                                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Successfully Submitted For Ista With Response Transaction No : {3}", NAMESPACE, CLASS, method, ediUsageResponse));
                                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Called EdiRequest", NAMESPACE, CLASS, method));

                                }
                                catch (Exception exc)
                                {
                                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} Scraper ERROR exc.Message:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                                    exceptions = exc.Message;
                                    InsertResult(messageId, accountNumber, exceptions, DateTime.Now);
                                    bulkRequestResponse.Results.Add(accountNumber, string.Format("Request Fail Error Message : {0}", exceptions));
                                }
                            }

                        }
                        catch (Exception ex)
                        {
                            InsertResult(messageId, "", ex.Message, DateTime.Now);
                            bulkRequestResponse.Results.Add(accountNumber, ex.Message);
                        }
                        dtTransactionID.Rows.Add(drRecord);
                    }

                }
                catch (Exception exc)
                {
                    InsertResult(messageId, "", exc.Message, DateTime.Now);
                    throw;
                }
                bulkRequestResponse.ReturnValue = true;
                bulkRequestResponse.isScraper = isScraperRequest;
                bulkRequestResponse.isEdi = isEdiRequest;
                bulkRequestResponse.dtTransactions = dtTransactionID;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} TimeElapsed:{3} return bulkRequestResponse END", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
                return bulkRequestResponse;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private static string ScraperRequestToString(ScraperUsageRequest scraperUsageRequest)
        {
            StringBuilder returnValue = new StringBuilder("ScraperRequestToString == NULL VALUE");
            if (scraperUsageRequest != null)
            {
                returnValue = new StringBuilder("ScraperRequestToString:{");
                returnValue.AppendFormat("  UtilityId:{0}", Utilities.Common.NullSafeString(scraperUsageRequest.UtilityId));

                returnValue.AppendFormat(", AccountNumber:{0}", Utilities.Common.NullSafeString(scraperUsageRequest.AccountNumber));

            }
            return returnValue.ToString();
        }

        private static string EdiRequestToString(EdiUsageRequest ediUsageRequest)
        {
            StringBuilder returnValue = new StringBuilder("EdiUsageRequestToString == NULL VALUE");
            if (ediUsageRequest != null)
            {
                returnValue = new StringBuilder("EdiUsageRequestToString:{");
                returnValue.AppendFormat("  UtilityCode:{0}", Utilities.Common.NullSafeString(ediUsageRequest.UtilityCode));
                returnValue.AppendFormat(", AccountNumber:{0}", Utilities.Common.NullSafeString(ediUsageRequest.AccountNumber));
                returnValue.AppendFormat(", DunsNumber:{0}", Utilities.Common.NullSafeString(ediUsageRequest.DunsNumber));
                returnValue.AppendFormat(", NameKey:{0}", Utilities.Common.NullSafeString(ediUsageRequest.NameKey));
                returnValue.AppendFormat(", BillingAccount:{0}", Utilities.Common.NullSafeString(ediUsageRequest.BillingAccountNumber));
                returnValue.AppendFormat(", UsageType:{0}", Utilities.Common.NullSafeString(ediUsageRequest.UsageType));

            }
            return returnValue.ToString();
        }
        #endregion
    }
}
