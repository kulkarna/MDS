using NLog.Targets;
using UsageEventAggregator.Events.Log;

namespace UsageWebService.Helpers
{
    [Target("UsageEvents")]
    public class NlogUsageEventsTarget : TargetWithLayout
    {

        protected override void Write(NLog.LogEventInfo logEvent)
        {
            if (logEvent.LoggerName.Contains("UsageEventAggregator"))
                return;

            UsageEventAggregator.Aggregator.Publish(new UsageLogEvent
                {
                    Level = logEvent.Level.Name,
                    Logger = logEvent.LoggerName,
                    TimeStamp = logEvent.TimeStamp,
                    Message = logEvent.FormattedMessage
                });

        }

    }

}