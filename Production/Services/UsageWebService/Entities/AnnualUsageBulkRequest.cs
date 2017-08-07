using System;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using System.ServiceModel;
using Common.Logging;
using LibertyPower.Business.CustomerManagement.AccountManagement;
using UsageEventAggregator.Helpers;
using UsageWebService.Repository;
using System.Collections.Generic;
using System.Data;
using System.Threading;
using System.Threading.Tasks;
using System.Configuration;

namespace UsageWebService.Entities
{
    public class AnnualUsageBulkRequest
    {
        [DataMember]
        [Required]
        public string MessageId { get; set; }
        [DataMember]
        [Required]
        public UsageAccountResponseList AnnualUsageList { get; set; }
        private static string threadCount = ConfigurationManager.AppSettings["ThreadCount"];
      
        internal AnnualUsageBulkResponse Execute(string messageId, UsageAccountRequestList usageAccountList)
        {
            var repository = Locator.Current.GetInstance<IRepository>();
           
            UsageAccountResponseList ResponseUsageList = new UsageAccountResponseList();
            AnnualUsageBulkResponse resultObject = new AnnualUsageBulkResponse();
            int threadCnt = Convert.ToInt32(threadCount);

            var usageList = AnnualUsageList;
            DateTime beginTime = DateTime.Now;
            LogManager.GetCurrentClassLogger().Debug(string.Format("AnnualUsageBulk Request BEGIN: MessageId: {0} ", messageId));
            ////Get the anual Usage for Each AccouNumber/UtilityId combination/Invocking the method
            try
            {
                Parallel.ForEach(usageAccountList, new ParallelOptions { MaxDegreeOfParallelism = threadCnt }, usage =>
                {
                    UsageAccountResponse responseAnnualUsage = new UsageAccountResponse();
                    string accountNumber = usage.AccountNumber;
                    var code = repository.GetUtilityCode(usage.UtilityId);
                    int liusage;

                    if (!CompanyAccountFactory.CalculateAnnualUsage(accountNumber, code, out liusage))
                    {
                        liusage = 0;
                    }
                    responseAnnualUsage.AccountId = usage.AccountId;
                    responseAnnualUsage.AccountNumber = usage.AccountNumber;
                    responseAnnualUsage.UtilityId = usage.UtilityId;
                    responseAnnualUsage.Usage = liusage;
                    lock (ResponseUsageList)
                    {
                        ResponseUsageList.Add(responseAnnualUsage);
                    }
                });

                ////Now we have the list of accounts with the annual UsagePopulated.
                resultObject.MessageId = messageId;
                resultObject.Code = "0000";
                resultObject.IsSuccess = true;
                resultObject.Message = "Success";
                resultObject.UsageAccountList = ResponseUsageList;

                LogManager.GetCurrentClassLogger().Debug(string.Format("AnnualUsageBulk request END: for MessageId: {0} Method Duration ms:{1}", messageId, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));

                return resultObject;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                resultObject.MessageId = messageId;
                resultObject.Code = "9999";
                resultObject.IsSuccess = false;
                resultObject.Message = "System Error Occured";
                resultObject.UsageAccountList = null;
                LogManager.GetCurrentClassLogger().Debug(string.Format("AnnualUsageBulk requested Exception: MessageId: {0}  Error: {1} Method Duration ms:{2}", messageId, errorMessage, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return resultObject;
            }
        }

    }
}