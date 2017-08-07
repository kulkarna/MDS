using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class AccountInfo
	{
		public AccountInfo( string account_id, string utility_id, string name_key,
								 string billingAccount, string createdBy )
		{
			this.Account_id = account_id;
			this.Utility_ID = utility_id;
			this.Name_Key = name_key;
			this.BillingAccount = billingAccount;
			this.CreatedBy = createdBy;

		}
 
		public string Account_id { get; set; }
		public string Utility_ID { get; set; }
		public string Name_Key { get; set; }
		public string BillingAccount { get; set; }
		public string CreatedBy { get; set; }

	}

}
