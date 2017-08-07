using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using Common.Logging;
using NLog.Config;
using UsageEventAggregator.Helpers;
using UsageWebService.Entities;
using UsageWebService.Helpers;
using UsageWebService.Validation;

namespace UsageWebService
{
    [ServiceBehavior(InstanceContextMode = InstanceContextMode.Single)]
    [ValidateDataAnnotationsBehavior]
    [GlobalExceptionHandlerBehaviour(typeof(GlobalExceptionHandler))]
    public class Usage : IUsage
    {
        private static ILog Log;

        public Usage()
        {
            Locator.Current.RegisterDIContainer(Assembly.GetExecutingAssembly());
            ConfigurationItemFactory.Default.Targets.RegisterDefinition("UsageEvents", typeof(Helpers.NlogUsageEventsTarget));

            Log = LogManager.GetCurrentClassLogger();
            Log.Info("Usage Web Service Started");

        }

        public DateTime GetUsageDate(UsageDateRequest usageDateRequest)
        {
            return usageDateRequest.Execute();
        }

        /// <summary>
        /// PBi-87361-Add new method GetIdrUsageDate
        /// </summary>
        /// <param name="usageDateRequest"></param>
        /// <returns></returns>
        public UsageDateResponse GetIdrUsageDate(IdrUsageDateRequest idrUsageDateRequest)
        {
            UsageDateResponse resultObject = new UsageDateResponse();
            DateTime beginTime = DateTime.Now;
            try
            {
                resultObject = idrUsageDateRequest.Execute();
                return resultObject;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                LogManager.GetCurrentClassLogger().Debug(string.Format("Usage date requested Exception: {0} account: {1} Error: {2} Method Duration ms:{3}", idrUsageDateRequest.UtilityCode, idrUsageDateRequest.AccountNumber, errorMessage, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                resultObject.MessageId = idrUsageDateRequest.MessageId;
                resultObject.Code = "9999";
                resultObject.IsSuccess = false;
                resultObject.Message = "System Error Occured";
                resultObject.UsageDate = DateTime.MinValue;
                return resultObject;
            }
        }

        public UsageDateResponse GetUsageDateV1(UsageDateRequestV1 usageDateRequestV1)
        {
            UsageDateResponse resultObject = new UsageDateResponse();
            DateTime beginTime = DateTime.Now;
            try
            {
                resultObject = usageDateRequestV1.Execute();
                return resultObject;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                LogManager.GetCurrentClassLogger().Debug(string.Format("Usage date requested Exception: {0} account: {1} Error: {2} Method Duration ms:{3}", usageDateRequestV1.UtilityCode, usageDateRequestV1.AccountNumber, errorMessage, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                resultObject.MessageId = usageDateRequestV1.MessageId;
                resultObject.Code = "9999";
                resultObject.IsSuccess = false;
                resultObject.Message = "System Error Occured";
                resultObject.UsageDate = DateTime.MinValue;
                return resultObject;
            }
        }
        public AnnualUsageBulkResponse GetAnnualUsageBulk(string messageId, UsageAccountRequestList usageList)
        {
            AnnualUsageBulkResponse resultObject = new AnnualUsageBulkResponse();
            AnnualUsageBulkRequest requestObject = new AnnualUsageBulkRequest();
            DateTime beginTime = DateTime.Now;
            try
            {
                resultObject = requestObject.Execute(messageId, usageList);
                return resultObject;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                LogManager.GetCurrentClassLogger().Debug(string.Format("AnnualUSageBulk requested Exception: MessagId: {0} Error: {1} Method Duration ms:{2}", messageId, errorMessage, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                resultObject.MessageId = messageId;
                resultObject.Code = "9999";
                resultObject.IsSuccess = false;
                resultObject.Message = "System Error Occured";
                resultObject.UsageAccountList = null;
                return resultObject;
            }
        }

        public string SubmitHistoricalUsageRequest(EdiUsageRequest ediUsageRequest)
        {
            return ediUsageRequest.Execute();
        }

        public string RunScraper(ScraperUsageRequest scraperUsageRequest)
        {
            return scraperUsageRequest.Execute();
        }


        public ScraperUsageResponse RunScraperWithInstantResponse(ScraperUsageRequest scraperUsageRequest)
        {
            ScraperUsageResponse resultObject = new ScraperUsageResponse();
            string messageId = string.Empty;
            try
            {
                resultObject = resultObject.IsScraperRequested(scraperUsageRequest);
                return resultObject;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                LogManager.GetCurrentClassLogger().Debug(string.Format("RunScraper  Exception: MessagId: {0} Error: {1} Method Duration ms:{2}", messageId, errorMessage, DateTime.Now.Millisecond.ToString()));
                resultObject.MessageId = "";
                resultObject.Code = "9999";
                resultObject.IsSuccess = false;
                resultObject.Message = "Scraper Service Call Failed With Message " + errorMessage;
                return resultObject;
            }
        }

        public ScraperCalculateUsageResponse RunScraperAndCalculateAnnualUsage(string utilityCode)
        {
            ScraperCalculateUsageResponse resultObject = new ScraperCalculateUsageResponse();
            string ErrorMsg = string.Empty;
            string processName = "ENROLLMENT";
            try
            {
                ErrorMsg = resultObject.DoProcess(utilityCode, processName);
                if (!string.IsNullOrEmpty(ErrorMsg))
                    throw new Exception(ErrorMsg);
                resultObject.Code = "999";
                resultObject.IsSuccess = true;
                resultObject.Message = ErrorMsg;

            }
            catch (Exception exc)
            {
                string errorMessage = string.Empty;
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                if (exception.ToUpper().Contains("INVALID UTILITY"))
                    errorMessage = exception;
                else
                    errorMessage = exception + innerException;
                LogManager.GetCurrentClassLogger().Debug(string.Format("RunScraperAndCalculateAnnualUsage  Exception: Error: {0} Method Duration ms:{1}", errorMessage, DateTime.Now.Millisecond.ToString()));
                resultObject.Code = "000";
                resultObject.IsSuccess = false;
                resultObject.Message = errorMessage;
            }
            return resultObject;
        }

        public int GetAnnualUsage(AnnualUsageRequest annualUsageRequest)
        {
            return annualUsageRequest.Execute();
        }

        public bool IsIdrEligible(IsIdrEligibleRequest isIdrEligibleRequest)
        {
            return isIdrEligibleRequest.Execute();
        }

        public bool IsServiceRunning()
        {
            return true;
        }

        public UsageResponseIdr GetUsageListIdr(string messageId, UsageRequestIdr usageRequestIdr)
        {
            if(string.IsNullOrEmpty(messageId))
            messageId = Guid.NewGuid().ToString();
            UsageResponseIdr response = usageRequestIdr.Execute(messageId);
            return response;
        }
        public UsageResponseNonIdr GetUsageListNonIdr( string messageId,UsageRequestNonIdr usageRequestNonIdr, int term)
        {
            if (string.IsNullOrEmpty(messageId)) 
           messageId = Guid.NewGuid().ToString();
           UsageResponseNonIdr response = usageRequestNonIdr.Execute(messageId,term);
            return response;
        }

        public string Version()
        {
            return Assembly.GetExecutingAssembly().GetName().Version.ToString();
        }


    }
}
