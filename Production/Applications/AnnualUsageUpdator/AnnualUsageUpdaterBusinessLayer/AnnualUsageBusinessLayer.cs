using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Utilities;
using UtilityUnityLogging;
using UtilityLogging;
using System.Reflection;
using UsageManagementWcfServiceRepository;
using AccountWcfServiceRepository;
using LibertyPower.MarketDataServices.AccountWcfServiceData;
using LibertyPower.MarketDataServices.AnnualUsageUpdatorRespository;
using UsageWebService.Entities;

namespace LibertyPower.MarketDataServices.AnnualUsageBusinessLayer
{
    /// <summary>
    /// Class AnnualUsageUpdatorRespositoryManagement
    /// </summary>
    public class BusinessLayer : IBusinessLayer
    {
        #region private variables
        private const string NAMESPACE = "AnnualUsageUpdatorRespository";
        private const string CLASS = "AnnualUsageUpdatorRespository";
        private static ILogger _logger;
        IAnnualUsageUpdatorRespositoryManagement _annualUsageUpdatorRespository;
        IAccountWcfServiceRepositoryManagement _accountWcfServiceRepository;
        IUsageManagementWcfServiceRepositoryManagement _usageWcfRepository;
       
        //IAnnualUsageBusinessLayer _annualUsageBusinessLayer;
        #endregion

        #region public constructors
        /// <summary>
        /// Initializes a new instance of the <see cref="UsageManagementWcfServiceRepositoryManagement"/> class.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        public BusinessLayer(string messageId, IAnnualUsageUpdatorRespositoryManagement annualUsageUpdatorRespository, IAccountWcfServiceRepositoryManagement accountWcfServiceRepository, IUsageManagementWcfServiceRepositoryManagement usageWcfRepository)
        {
            string method = "AnnualUsageUpdatorRespository(messageId)";
            //string messageId = Guid.NewGuid().ToString();
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();
                _annualUsageUpdatorRespository = annualUsageUpdatorRespository;
                _accountWcfServiceRepository = accountWcfServiceRepository;
                _usageWcfRepository = usageWcfRepository;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
               _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc));
               _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
         
        #endregion

        /// <summary>
        /// Process the account s to get the annual usage updated.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="numberOfAccounts">Thenumber of accounts to proces at a time int.</param>
        /// <returns>System.Int32.</returns>
        public int ProcessAccounts(string messageId, int numberOfAccounts)
        {
            string method = string.Format("ProcessAccounts(messageId,numberOfAccounts:{0})", messageId);
            //Step 2.  Get the number of (ChunkSize)  records from the table,using the service.
            //Step 3.  Call the annual USage service for the accounts, to get the calculated Annual usage for each Accounts
            //Step 4.  Call the AnnualUsageBulkUpdate  method using the AccountWCF service.
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
               
                int li_counter = 0;
                ///Looop through accounts until the Last set of record with 0 count reached.
                do
                {
                    DateTime beginTime = DateTime.Now;
                    AccountWcfServiceClient accountClient = new AccountWcfServiceClient();
                    var accountResponse = new AccountServiceResponse();
                    int totalAccounts;
                    ///Calling the AccountWCF service to get  Accounts to process
                    try
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} GetEnrolledAccount Call BEGIN:", NAMESPACE, CLASS, method));
                        accountResponse = _accountWcfServiceRepository.GetNextSetEnrolledAccounts(messageId, numberOfAccounts);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} GetEnrolledAccount END: Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                    }
                    catch (Exception exc) 
                    {
                        string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                        string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                        string errorMessage = exception + innerException;
                        _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    }

                    var accountList = accountResponse.AccountResultList;
                    totalAccounts = accountList.Count();
                    if (totalAccounts > 0)///This meand there is rows still to process
                    {
                         ///************************************************
                        ///Now  we have the  list of accounts  for calling UsageWCF  to  get the  Annual Usage for the accounts
                        AnnualUsageBulkResponse usageResponse = new AnnualUsageBulkResponse();
                        try
                        {
                            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} GetAnnualUsageBulk Call BEGIN:", NAMESPACE, CLASS, method));
                            //UsageClient usageClient = new UsageClient();
                            usageResponse = _usageWcfRepository.GetAnnualUsageBulk(messageId, accountResponse);
                            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} GetAnnualUsageBulk END: Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                        }
                        catch (Exception exc)
                        {
                            string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                            string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                            string errorMessage = exception + innerException;
                            _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                        }
                       
                        ///Once the list is populated  Call the AccountWCF method update/Insert the Account usage data.
                        //*************************************************************************
                        var accountResponseUpdate = new AccountServiceResponse();
                        try
                        {
                            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} UpdateAnnualUsageBulk Call BEGIN:", NAMESPACE, CLASS, method));
                            accountResponseUpdate = _accountWcfServiceRepository.UpdateAnnualUsageBulk(messageId, usageResponse);
                            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} UpdateAnnualUsageBulk END: Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                            li_counter = 0;
                        }
                        catch (Exception exc)
                        {
                            string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                            string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                            string errorMessage = exception + innerException;
                            _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                        }

                    }
                    else  ///No more accounts to process
                    {
                        li_counter = 1;
                    }
                } while (li_counter == 0);
                return 1;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return 0;
            }
        }
        public int PopulateEnrolledAccounts(string messageId)
        {
            string method = string.Format("PopulateEnrolledAccounts(messageId", messageId);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2}PopulateEnrolledAccounts call BEGIN", NAMESPACE, CLASS, method));
                var accountResponse = _accountWcfServiceRepository.PopulateEnrolledAccounts(messageId);
                 _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} PopulateEnrolledAccounts END: Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                if (accountResponse.Code == "0000")
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} PopulateEnrolledAccounts Status:{3}", NAMESPACE, CLASS, method, accountResponse.Message));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    return 1;
                }
                else
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} PopulateEnrolledAccounts ERROR:{3}", NAMESPACE, CLASS, method, accountResponse.Message)); 
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    return 0;
                }
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return 0;
            }
        }

        public int CheckjobStatus(string messageId, int numberOfDays)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("CheckjobStatus(NumberOfAccounts", numberOfDays.ToString());
            int liReturn = 0;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                DataSet dataSet = new DataSet();
                liReturn = _annualUsageUpdatorRespository.CheckjobStatus(messageId, numberOfDays);
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return liReturn;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                return 0;
            }
        }
        public string  GenerateReport(string messageId)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("MessageId", messageId);
            string lsMessage ;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                DataSet dataSet = new DataSet();
                 var UpdateReport = _annualUsageUpdatorRespository.GetUpdateReport(messageId);
                lsMessage = "Annual Usage Updator Process Completed." + "<br><br>"
                            + "Total Accounts Begin:" + UpdateReport.AccountBegin.ToString() +"<br><br>"
                            + "Total Accounts Processed:" + UpdateReport.AccountProcessed.ToString() +"<br><br>"
                            + "Total Accounts Pending:" + UpdateReport.AccountPending.ToString() +"<br><br>"
                            + "Total Accounts Updated:" + UpdateReport.AccountUpdated.ToString() +"<br><br>";
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return lsMessage;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                return "";
            }
        }
        
    }
}
