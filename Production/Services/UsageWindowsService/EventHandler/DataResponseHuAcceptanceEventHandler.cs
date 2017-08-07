using System.Linq;
using UsageEventAggregator;
using UsageEventAggregator.Events.DataResponse;
using UsageEventAggregator.Helpers;

namespace UsageWindowsService.EventHandler
{
    public class DataResponseHuAcceptanceEventHandler : IHandleEvents<DataResponseHuAcceptance>
    {
        public void Handle(DataResponseHuAcceptance e)
        {
            var subscriptions = Locator.Current.GetInstances<ISubscriber<DataResponseHuAcceptance>>();
            if (!subscriptions.Any())
                return;

            foreach (var subscription in subscriptions)
                subscription.Send(e);
        }
    }
}