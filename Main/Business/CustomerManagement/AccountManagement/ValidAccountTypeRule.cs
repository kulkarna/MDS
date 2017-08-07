using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	[Guid( "6A29E8D8-563D-437f-B123-1F33AC9F296D" )]
	public class ValidAccountTypeRule : BusinessRule
	{
		private string accountType;

		public ValidAccountTypeRule( string accountType )
			: base( "Valid Account Type Rule", BrokenRuleSeverity.Error )
        {
			this.accountType = accountType;
        }

		public override bool Validate()
		{
			CompanyAccountType type = (CompanyAccountType) Enum.Parse( typeof( CompanyAccountType ), accountType, true );

			if( type.Equals( null ) )
				this.SetException("-  Invalid account type (" + accountType + ").");

			return this.Exception == null;
		}
	}
}
