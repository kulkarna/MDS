using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.ServiceModel.Description;
using System.Text;
using LibertyPower.MarketDataServices.UsageEclBusinessLayer;
using LibertyPower.MarketDataServices.UsageEclWcfServiceData;
using LibertyPower.MarketDataServices.UsageEclRepository;
using LibertyPower.MarketDataServices.UsageEclDataMapper;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;

namespace LibertyPower.MarketDataServices.UsageEclWcfService
{

    public class UsageEclWcfService : IUsageEclWcfService
    {
        #region private variables
        private const string NAMESPACE = "LibertyPower.MarketDataServices.UsageEclWcfService";
        private const string CLASS = "UsageEclWcfService";
        private const string ERRORCODE = "9999";
        private const string INVALIDINPUTPARAMETER = "7777";
        private const string NOVALUERETURNED = "4001";
        private const string ERRORMESSAGE = "An Error Occurred While Processing The Service Call";
         private IBusinessLayer _businessLayer;
        private IRepository _sqlRepository;
        private DataMapper _dataMapper;
        private ILogger _logger;
        #endregion
          
        #region public constructors
        public UsageEclWcfService()
        {
            string messageId = Guid.NewGuid().ToString();
            DateTime beginTime = DateTime.Now;
            string method = "UsageEclWcfService()";
     
            try
            {
                // declare local variables
                _logger = UnityLoggerGenerator.GenerateLogger();
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), messageId, NAMESPACE, CLASS, method));
                              
                _dataMapper = new DataMapper(messageId, _logger);
                _sqlRepository = new SqlRepository(messageId, _logger);
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
        /// <summary>
        /// Determines whether the user provided account number and utility id are eligible for an interval data recorder meter
        /// </summary>
        /// <param name="messageId">The transaction id for this call</param>
        /// <param name="accountNumber">The account number for which we are determining idr eligibility</param>
        /// <param name="utilityId">The integer id for the specified utility</param>
        /// <returns>IsIdrEligibleResponse, whose IsIdrEligible property is true if the utility/account number combination are eligible for an idr meter and is false if the utility/account number combination are not eligible for an idr meter</returns>
        public IsIdrEligibleResponse IsIdrEligible(string messageId, string accountNumber, int utilityId)
        {
            string method = string.Format("IsIdrEligible(messageId:{0},accountNumber:{1},utilityId:{2})", 
                Utilities.Common.NullSafeString(messageId), Utilities.Common.NullSafeString(accountNumber), Utilities.Common.NullSafeInteger(utilityId));
            DateTime beginTime = DateTime.Now;
            IsIdrEligibleResponse responseResult;

            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                // validate input parameters
                if (accountNumber == null)
                {
                    responseResult = new IsIdrEligibleResponse()
                    {
                        Code = INVALIDINPUTPARAMETER,
                        IsIdrEligibleFlag = false,
                        IsSuccess = false,
                        Message = "Invalid Input - Account Number Was NULL",
                        MessageId = messageId
                    };
                    return responseResult;
                }

                if (utilityId < 1)
                {
                    responseResult = new IsIdrEligibleResponse()
                    {
                        Code = INVALIDINPUTPARAMETER,
                        IsIdrEligibleFlag = false,
                        IsSuccess = false,
                        Message = "Invalid Input - Utility Id Less Than 1",
                        MessageId = messageId
                    };
                    return responseResult;
                }

                //Invoke the businesslayer method to retrieve the IsIdrEligible value
                    responseResult = _businessLayer.IsIdrEligible(messageId, accountNumber, utilityId);
                    _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} Returning responseResult:{5} END {6} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(responseResult), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return responseResult;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6}", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace)));
                responseResult = new IsIdrEligibleResponse()
                {
                    IsSuccess = false,
                    IsIdrEligibleFlag = false,
                    MessageId = messageId,
                    Message = string.Format("Error Message: ","Server Error", "Error Accessing the service. Please contact the Administrator"),
                    Code = ERRORCODE
                };
                 _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} Returning responseResult:{5} END {6} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(responseResult), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
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
