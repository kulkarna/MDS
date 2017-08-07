using System;
using System.Data;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	[Serializable]
	[Guid( "7792076E-0D94-473f-B5C1-0519B8D57422" )]
	public class AccountNumberRule : BusinessRule
	{
		private string accountNumber;
		string prefix;
		int exactLength;

		public AccountNumberRule( string accountNumber, string prefix, int exactLength )
			: base( "UtilityAccountNumberRule", BrokenRuleSeverity.Error )
		{
			this.accountNumber = accountNumber;
			this.prefix = prefix;
			this.exactLength = exactLength;
		}

		public override bool Validate()
		{

			// validate that an account number was specified
			if( accountNumber == null || accountNumber.Length == 0 )
			{
				this.SetException( "Account number not provided" );
				return false;
			}

			//run prefix and exact length rules
			StringPrefixRule prefixRule = new StringPrefixRule( prefix, accountNumber );
			ExactStringLengthRule exactLengthRule = new ExactStringLengthRule( exactLength, accountNumber, BrokenRuleSeverity.Error );

			if( !prefixRule.Validate() | !exactLengthRule.Validate() )
			{
				this.SetException( "Invalid account number" );

				if( prefixRule.Exception != null)
					this.AddDependentException( prefixRule.Exception );

				if( exactLengthRule.Exception != null )
					this.AddDependentException( exactLengthRule.Exception );
			}

			return this.Exception == null;
		}

	}
}