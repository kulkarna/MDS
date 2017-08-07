namespace UsageEventAggregator.Events.AccountPropertyHistory
{
    public class AccountPropertyHistoryProcessRequested
    {
        public string AccountNumber { get; set; }
        public string UtilityCode { get; set; }
        public long TransactionId { get; set; }
        public string EdiLogId { get; set; }
        public string Source { get; set; } 
    }
}