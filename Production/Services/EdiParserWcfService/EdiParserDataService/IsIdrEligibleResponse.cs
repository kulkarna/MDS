using System;
using System.Linq;
using System.Runtime.Serialization;



namespace LibertyPower.MarketDataServices.EdiParserWcfServiceData
{
    public class GetBillGroupMostRecentResponse
    {

        #region public constructors
        public GetBillGroupMostRecentResponse() { }

        public GetBillGroupMostRecentResponse(string messageId, string message, bool isSuccess, string code, string billGroup)
        {
            MessageId = messageId;
            BillGroup = billGroup;
            Message = message;
        }
        #endregion

        #region public properties
        public string Code { get; set; }
        public bool IsSuccess { get; set; }
        public string Message { get; set; }
        public string MessageId { get; set; }
        public string BillGroup { get; set; }
        #endregion



        #region public methods
        public override string ToString()
        {
            string toString = string.Format("GetBillGroupMostRecentResponse:[MessageId:{0};IsSuccess{1};Code:{2};Message:{3};BillGroup:{4}]", Utilities.Common.NullSafeString(MessageId), Utilities.Common.NullSafeString(IsSuccess), Utilities.Common.NullSafeString(Code), Utilities.Common.NullSafeString(Message), BillGroup);
            return toString;
        }
        #endregion


    }
}