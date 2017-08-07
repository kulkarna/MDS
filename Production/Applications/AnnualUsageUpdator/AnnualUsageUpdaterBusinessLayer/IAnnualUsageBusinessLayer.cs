using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibertyPower.MarketDataServices.AnnualUsageBusinessLayer
{
    /// <summary>
    /// Interface IAccountWcfServiceRepositoryManagement
    /// </summary>
    public interface IBusinessLayer
    {
        /// <summary>
        /// Gets the usage data.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="utilityIdInt">The utility identifier int.</param>
        /// <param name="serviceAccount">The service account.</param>
        /// <returns>System.Int32.</returns>
        //int GetNextSetEnrolledAccounts(string messageId, int numberOfAccounts);
        int ProcessAccounts(string messageId, int numberOfAccounts);
        int CheckjobStatus(string messageid, int numberOfDays);
        int PopulateEnrolledAccounts(string messageId);
        string GenerateReport(string messageId);
        /// <summary>
        /// GetUsageDate
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="AccountNumber"></param>
        /// <param name="utilityId"></param>
        /// <returns></returns>
    }
}
