using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.AccountPropertyHistory;
using UsageEventAggregator.Events.Consolidation;

namespace UsageWindowsService.EventHandler
{
    public class AccountPropertyHistoryProcessFailedEventHandler : IHandleEvents<AccountPropertyHistoryProcessFailed>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public void Handle(AccountPropertyHistoryProcessFailed e)
        {
            Log.Warn(string.Format("Account Property History failed with account:{0} Utility: {1}. Error was {2}", e.AccountNumber, e.UtilityCode, e.Message));

            Aggregator.Publish(new UsageConsolidationRequested
            {
                AccountNumber = e.AccountNumber,
                UtilityCode = e.UtilityCode,
                TransactionId = e.TransactionId,
                Source = e.Source
            });
        }
    }
}