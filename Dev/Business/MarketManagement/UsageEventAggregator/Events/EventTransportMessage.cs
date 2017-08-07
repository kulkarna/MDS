using System;

namespace UsageEventAggregator.Events
{
    public class EventTransportMessage
    {
        public long Id { get; set; }

        public long CorrelationId { get; set; }

        public DateTime TimeSent { get; set; }

        public string MessageType { get; set; }

        public string Body { get; set; }

        
    }
}