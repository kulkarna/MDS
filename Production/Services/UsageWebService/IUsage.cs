using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using UsageWebService.Entities;

namespace UsageWebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IUsage
    {

        [OperationContract]
        DateTime GetUsageDate(UsageDateRequest usageDateRequest);

        [OperationContract]
        UsageDateResponse GetIdrUsageDate(IdrUsageDateRequest idrUsageDateRequest);

        [OperationContract]
        UsageDateResponse GetUsageDateV1(UsageDateRequestV1 usageDateRequestV1);

        [OperationContract]
        string SubmitHistoricalUsageRequest(EdiUsageRequest ediUsageRequest);

        [OperationContract]
        string RunScraper(ScraperUsageRequest scraperUsageRequest);

        [OperationContract]
        ScraperCalculateUsageResponse RunScraperAndCalculateAnnualUsage(string utilityCode);

        [OperationContract]
        ScraperUsageResponse RunScraperWithInstantResponse(ScraperUsageRequest scraperUsageRequest);

        [OperationContract]
        int GetAnnualUsage(AnnualUsageRequest annualUsageRequest);
     
        [OperationContract]
        AnnualUsageBulkResponse GetAnnualUsageBulk(string messageId, UsageAccountRequestList usageAccountList);

        [OperationContract]
        bool IsIdrEligible(IsIdrEligibleRequest isIdrEligibleRequest);

        [OperationContract]
        bool IsServiceRunning();

        [OperationContract]
         UsageResponseIdr GetUsageListIdr( string messageId,UsageRequestIdr usageRequestIdr);

        [OperationContract]
        UsageResponseNonIdr GetUsageListNonIdr( string messageId,UsageRequestNonIdr usageRequestNonIdr, int term);
               
        [OperationContract]
        string Version();

    }

}
