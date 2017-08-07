using System.Linq;
using UsageEventAggregator;
using UsageEventAggregator.Events.DataResponse;
using UsageEventAggregator.Helpers;

namespace UsageWindowsService.EventHandler
{
    public class DataResponseIdrAcceptanceEventHandler : IHandleEvents<DataResponseIdrAcceptance>
    {
        public void Handle(DataResponseIdrAcceptance e)
        {
            var subscriptions = Locator.Current.GetInstances<ISubscriber<DataResponseIdrAcceptance>>();
            if (!subscriptions.Any())
                return;

            foreach (var subscription in subscriptions)
                subscription.Send(e);
        }
    }
}