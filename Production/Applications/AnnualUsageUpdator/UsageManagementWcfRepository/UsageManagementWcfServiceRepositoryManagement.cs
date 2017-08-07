using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Configuration;
using Utilities;
using UtilityUnityLogging;
using UtilityLogging;
using UsageWebService.Entities;
using System.Reflection;
using LibertyPower.MarketDataServices.AccountWcfServiceData;


namespace UsageManagementWcfServiceRepository
{
    /// <summary>
    /// Class UsageManagementWcfServiceRepositoryManagement.
    /// </summary>
    public class UsageManagementWcfServiceRepositoryManagement : IUsageManagementWcfServiceRepositoryManagement
    {
        #region private variables
        private const string NAMESPACE = "UsageManagementWcfServiceRepository";
        private const string CLASS = "UsageManagement";
        private ILogger _logger;
        private UsageClient _usageClient;
        #endregion

        #region public constructors
        public UsageManagementWcfServiceRepositoryManagement()
        {
            string method = "UsageManagementWcfServiceRepositoryManagement(messageId)";
            string messageId = Guid.NewGuid().ToString();
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();
                _usageClient  = new UsageClient();
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
         
        /// <summary>
        /// Initializes a new instance of the <see cref="UsageManagementWcfServiceRepositoryManagement"/> class.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        #endregion
        public AnnualUsageBulkResponse GetAnnualUsageBulk(string messageId, AccountServiceResponse accountListInput)
        {
            string method = string.Format("GetAnnualUsageBulk(messageId,", messageId);
            DateTime beginTime = DateTime.Now;
            try
            {
                var accountList = accountListInput.AccountResultList;
                int totalAccounts = accountList.Count();
                UsageAccountRequest[] usageAccount = new UsageAccountRequest[totalAccounts];
                int i = 0;
                foreach (var account in accountList)
                {
                    //AnnualUsageBulkRequest request = new AnnualUsageBulkRequest();
                    UsageAccountRequest accountResult = new UsageAccountRequest();
                    accountResult.AccountId = account.AccountId; ;
                    accountResult.AccountNumber = account.AccountNumber;
                    accountResult.UtilityId = account.UtilityId;

                    usageAccount.SetValue(accountResult, i);
                    i = i + 1;
                }
                ///************************************************
                ///Now  we have the  list of accounts  for calling UsageWCF  to  get the  Annual Usage for the accounts
                AnnualUsageBulkResponse usageResponse = new AnnualUsageBulkResponse();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} GetAnnualUsageBulk Call BEGIN:", NAMESPACE, CLASS, method));
                usageResponse = _usageClient.GetAnnualUsageBulk(messageId, usageAccount);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} GetAnnualUsageBulk END: Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                return usageResponse;    
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                AnnualUsageBulkResponse usageResponse = new AnnualUsageBulkResponse();
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return usageResponse;
            }
        }
       
    }
}
