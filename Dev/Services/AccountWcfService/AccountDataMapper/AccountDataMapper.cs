using System;
using System.Data;
using System.Linq;
using LibertyPower.MarketDataServices.AccountWcfServiceData;
using Utilities;
using UtilityLogging;

namespace LibertyPower.MarketDataServices.AccountDataMapper
{
    public class DataMapper
    {
        #region private variables
        private const string NAMESPACE = "LibertyPower.MarketDataServices.AccountDataMapper";
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
        public AccountServiceResponse MapDataSetForPopulateAccounts(string messageId, DataSet dataSet)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("MapDataSetForPopulateAccounts(string messageId:{0}, DataSet dataSet)", Utilities.Common.NullSafeString(messageId));
            AccountServiceResponse resultObject = new AccountServiceResponse();
            try
            {
                //Setting the variables.
                if (dataSet == null)
                {
                    resultObject.IsSuccess = false;
                    resultObject.Message = "System Error Occured";
                    resultObject.Code = "9999";
                    resultObject.MessageId = messageId;
                    resultObject.AccountResultList = null;
                }
                else
                {
                    resultObject.IsSuccess = true;
                    resultObject.Message = "Success";
                    resultObject.Code = "0000";
                    resultObject.MessageId = messageId;
                    resultObject.AccountResultList = null;
                }

                return resultObject;
            }
            ////**************************************************************************
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                resultObject.IsSuccess = false;
                resultObject.Message = "System Error Occured";
                resultObject.Code = "9999";
                resultObject.MessageId = messageId;
                resultObject.AccountResultList = null;
                return resultObject;
            }
        }
        public AccountServiceResponse MapDataSetForAnnualUsageUpdate(string messageId, DataSet dataSet)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("MapDataSetForAnnualUsageUpdate(string messageId:{0}, DataSet dataSet)", Utilities.Common.NullSafeString(messageId));
            AccountServiceResponse resultObject = new AccountServiceResponse();
            try
            {
                //Setting the variables.
                AnnualUsageTranRecordList ResultList = new AnnualUsageTranRecordList();
                if (dataSet != null)
                {
                    resultObject.IsSuccess = true;
                    resultObject.Message = "Success";
                    resultObject.Code = "0000";
                    resultObject.MessageId = messageId;
                    resultObject.AccountResultList = null;
                }
                else
                {
                    resultObject.IsSuccess = false;
                    resultObject.Message = "System Error Occured";
                    resultObject.Code = "9999";
                    resultObject.MessageId = messageId;
                    resultObject.AccountResultList = null;
                }

                return resultObject;
            }
            ////**************************************************************************
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                resultObject.IsSuccess = false;
                resultObject.Message = "System Error Occured";
                resultObject.Code = "9999";
                resultObject.MessageId = messageId;
                resultObject.AccountResultList = null;
                return resultObject;
            }
        }

        public AccountServiceResponse MapDataSetToGetEnrolledAccounts(string messageId, DataSet dataSet)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("MapDataSetToGetEnrolledAccounts(string messageId:{0}, DataSet dataSet)", Utilities.Common.NullSafeString(messageId));
            AccountServiceResponse resultObject = new AccountServiceResponse();
            try
            {
                 //Setting the variables.
                AnnualUsageTranRecordList ResultList = new AnnualUsageTranRecordList();
                DataTable dtAccounts;
                if ((dataSet != null) && (dataSet.Tables != null) 
                    && (dataSet.Tables.Count > 0) && (dataSet.Tables[0].Rows != null) 
                    && dataSet.Tables[0].Rows.Count > 0)
                {
                    dtAccounts = dataSet.Tables[0];
                    DataRow dr1 = dtAccounts.Rows[0];
                    string ErrorNumber = dr1.ItemArray[1].ToString();

                    if (ErrorNumber == "1") ///This  means  there is an Error from DB for the stored Procedure
                    {

                        resultObject.IsSuccess = false;
                        resultObject.Message = dr1.ItemArray[5].ToString();
                        resultObject.Code = "9999";
                        resultObject.MessageId = messageId;

                    }
                    else
                    {
                        foreach (DataRow dr in dtAccounts.Rows)
                        {
                            AnnualUsageTranRecord accountResult = new AnnualUsageTranRecord();
                            accountResult.AccountId = Convert.ToInt32(dr["AccountId"]);
                            accountResult.AccountNumber = dr["AccountNumber"].ToString();
                            accountResult.UtilityId = Convert.ToInt32(dr["UtilityId"]);
                            ResultList.Add(accountResult);
                        }
                        resultObject.AccountResultList = ResultList;
                        resultObject.MessageId = messageId;
                        resultObject.IsSuccess = true;
                        resultObject.Message = "Success";
                        resultObject.Code = "0000";
                    }
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2}.{3} END", NAMESPACE, CLASS, method, Common.NullSafeString(messageId)));
                    
                }
                else
                {
                    resultObject.IsSuccess = false;
                    resultObject.Message = "No Results Found";
                    resultObject.Code = "7001";
                    resultObject.MessageId = messageId;
                }
                return resultObject;
            }
                ////**************************************************************************
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                resultObject.IsSuccess = false;
                resultObject.Message = "System Error Occured";
                resultObject.Code = "9999";
                resultObject.MessageId = messageId;
                return resultObject;
            }
        }

    }
}
