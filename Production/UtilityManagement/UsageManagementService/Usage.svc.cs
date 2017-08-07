using System;
using System.ServiceModel;
using UsageWebService.Entities;
using UsageWebService.Validation;

namespace UsageWebService
{
    [ServiceBehavior(InstanceContextMode = InstanceContextMode.Single)]
    [ValidateDataAnnotationsBehavior]
    public class Usage : IUsage
    {

        public Usage()
        {


        }

        public DateTime GetUsageDate(UsageDateRequest usageDateRequest)
        {
            return usageDateRequest.Execute();
        }

        public string SubmitHistoricalUsageRequest(EdiUsageRequest ediUsageRequest)
        {
            return ediUsageRequest.SubmitReturningTransactionId();
        }

        public string RunScraper(ScraperUsageRequest scraperUsageRequest)
        {
            return scraperUsageRequest.RunScraperReturningTransactionId();
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
    }
}
