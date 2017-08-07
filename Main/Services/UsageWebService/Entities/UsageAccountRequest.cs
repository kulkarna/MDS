

namespace UsageWebService.Entities
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    public class UsageAccountRequest
    {
        public UsageAccountRequest() { }

        public UsageAccountRequest(int accountId, string accountNumber, int utilityId) 
		{
            AccountId = accountId;
            AccountNumber = accountNumber;
            UtilityId = utilityId;
           
		}
        public int AccountId
        {
            get;
            set;
        }
        public string AccountNumber
		{
			get;
			set;
		}
        public int UtilityId
        {
            get;
            set;
        }
       
    }
}
