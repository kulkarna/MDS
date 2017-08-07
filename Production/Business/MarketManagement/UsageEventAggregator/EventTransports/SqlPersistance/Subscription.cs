using System;

namespace UsageEventAggregator.EventTransports.SqlPersistance
{
    public class Subscription<T>
    {
        public int Id { get; set; }
        public string MessageType { get; private set; }
        public IHandleEvents<T> Subscriber { get; set; }
        public DateTime DateTimeToStartFrom { get; set; }

        public Subscription()
        {
            MessageType = typeof (T).Name;
        }
    }
}