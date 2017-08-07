using System;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using System.ServiceModel;
using Common.Logging;
using LibertyPower.Business.CustomerManagement.AccountManagement;
using UsageEventAggregator.Helpers;
using UsageWebService.Repository;

namespace UsageWebService.Entities
{
    public class IdrUsageDateRequest
    {

        [DataMember]
        [Required]
        public string AppName { get; set; }
        [DataMember]
        public string MessageId { get; set; }
        [DataMember]
        [Required]
        public string AccountNumber { get; set; }
        [DataMember]
        [Required]
        public string  UtilityCode { get; set; }

        internal UsageDateResponse Execute()
        {
            DateTime beginTime = DateTime.Now;
            try
            {
                UsageDateResponse resultObject = new UsageDateResponse();
                var repository = Locator.Current.GetInstance<IRepository>();
                LogManager.GetCurrentClassLogger().Debug(string.Format("Idr Usage Date Request BEGIN: Utility: {0} account: {1}", UtilityCode, AccountNumber));
                
                var date = repository.GetIdrUsageDate(AccountNumber, UtilityCode);

                if (date == DateTime.MinValue.ToString())
                {
                    resultObject.MessageId = MessageId;
                    resultObject.Code = "7001";
                    resultObject.IsSuccess = false;
                    resultObject.Message = "Could not find any IDR meter reads";
                    resultObject.UsageDate = Convert.ToDateTime(date);
                    LogManager.GetCurrentClassLogger().Debug(string.Format("Idr Usage date request END: utility: {0} account: {1} AppName: {2} date: {3} Method Duration ms:{4} ", UtilityCode, AccountNumber, AppName, date.ToString(), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    return resultObject;
                }
                else
                {
                    resultObject.MessageId = MessageId;
                    resultObject.Code = "0000";
                    resultObject.IsSuccess = true;
                    resultObject.Message = "Success";
                    resultObject.UsageDate = Convert.ToDateTime(date);
                    LogManager.GetCurrentClassLogger().Debug(string.Format("Idr Usage date request END: utility: {0} account: {1} AppName: {2} date: {3} Method Duration ms:{4} ", UtilityCode, AccountNumber, AppName, date.ToString(), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    return resultObject;
                }
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                UsageDateResponse resultObject = new UsageDateResponse();
                resultObject.MessageId = MessageId;
                resultObject.Code = "9999";
                resultObject.IsSuccess = false;
                resultObject.Message = "A System Error Occured";
                resultObject.UsageDate = DateTime.MinValue;
                LogManager.GetCurrentClassLogger().Debug(string.Format("Idr Usage date requested Exception: {0} account: {1} Error: {2} Method Duration ms:{3}", UtilityCode, AccountNumber, errorMessage, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return resultObject;
            }
        } 
    }
}