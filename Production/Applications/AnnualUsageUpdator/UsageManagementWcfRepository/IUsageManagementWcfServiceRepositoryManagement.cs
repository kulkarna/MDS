using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsageWebService.Entities;
using LibertyPower.MarketDataServices.AccountWcfServiceData;

namespace UsageManagementWcfServiceRepository
{
    /// <summary>
    /// Interface IUsageManagementWcfServiceRepositoryManagement
    /// </summary>
    public interface IUsageManagementWcfServiceRepositoryManagement
    {
        /// <summary>
        /// Gets the usage data.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="utilityIdInt">The utility identifier int.</param>
        /// <param name="serviceAccount">The service account.</param>
        /// <returns>System.Int32.</returns>
        AnnualUsageBulkResponse GetAnnualUsageBulk(string messageId, AccountServiceResponse accountListInput);
    }
}
