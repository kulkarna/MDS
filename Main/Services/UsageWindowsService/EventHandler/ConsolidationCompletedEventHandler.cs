using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.Consolidation;
using UsageEventAggregator.Events.DataProcessed;

namespace UsageWindowsService.EventHandler
{
    public class ConsolidationCompletedEventHandler : IHandleEvents<UsageConsolidationCompleted>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public void Handle(UsageConsolidationCompleted e)
        {
            Log.Debug(string.Format("Consolidation complete. Account {0} Utility {1}", e.AccountNumber, e.UtilityCode));

            Aggregator.Publish(new DataProcessedHuComplete
            {
                AccountNumber = e.AccountNumber,
                UtilityCode = e.UtilityCode,
                Source = e.Source,
                TransactionId = e.TransactionId
            });
        }
    }
}