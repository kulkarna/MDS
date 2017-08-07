using System;
using System.Linq;
using System.Runtime.Serialization;



namespace LibertyPower.MarketDataServices.UsageEclWcfServiceData
{
    public class IsIdrEligibleResponse
    {

        #region public constructors
        public IsIdrEligibleResponse() { }

        public IsIdrEligibleResponse(string messageId, string message, bool isSuccess, string code, bool isIdrEligibleFlag)
        {
            MessageId = messageId;
            IsIdrEligibleFlag = isIdrEligibleFlag;
            Message = message;
        }
        #endregion

        #region public properties
        public string Code { get; set; }
        public bool IsSuccess { get; set; }
        public string Message { get; set; }
        public string MessageId { get; set; }
        public bool IsIdrEligibleFlag { get; set; }
        #endregion



        #region public methods
        public override string ToString()
        {
            string toString = string.Format("IsIdrEligibleResponse:[MessageId:{0};IsSuccess{1};Code:{2};Message:{3};IsIdrEligibleFlag:{4}]",Utilities.Common.NullSafeString(MessageId),Utilities.Common.NullSafeString(IsSuccess),Utilities.Common.NullSafeString(Code),Utilities.Common.NullSafeString(Message),IsIdrEligibleFlag);
            return toString;
        }
        #endregion


    }
}