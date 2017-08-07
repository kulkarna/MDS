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
using LibertyPower.MarketDataServices.AccountWcfServiceData;
using UsageManagementWcfServiceRepository;
using UsageWebService.Entities;

namespace AccountWcfServiceRepository
{
    /// <summary>
    /// Class AccountWcfServiceRepositoryManagement
    /// </summary>
    public class AccountWcfServiceRepositoryManagement : IAccountWcfServiceRepositoryManagement
    {
        #region private variables
        private const string NAMESPACE = "AccountWcfServiceRepositoryManagement";
        private const string CLASS = "AccountWcfServiceRepositoryManagement";
        private static ILogger _logger;
        private AccountWcfServiceClient _accountClient; 
        #endregion

        #region public constructors
        /// <summary>
        /// Initializes a new instance of the <see cref="UsageManagementWcfServiceRepositoryManagement"/> class.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        public AccountWcfServiceRepositoryManagement()
        {
            string method = "AccountWcfServiceRepositoryManagement(messageId)";
            string messageId = Guid.NewGuid().ToString();
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();
                _accountClient = new AccountWcfServiceClient();
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
        public AccountServiceResponse PopulateEnrolledAccounts(string messageId)
        {
            string method = string.Format("PopulateEnrolledAccounts(messageId", messageId);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2}PopulateEnrolledAccounts call BEGIN", NAMESPACE, CLASS, method));
                var accountResponse = _accountClient.PopulateEnrolledAccounts(messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} PopulateEnrolledAccounts END: Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                if (accountResponse.Code == "0000")
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} PopulateEnrolledAccounts Status:{3}", NAMESPACE, CLASS, method, accountResponse.Message));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    return accountResponse;
                }
                else
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} PopulateEnrolledAccounts ERROR:{3}", NAMESPACE, CLASS, method, accountResponse.Message));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    return accountResponse;
                }
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                var accountResponse = new AccountServiceResponse();
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return accountResponse;
            }
        }

        public AccountServiceResponse GetNextSetEnrolledAccounts(string messageId, int numberOfAccounts)
        { 
            string method = string.Format("GetNextSetEnrolledAccounts(messageId,numberOfAccounts:{0})", messageId);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                var accountResponse = new AccountServiceResponse();
                accountResponse = _accountClient.GetEnrolledAccountsToProcess(messageId, numberOfAccounts);
                return accountResponse;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                var accountResponse = new AccountServiceResponse();
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return accountResponse;
            }

        }
        public AccountServiceResponse UpdateAnnualUsageBulk(string messageId, AnnualUsageBulkResponse usageResponse)
        {
            string method = string.Format("UpdateAnnualUsageBulk(messageId,numberOfAccounts:{0})", messageId);
            DateTime beginTime = DateTime.Now;
            try
            {
                var accountList2 = usageResponse.UsageAccountList;
                int totalAccounts = accountList2.Count();
                AnnualUsageTranRecord[] annualUsage = new AnnualUsageTranRecord[totalAccounts];
                int p = 0;

                foreach (var updateAccount in accountList2)
                {
                    AnnualUsageTranRecord updateAccountRecord = new AnnualUsageTranRecord();
                    updateAccountRecord.AccountId = updateAccount.AccountId;
                    updateAccountRecord.AccountNumber = updateAccount.AccountNumber;
                    updateAccountRecord.UtilityId = updateAccount.UtilityId;
                    updateAccountRecord.AnnualUsage = updateAccount.Usage;

                    annualUsage.SetValue(updateAccountRecord, p);
                    p = p + 1;
                }

                ///Once the list is populated  Call the AccountWCF method update/Insert the Account usage data.
                //*************************************************************************
                var accountResponseUpdate = new AccountServiceResponse();    
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} UpdateAnnualUsageBulk Call BEGIN:", NAMESPACE, CLASS, method));
                accountResponseUpdate = _accountClient.UpdateAnnualUsageBulk(messageId, annualUsage);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} UpdateAnnualUsageBulk END: Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                return accountResponseUpdate;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                var accountResponseUpdate = new AccountServiceResponse();
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return accountResponseUpdate;
            }
        }
        
    }
}
