using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibertyPower.MarketDataServices.AccountWcfServiceData;
using UsageWebService.Entities;

namespace AccountWcfServiceRepository
{
    /// <summary>
    /// Interface IAccountWcfServiceRepositoryManagement
    /// </summary>
    public interface IAccountWcfServiceRepositoryManagement
    {
        AccountServiceResponse PopulateEnrolledAccounts(string messageId);
        AccountServiceResponse GetNextSetEnrolledAccounts(string messageId, int numberOfAccounts);
        AccountServiceResponse UpdateAnnualUsageBulk(string messageId, AnnualUsageBulkResponse usageResponse);
    }
}
