namespace UsageEventAggregator.Events.AccountPropertyHistory
{
    public class DataSyncRequested
    {
        public string AccountNumber { get; set; }
        public string UtilityCode { get; set; }
        public long TransactionId { get; set; }
        public string Source { get; set; } 
        public string Profile { get; set; }
        public string Zone { get; set; }
        public string ServiceClass { get; set; }
        public string BillingCycle { get; set; }
        public string Icap { get; set; }
        public string Tcap { get; set; }
    }
}