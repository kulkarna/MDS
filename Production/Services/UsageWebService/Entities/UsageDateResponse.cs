using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UsageWebService.Entities
{
    public class UsageDateResponse
    {
        public string MessageId { get; set; }
        public string Code { get; set; }
        public bool IsSuccess { get; set; }
        public string Message { get; set; }
        public DateTime UsageDate { get; set; }

        public override string ToString()
        {
            return string.Format("UsageDateResponse[MessageId:{0};Code:{1};IsSuccess:{2};Message:{3};AnnualUsage:{4}]",
                MessageId ?? "NULL", Code ?? "NULL", IsSuccess, Message ?? "NULL", UsageDate.ToString());
        }
    }
}