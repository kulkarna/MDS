

namespace LibertyPower.MarketDataServices.AnnualUsageUpdator
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    public class Account
    {
        public Account() { }

        public Account(int accountId,string accountNumber,int utilityId, int annualUsage) 
		{
            AccountId = accountId;
            AccountNumber = accountNumber;
            UtilityId = utilityId;
            AnnualUsage = annualUsage;
			
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

        public int AnnualUsage
		{
			get;
			set;
		}
       
    }
}
