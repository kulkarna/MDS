namespace UsageEventAggregator.Events.Collector
{
    public class CollectUsageFailed : IEventMessage
    {
        public string AccountNumber { get; set; }
        public string UtilityCode { get; set; }
        public long TransactionId { get; set; }
        public string Error { get; set; }
        public string Source { get; set; }
        public bool IsIdr { get; set; }

    }
}