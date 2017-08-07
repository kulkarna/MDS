using System;

namespace UsageWebService.Entities
{
    public class UsageTransaction
    {
        public long Id { get; set; }
        public DateTime TimeStamp { get; set; }
        public string AccountNumber { get; set; }
        public string UtilityCode { get; set; }
        public bool IsComplete { get; set; }
        public string Error { get; set; }
    }
}