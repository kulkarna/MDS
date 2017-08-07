using System;
using System.Linq;
using System.Data;
using LibertyPower.MarketDataServices.AccountWcfServiceData;
using LibertyPower.MarketDataServices.AccountRepository;
using LibertyPower.MarketDataServices.AccountDataMapper;
using UtilityLogging;

namespace LibertyPower.MarketDataServices.AccountBusinessLayer
{
    public class BusinessLayer : IBusinessLayer
    {
        #region private variables
        private const string NAMESPACE = "LibertyPower.MarketDataServices.AccountBusinessLayer";
        private const string CLASS = "BusinessLayer";
        private ILogger _logger;
        private IAccountRepository _sqlRepository;
        private DataMapper _dataMapper;
        #endregion

        #region public constructors
        public BusinessLayer(string messageId, IAccountRepository sqlRepository, DataMapper dataMapper, ILogger log)
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

        public AccountServiceResponse UpdateAnnualUsageBulk(string messageId, AnnualUsageTranRecordList anuualUsageList)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("UpdateAnnualUsageBulk(messageId:{0}", Utilities.Common.NullSafeString(messageId));
            try
            {

                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                // Invoke the service
                DataSet dataSet = _sqlRepository.UpdateAnnualUsageBulk(messageId, anuualUsageList);
                AccountServiceResponse requestResult = _dataMapper.MapDataSetForAnnualUsageUpdate(messageId, dataSet);
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return requestResult;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }
       
        public AccountServiceResponse GetEnrolledAccountsToProcess(string messageId, int numberOfAccounts)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("GetEnrolledAccountsToProcess(messageId:{0}, numberOfAccounts {1}", Utilities.Common.NullSafeString(messageId), numberOfAccounts);
            try
            {

                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                // Invoke the service
                DataSet dataSet = _sqlRepository.GetEnrolledAccountsToProcess(messageId, numberOfAccounts);
                AccountServiceResponse requestResult = _dataMapper.MapDataSetToGetEnrolledAccounts(messageId, dataSet);
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} Returning responseResult:{5} END {6} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(requestResult.Message), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return requestResult;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }
        
        public AccountServiceResponse PopulateEnrolledAccounts(string messageId)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("PopulateEnrolledAccounts(messageId:{0}", Utilities.Common.NullSafeString(messageId));
            try
            {

                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                // Invoke the service
                DataSet dataSet = _sqlRepository.PopulateEnrolledAccounts(messageId);
                AccountServiceResponse requestResult = _dataMapper.MapDataSetForPopulateAccounts(messageId, dataSet);
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
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
