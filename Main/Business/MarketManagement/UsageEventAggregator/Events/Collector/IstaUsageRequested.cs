namespace UsageEventAggregator.Events.Collector
{
    public class IstaUsageRequested : IEventMessage
    {
        public string AccountNumber { get; set; }
        public string UtilityCode { get; set; }
        public string DUNS { get; set; }
        public string BillingAccountNumber { get; set; }
        public string NameKey { get; set; }
        public string MeterNumber { get; set; }
        public string Zip { get; set; }
        public string Strata { get; set; }
        public long TransactionId { get; set; }
        public string UsageType { get; set; }
        public bool IsIdrRequest { get; set; }
    }
}