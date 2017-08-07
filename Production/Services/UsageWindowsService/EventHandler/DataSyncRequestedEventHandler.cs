using Common.Logging;
using LibertyPower.Business.MarketManagement.AccountInfoConsolidation;
using UsageEventAggregator;
using UsageEventAggregator.Events.AccountPropertyHistory;


namespace UsageWindowsService.EventHandler
{
    public class DataSyncRequestedEventHandler : IHandleEvents<DataSyncRequested>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public void Handle(DataSyncRequested e)
        {

            Log.Info(string.Format("Data sync requested for account:{0}, Utility:{1}", e.AccountNumber, e.UtilityCode));

            if (e.Source == "Scraper")
                _SynchronizeFromScrapers(e.AccountNumber, e.UtilityCode);
            else
                _Synchronize(e.AccountNumber, e.UtilityCode, e.Zone, e.Profile, e.ServiceClass, e.BillingCycle, e.Icap,
                             e.Tcap);
        }

        /// <summary>
        /// Synchronize the Account information passed with the account information in the database
        /// </summary>
        /// <param name="accountNumber">account number we wish to update</param>
        /// <param name="utilityCode">the utility code the account belongs to</param>
        /// <param name="zone">the new value of the zone to update</param>
        /// <param name="profile">the new value of profile to update</param>
        /// <param name="serviceClass">the new value of service class to update</param>
        /// <param name="billingCycle">the new value of billing cycle to update</param>
        /// <param name="icap">the new value if icap to update</param>
        /// <param name="tcap">the new value of tcap to update</param>
        /// <returns></returns>
        private string _Synchronize(string accountNumber, string utilityCode, string zone, string profile, string serviceClass,
                                  string billingCycle, string icap, string tcap)
        {
            var ai = new AccountInfo(accountNumber, utilityCode, AccountDataSource.ESource.Edi);
            ai.Synchronize(zone, profile, serviceClass, billingCycle, icap, tcap);
            return ai.Message;
        }

        /// <summary>
        /// Synchronise the Account with the Account information in the database. The account information will be coming from the corresponding scraper
        /// </summary>
        /// <param name="accountNumber">Account number we wish to update</param>
        /// <param name="utilityCode">the utility code the account belongs to .The utilitycode will dictate which scraper to get the information from</param>
        /// <returns></returns>
        private string _SynchronizeFromScrapers(string accountNumber, string utilityCode)
        {
            var ai = new AccountInfo(accountNumber, utilityCode);
            ai.Synchronize();
            return ai.Message;
        }
    }
}