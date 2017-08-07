using System;

namespace UsageEventAggregator.Events.Consolidation
{
    public class UsageConsolidationRequested : IEventMessage
    {
        public string AccountNumber { get; set; }
        public string UtilityCode { get; set; }
        public long TransactionId { get; set; }

        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Source { get; set; }
    }
}