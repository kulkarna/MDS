using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibertyPower.MarketDataServices.EdiParserWcfServiceData;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;
namespace LibertyPower.MarketDataServices.EdiParserDataMapper
{
    public class DataMapper
    {
        #region private variables
        private const string NAMESPACE = "LibertyPower.MarketDataServices.EdiParserDataMapper";
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

        public GetBillGroupMostRecentResponse MapDataSetToGetBillGroupMostRecentResponse(string messageId, DataSet dataSet)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("MapDataSetToGetBillGroupMostRecentResponse(string messageId:{0}, DataSet dataSet)", Utilities.Common.NullSafeString(messageId));

            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                GetBillGroupMostRecentResponse resultObject = new GetBillGroupMostRecentResponse();
                string dbReturn = Utilities.Common.NullSafeString(dataSet.Tables[0].Rows[0][0]);
                if (dbReturn == "50000")
                {
                    resultObject.Code = "4001";
                    resultObject.BillGroup = "-1";
                    resultObject.IsSuccess = false;
                    resultObject.MessageId = messageId;
                    resultObject.Message = "No Data Returned ";

                }
                else
                {
                    resultObject.Code = "0000";
                    resultObject.BillGroup = Utilities.Common.NullSafeString(dataSet.Tables[0].Rows[0][0]); 
                    resultObject.IsSuccess = true;
                    resultObject.MessageId = messageId;
                    resultObject.Message = "Success";
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
