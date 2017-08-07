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
        string SubmitHistoricalUsageRequest(EdiUsageRequest ediUsageRequest);

        [OperationContract]
        string RunScraper(ScraperUsageRequest scraperUsageRequest);

        [OperationContract]
        int GetAnnualUsage(AnnualUsageRequest annualUsageRequest);

        [OperationContract]
        bool IsIdrEligible(IsIdrEligibleRequest isIdrEligibleRequest);

        [OperationContract]
        bool IsServiceRunning();

    }

}
