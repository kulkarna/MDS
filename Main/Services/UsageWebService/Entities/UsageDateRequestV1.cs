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
    public class UsageDateRequestV1
    {
        [DataMember]
        [Required]
        public string MessageId { get; set; }
        [DataMember]
        [Required]
        public string AccountNumber { get; set; }
        [DataMember]
        [Required]
        public string UtilityCode { get; set; }
     

        internal UsageDateResponse Execute()
        {
            DateTime beginTime = DateTime.Now;
            try
            {                
                UsageDateResponse resultObject = new UsageDateResponse();
                LogManager.GetCurrentClassLogger().Debug(string.Format("Usage Date Request BEGIN: Utility: {0} account: {1}", UtilityCode, AccountNumber));
                var date = CompanyAccountFactory.GetMostRecentMeterDate(AccountNumber, UtilityCode);

                if (date == DateTime.MinValue)
                {
                    resultObject.MessageId = MessageId;
                    resultObject.Code = "7001";
                    resultObject.IsSuccess = false;
                    resultObject.Message = "Could not find any meter reads";
                    resultObject.UsageDate = Convert.ToDateTime(date);
                    LogManager.GetCurrentClassLogger().Debug(string.Format("Usage date request END: for utility: {0} account: {1} date: {2} Method Duration ms:{3}", UtilityCode, AccountNumber, date.ToString(), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    return resultObject;
                }
                else
                {
                    resultObject.MessageId = MessageId;
                    resultObject.Code = "0000";
                    resultObject.IsSuccess = true;
                    resultObject.Message = "Success";
                    resultObject.UsageDate = Convert.ToDateTime(date);
                    LogManager.GetCurrentClassLogger().Debug(string.Format("Usage date request END: for utility: {0} account: {1} date: {2} Method Duration ms:{3}", UtilityCode, AccountNumber, date.ToString(), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
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
                resultObject.Message = "System Error Occured";
                resultObject.UsageDate = DateTime.MinValue;
                LogManager.GetCurrentClassLogger().Debug(string.Format("Usage date requested Exception: {0} account: {1} Error: {2} Method Duration ms:{3}", UtilityCode, AccountNumber, errorMessage, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return resultObject;
            }
        } 
    }
}