namespace UsageEventAggregator.Events.Edi
{
    public class Edi814Acceptance : IEventMessage
    {
        public string AccountNumber { get; set; }
        public string UtilityCode { get; set; }
        public long TransactionId { get; set; }

        public string Message { get; set; }
        public bool IdrDataAvailable { get; set; }
    }
}