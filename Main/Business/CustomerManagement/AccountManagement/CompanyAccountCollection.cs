using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class CompanyAccountCollection : List<CompanyAccount>
	{
		public CompanyAccountCollection()
		{
		}

		public CompanyAccountCollection( List<CompanyAccount> accountList )
		{
			this.AddRange( accountList );
		}

		public CompanyAccount GetCompanyAccount( string accountNumber, string utilityCode )
		{
			return this.FirstOrDefault( a => a.AccountNumber.Equals( accountNumber.Trim() ) && a.UtilityCode.Trim().Equals( utilityCode.Trim() ) );
		}
	}
}
