namespace UsageEventAggregator.Events.Edi
{
    public class EdiFileParsed : IEventMessage
    {
        public string AccountNumber { get; set; }
        public string UtilityCode { get; set; }
        public long TransactionId { get; set; }

        public string Message { get; set; }
        
        public bool Is867IntervalData { get; set; }
        public bool Is867SummaryData { get; set; }
        
        public bool Is814SummaryData { get; set; }
        public bool Is814IntervalData { get; set; }
        
        public string ParserLogId { get; set; }
        public bool IsError { get; set; }
        

    }
}