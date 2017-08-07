using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibertyPower.MarketDataServices.AccountWcfServiceData;
using LibertyPower.MarketDataServices.AccountRepository;

namespace LibertyPower.MarketDataServices.AccountBusinessLayer
{
    /// <summary>
    /// Interface IBusinessLayer
    /// </summary>
    public interface IBusinessLayer
    {
        //AccountServiceResponse GetEnrolledAccounts(string messageId);
        //AccountServiceResponse GetEnrolledAccountsForUtility(string messageId, int utilityId);
        AccountServiceResponse PopulateEnrolledAccounts(string messageId);
        AccountServiceResponse GetEnrolledAccountsToProcess(string messageId, int numberOfAccounts);
        AccountServiceResponse UpdateAnnualUsageBulk(string messageId, AnnualUsageTranRecordList anuualUsageList);
    }
}