using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibertyPower.MarketDataServices.EdiParserRepository;
using LibertyPower.MarketDataServices.EdiParserWcfServiceData;
using LibertyPower.MarketDataServices.EdiParserDataMapper;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;



namespace LibertyPower.MarketDataServices.EdiParserBusinessLayer
{
    /// <summary>
    /// Class BusinessLayer.
    /// </summary>
    public class BusinessLayer : IBusinessLayer
    {
        #region private variables
        private const string NAMESPACE = "LibertyPower.MarketDataServices.EclBusinessLayer";
        private const string CLASS = "BusinessLayer";
        private ILogger _logger;
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
            DateTime beginTime = DateTime.Now;
            string method = string.Format("BusinessLayer(messageId:{0}, IRepository sqlRepository, DataMapper dataMapper)",
                Utilities.Common.NullSafeString(messageId));

            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();
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
        /// <param name="log">The class logs data implementing <see cref="ILogger"/></param>
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
        /// <returns>GetBillGroupMostRecentResponse  with the valid BillGroup for the AccountNumber/UtilityCode Combination </returns>
        public GetBillGroupMostRecentResponse GetBillGroupMostRecent(string messageId, string accountNumber, string utilitycd)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("GetBillGroupMostRecent(messageId:{0},accountNumber:{1},utilitycd:{2})", Utilities.Common.NullSafeString(messageId), Utilities.Common.NullSafeString(accountNumber), utilitycd);
            try
            {
               
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                // Invoke the service
                DataSet dataSet = _sqlRepository.GetBillGroupMostRecent(messageId, accountNumber, utilitycd);
                GetBillGroupMostRecentResponse requestResult = _dataMapper.MapDataSetToGetBillGroupMostRecentResponse(messageId, dataSet);
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} returning requestResult:{5} END {6} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
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