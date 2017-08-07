using System;

namespace LibertyPower.RepositoryManagement.Core.AccountValidation
{
    public class AccountValidationResponse
    {
        public string AccountNumber { get; set; }
        public int UtilityId { get; set; }
        public string Source { get; set; }
        public bool IsUsageResponseAccepted { get; set; }
        public bool IsDataProcessCompleted { get; set; }
        public string Message { get; set; }
        public DateTime Timestamp { get; set; }

        public override string ToString()
        {
            return string.Format("AccountValidationResponse[AccountNumber:{0};UtilityId:{1};Source:{2};IsUsageResponseAccepted:{3};IsDataProcessCompleted:{4};Message:{5};Timestamp:{6}",
                AccountNumber, UtilityId, Source, IsUsageResponseAccepted, IsDataProcessCompleted, Message, Timestamp.ToLongDateString() + ":" + Timestamp.ToLongTimeString());
        }
    }
}