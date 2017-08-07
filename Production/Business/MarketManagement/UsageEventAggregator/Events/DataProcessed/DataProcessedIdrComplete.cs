namespace UsageEventAggregator.Events.DataProcessed
{
    public class DataProcessedIdrComplete : IEventMessage
    {
        public string AccountNumber { get; set; }
        public string UtilityCode { get; set; }
        public long TransactionId { get; set; }

        public string Source { get; set; }
    }
}