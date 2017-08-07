using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibertyPower.MarketDataServices.UsageEclWcfServiceData;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;
namespace LibertyPower.MarketDataServices.UsageEclDataMapper
{
    public class DataMapper
    {
        #region private variables
        private const string NAMESPACE = "LibertyPower.MarketDataServices.UsageEclDataMapper";
        private const string CLASS = "DataMapper";
        private ILogger _logger;
        #endregion

        public DataMapper(string messageId, ILogger log)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("DataMapper(string messageId:{0}, ILog log)", Utilities.Common.NullSafeString(messageId));

            try
            {
                _logger = log;
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", DateTime.Now, messageId, NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }        
        }

        public IsIdrEligibleResponse MapDataSetToIsIdrEligibleResponse(string messageId, DataSet dataSet)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("MapDataSetToIsIdrEligibleResponse(string messageId:{0}, DataSet dataSet)", Utilities.Common.NullSafeString(messageId));

            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                IsIdrEligibleResponse resultObject = new IsIdrEligibleResponse()
                {
                    Code = "0000",
                    IsIdrEligibleFlag = Utilities.Common.IsDataSetRowValid(dataSet) && dataSet.Tables[0].Rows[0][0] != null && Utilities.Common.NullSafeInteger(dataSet.Tables[0].Rows[0][0]) > 0,
                    IsSuccess = true,
                    MessageId = messageId,
                    Message = "Success"
                };
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} returning resultObject:{5} END {6} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(resultObject), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return resultObject;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }

    }
}
