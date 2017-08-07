using System;
using System.Linq;
using System.Runtime.Serialization;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;



namespace LibertyPower.MarketDataServices.AccountWcfServiceData
{
    public class AccountServiceResponse
    {

        #region public constructors
        
     public AccountServiceResponse() { }

     public AccountServiceResponse(string messageId, string code, bool isSuccess, string message, int accountId, string accountNumber, int utilityId, int annualUsage)
		{
			MessageId = messageId;
            Code = code;
            IsSuccess = isSuccess;
            Message = message;
            AccountResultList.Add(new AnnualUsageTranRecord(accountId, accountNumber, utilityId, annualUsage));
		}

     public string MessageId
		{
			get;
			set;
		}

     public AnnualUsageTranRecordList AccountResultList
		{
			get;
			set;
		
		}
        
        
     public bool IsSuccess
		{
			get;
			set;
		}
     public string Message
		{
			get;
			set;
		}
    public string Code
		{
			get;
			set;
		}

        #endregion



        #region public methods
        public override string ToString()
        {
            string toString = string.Format("AccountServiceResponse:[MessageId:{0};IsSuccess{1};Code:{2};Message:{3};AcountList:{4}]", Utilities.Common.NullSafeString(MessageId), Utilities.Common.NullSafeString(IsSuccess), Utilities.Common.NullSafeString(Code), Utilities.Common.NullSafeString(Message), Utilities.Common.NullSafeString(AccountResultList.ToString()));
            return toString;
        }
        #endregion


    }
}