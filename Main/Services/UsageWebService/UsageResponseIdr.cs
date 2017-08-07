using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace UsageWebService
{
    [DataContract]
    public class UsageResponseIdr
    {
        public UsageResponseIdr()
        {
            lstUsageResponseIdrItem = new List<UsageResponseIdrItem>();
        }
        [DataMember]
        public List<UsageResponseIdrItem> lstUsageResponseIdrItem { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }
        [DataMember]
        public string MessageId { get; set; }
    }
    [DataContract]
    public class UsageResponseIdrItem
    {
        //public UsageResponseIdrItem(string accountNumber, int utilityId, DateTime usageDate, string usage, string meterNumber)
        //{
        //    AccountNumber = accountNumber;
        //    UtilityId = utilityId;
        //    UsageDate = usageDate;
        //    Usage = usage;
        //   - MeterNumber = meterNumber;
        //}
        public UsageResponseIdrItem(string accountNumber, int utilityId, DateTime usageDate, string usage, string meterNumber, string errorCode)
        {
            AccountNumber = accountNumber;
            UtilityId = utilityId;
            UsageDate = usageDate;
            Usage = usage;
            MeterNumber = meterNumber;
            ErrorCode = errorCode;
        }
        public UsageResponseIdrItem() { }
        [DataMember]
        string AccountNumber { get; set; }
        [DataMember]
        int UtilityId { get; set; }
        [DataMember]
        DateTime UsageDate { get; set; }
        [DataMember]
        string Usage { get; set; }
        [DataMember]
        string ErrorCode { get; set; }
        [DataMember]
        string MeterNumber { get; set; }

    }

    [DataContract]
    public class UsageResponseNonIdr
    {
        public UsageResponseNonIdr()
        {
            lstUsageResponseNonIdrItem = new List<UsageResponseNonIdrItem>();
        }
        [DataMember]
        public List<UsageResponseNonIdrItem> lstUsageResponseNonIdrItem { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }
        [DataMember]
        public string MessageId { get; set; }
    }
    [DataContract]
    public class UsageResponseNonIdrItem
    {

        public UsageResponseNonIdrItem(string accountNumber, int? utilityId, DateTime? fromDate, DateTime? toDate, double? totalKwh, int? daysUsed, string errorCode, string meterNumber)
        {
            AccountNumber = accountNumber;
            UtilityId = utilityId;
            FromDate = fromDate;
            ToDate = toDate;
            MeterNumber = meterNumber;
            FromDate = fromDate;
            ToDate = toDate;
            TotalKwh = totalKwh;
            DaysUsed = daysUsed;
            ErrorCode = errorCode;
        }
        public UsageResponseNonIdrItem() { }
        [DataMember]
        string AccountNumber { get; set; }
        [DataMember]
        int? UtilityId { get; set; }
        [DataMember]
        DateTime? FromDate { get; set; }
        [DataMember]
        DateTime? ToDate { get; set; }
        [DataMember]
        double? TotalKwh { get; set; }
        [DataMember]
        int? DaysUsed { get; set; }
        [DataMember]
        string ErrorCode { get; set; }
        [DataMember]
        string MeterNumber { get; set; }

    }
}
