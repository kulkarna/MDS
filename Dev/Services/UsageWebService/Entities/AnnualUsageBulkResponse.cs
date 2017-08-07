using System;
using System.Linq;
using System.Runtime.Serialization;


namespace UsageWebService.Entities
{
    public class AnnualUsageBulkResponse
    {

     #region public constructors
        
     public AnnualUsageBulkResponse() { }

     public AnnualUsageBulkResponse(string messageId, string code, bool isSuccess, string message, int accountId, string accountNumber, int utilityId, int usage)
		{
			MessageId = messageId;
            Code = code;
            IsSuccess = isSuccess;
            Message = message;
            UsageAccountList.Add(new UsageAccountResponse(accountId, accountNumber, utilityId, usage));
		}

     public string MessageId
		{
			get;
			set;
		}

     public UsageAccountResponseList UsageAccountList
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
            string toString = string.Format("AnnualUSageBulkResponse:[MessageId:{0};IsSuccess{1};Code:{2};Message:{3};AcountList:{4}]", MessageId, IsSuccess, Code, Message, UsageAccountList.ToString());
            return toString;
        }
        #endregion


    }
}