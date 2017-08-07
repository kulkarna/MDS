using System.Linq;
using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.Consolidation;
using UsageEventAggregator.Events.DataProcessed;
using UsageEventAggregator.Helpers;
using UsageWindowsService.Repository;

namespace UsageWindowsService.EventHandler
{
    public class ConsolidationFailedEventHandler : IHandleEvents<UsageConsolidationFailed>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public void Handle(UsageConsolidationFailed e)
        {
            Log.Info(string.Format("Consolidation failed with transaction id {0} and error was {1}", e.TransactionId, e.Message));

            var repository = Locator.Current.GetInstance<IRepository>();
            repository.SetTransactionAsComplete(e.TransactionId, e.Message);

            var subscriptions = Locator.Current.GetInstances<ISubscriber<DataProcessedHuFailed>>();
            if (!subscriptions.Any())
                return;

            foreach (var subscription in subscriptions)
                subscription.Send(new DataProcessedHuFailed
                    {
                        AccountNumber = e.AccountNumber,
                        UtilityCode = e.UtilityCode,
                        TransactionId = e.TransactionId,
                        Message = "Consolidation failed. " + e.Message,
                        Source = e.Source
                    });
        }
    }
}