namespace UsageEventAggregator.Events.Collector
{
    public class ScraperRequested : IEventMessage
    {
        public string AccountNumber { get; set; }
        public string UtilityCode { get; set; }
        public long TransactionId { get; set; }
    }
}