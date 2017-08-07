using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.AccountPropertyHistory;
using UsageEventAggregator.Events.Consolidation;

namespace UsageWindowsService.EventHandler
{
    public class AccountPropertyHistoryProcessCompletedEventHandler : IHandleEvents<AccountPropertyHistoryProcessCompleted>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public void Handle(AccountPropertyHistoryProcessCompleted e)
        {
        
            Log.Info(string.Format("APH insert completed for account:{0}, Utility:{1}", e.AccountNumber, e.UtilityCode));

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