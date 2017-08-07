using System;

namespace UsageEventAggregator.Events.Log
{
    public class UsageLogEvent
    {
        public string Level { get; set; }
        public DateTime TimeStamp { get; set; }
        public string Logger { get; set; }
        public string Message { get; set; }
    }
}