

namespace UsageWebService.Entities
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    public class UsageAccountResponse
    {
        public UsageAccountResponse() { }

        public UsageAccountResponse(int accountId, string accountNumber, int utilityId, int annualUsage) 
		{
            AccountId = accountId;
            AccountNumber = accountNumber;
            UtilityId = utilityId;
            Usage = annualUsage;
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

        public int Usage
		{
			get;
			set;
		}
       
    }
}
