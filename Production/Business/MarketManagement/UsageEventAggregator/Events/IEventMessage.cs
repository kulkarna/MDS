namespace UsageEventAggregator.Events
{
    public interface IEventMessage
    {
        string AccountNumber { get; set; }
        string UtilityCode { get; set; }
        long TransactionId { get; set; }
    }
}