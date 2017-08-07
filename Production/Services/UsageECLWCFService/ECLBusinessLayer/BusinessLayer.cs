using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibertyPower.MarketDataServices.UsageEclRepository;
using LibertyPower.MarketDataServices.UsageEclWcfServiceData;
using LibertyPower.MarketDataServices.UsageEclDataMapper;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;


namespace LibertyPower.MarketDataServices.UsageEclBusinessLayer
{
    /// <summary>
    /// Class BusinessLayer.
    /// </summary>
    public class BusinessLayer : IBusinessLayer
    {
        #region private variables
        private const string NAMESPACE = "LibertyPower.MarketDataServices.EclBusinessLayer";
        private const string CLASS = "BusinessLayer";
        private  ILogger _logger;
        private IRepository  _sqlRepository;
        private DataMapper _dataMapper;
        #endregion

        #region public constructors
        /// <summary>
        /// Initializes a new instance of the <see cref="BusinessLayer"/> class.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="sqlRepository">The ecl wcf service repository management</param>
        /// <param name="dataMapper">The class which maps data between the repository and service layer data objects</param>
        public BusinessLayer(string messageId, IRepository sqlRepository, DataMapper dataMapper)
        {
            _logger = UnityLoggerGenerator.GenerateLogger();
           
            DateTime beginTime = DateTime.Now;
            string method = string.Format("BusinessLayer(messageId:{0}, IRepository sqlRepository, DataMapper dataMapper)",
                Utilities.Common.NullSafeString(messageId));

            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                _sqlRepository = sqlRepository;
                _dataMapper = dataMapper;
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="BusinessLayer"/> class.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="sqlRepository">The Ecl Wcf service repository management class implementing <see cref="IRepository"/> </param>
        /// <param name="dataMapper">The class <see cref="DataMapper"/> which maps data between the repository and service layer data objects</param>
        /// <param name="log">The class logs data implementing <see cref="ILog"/></param>
        public BusinessLayer(string messageId, IRepository sqlRepository, DataMapper dataMapper, ILogger log)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("BusinessLayer(messageId:{0}, IRepository sqlRepository, DataMapper dataMapper, ILog log)",
                Utilities.Common.NullSafeString(messageId));

            try
            {
                _logger = log;
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
              
                _dataMapper = dataMapper;
                _sqlRepository = sqlRepository;
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }
        #endregion




        #region public methods
        /// <summary>
        /// Is the account number for the utility specified by the utility id eligible for an interval data recorder meter
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="accountNumber">The account number</param>
        /// <param name="utilityId">The id for the specified utility</param>
        /// <returns>IsIdrEligibleResponse which specifies the success or failure of the call as well as </returns>
        public IsIdrEligibleResponse IsIdrEligible(string messageId, string accountNumber, int utilityId)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("IsIdrEligible(messageId:{0},accountNumber:{1},utilityId:{2})", Utilities.Common.NullSafeString(messageId), Utilities.Common.NullSafeString(accountNumber), utilityId);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                // Invoke the service
                DataSet dataSet = _sqlRepository.DoesEclDataExist(messageId, accountNumber, utilityId);
                IsIdrEligibleResponse requestResult = _dataMapper.MapDataSetToIsIdrEligibleResponse(messageId, dataSet);
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} Returning responseResult:{5} END {6} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(requestResult), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return requestResult;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }
        #endregion

    }
}