using System.Linq;
using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.DataProcessed;
using UsageEventAggregator.Helpers;
using UsageWindowsService.Repository;

namespace UsageWindowsService.EventHandler
{
    public class DataProcessedHuCompleteEventHandler : IHandleEvents<DataProcessedHuComplete>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public void Handle(DataProcessedHuComplete e)
        {

            Log.Debug(string.Format("Usage collection completed for account {0}, utility {1} and transaction id {2}", e.AccountNumber, e.UtilityCode, e.TransactionId));

            var repository = Locator.Current.GetInstance<IRepository>();
            repository.SetTransactionAsComplete(e.TransactionId);

            var subscriptions = Locator.Current.GetInstances<ISubscriber<DataProcessedHuComplete>>();
            if (!subscriptions.Any())
                return;

            foreach (var subscription in subscriptions)
                subscription.Send(e);
        }
    }
}