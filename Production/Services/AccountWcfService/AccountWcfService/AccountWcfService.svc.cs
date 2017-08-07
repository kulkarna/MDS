using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using LibertyPower.MarketDataServices.AccountWcfServiceData;
using LibertyPower.MarketDataServices.AccountBusinessLayer;
using LibertyPower.MarketDataServices.AccountRepository;
using LibertyPower.MarketDataServices.AccountDataMapper;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;

namespace LibertyPower.MarketDataServices.AccountWcfService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select Service1.svc or Service1.svc.cs at the Solution Explorer and start debugging.
    public class AccountWcfService : IAccountWcfService
    {
         #region private variables;
        private const string NAMESPACE = "LibertyPower.MarketDataServices.AccountWcfService";
        private const string CLASS = "AccountWcfService";
        private const string ERRORCODE = "9999";
        private const string INVALIDINPUTPARAMETER = "7777";
        private const string NOVALUERETURNED = "4001";
        private const string ERRORMESSAGE = "An Error Occurred While Processing The Service Call";
        private IBusinessLayer _businessLayer;
        private IAccountRepository _sqlRepository;
        private DataMapper _dataMapper;
        private ILogger _logger;
        #endregion

        #region public constructors
        /// <summary>
        /// Initializes a new instance of the <see cref="MarketService"/> class.
        /// </summary>
        public AccountWcfService()
        {
            string messageId = Guid.NewGuid().ToString();
            DateTime beginTime = DateTime.Now;
            string method = "AccountWcfService()";
            
            try
            {
                // declare local variables
                _logger = UnityLoggerGenerator.GenerateLogger();
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), messageId, NAMESPACE, CLASS, method));
                
                _dataMapper = new DataMapper(messageId, _logger);
                _sqlRepository = new AccountServiceRepository(messageId, _logger); 
                _businessLayer = new BusinessLayer(messageId, _sqlRepository, _dataMapper, _logger);
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), messageId, NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), messageId, NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), messageId, NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }
        #endregion

        #region public methods
        public AccountServiceResponse UpdateAnnualUsageBulk(string messageId, AnnualUsageTranRecordList anuualUsageList)
         {
             string method = string.Format("UpdateAnnualUsageBulk(messageId:{0})", messageId);
             DateTime beginTime = DateTime.Now;
             try
             {
                 _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                 AccountServiceResponse responseResult = new AccountServiceResponse();

                 responseResult = _businessLayer.UpdateAnnualUsageBulk(messageId, anuualUsageList);

                 _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                 return responseResult;
             }

             catch (Exception exc)
             {

                 string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                 string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                 string errorMessage = exception + innerException;
                 _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                 _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                   AccountServiceResponse responseResult = new AccountServiceResponse()
                 {
                     IsSuccess = false,
                     Message = "A System Error Occured",
                     Code = "9999",
                     MessageId = messageId,
                 };
                 _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                 return responseResult;

             }
         }
       
        public AccountServiceResponse GetEnrolledAccountsToProcess(string messageId, int numberOfAccounts)
        {
            string method = string.Format("GetEnrolledAccountsToProcess(messageId:{0},NumberOfAccounts{1} )", messageId, numberOfAccounts);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                AccountServiceResponse responseResult = new AccountServiceResponse();
                
                responseResult = _businessLayer.GetEnrolledAccountsToProcess(messageId, numberOfAccounts);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return responseResult;
            }

            catch (Exception exc)
            {

                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                AccountServiceResponse responseResult = new AccountServiceResponse()
                {
                    IsSuccess = false,
                    Message = "A System Error Occured",
                    Code = "9999",
                    MessageId = messageId
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return responseResult;

            }
        }
        public AccountServiceResponse PopulateEnrolledAccounts(string messageId)
        {
            string method = string.Format("PopulateEnrolledAccounts(messageId:{0})", messageId);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                AccountServiceResponse responseResult = new AccountServiceResponse();

                responseResult = _businessLayer.PopulateEnrolledAccounts(messageId);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return responseResult;
            }

            catch (Exception exc)
            {

                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                AccountServiceResponse responseResult = new AccountServiceResponse()
                {
                    IsSuccess = false,
                    Message = "A System Error Occured",
                    Code = "9999",
                    MessageId = messageId
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return responseResult;

            }
        }

        public bool IsServiceRunning()
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "IsServiceRunning()";
            DateTime beginTime = DateTime.Now;
            try
            {

                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} Returning true END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6}", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace)));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw ex;
            }
        }

        public string Version()
        {
            return Assembly.GetExecutingAssembly().GetName().Version.ToString();
        }
        #endregion
    }
}
