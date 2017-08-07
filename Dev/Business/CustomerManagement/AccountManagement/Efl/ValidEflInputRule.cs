using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	[Guid( "A124C980-32A0-4d46-BD0A-9EAA4C50CBB3" )]
	public class ValidEflInputRule : BusinessRule
	{
		private int term;
		private decimal rate;
		private decimal lpFixed;
		private string accountType;
		private string productId;
		private string process = "";

		public ValidEflInputRule( EflRequest eflRequest )
			: base( "Valid EFL Input Rule", BrokenRuleSeverity.Error )
		{
			this.term = eflRequest.Term;
			this.rate = eflRequest.Rate;
			this.lpFixed = eflRequest.LpFixed;
			this.accountType = eflRequest.AccountType;
			this.productId = eflRequest.ProductId;
			if( eflRequest.Process != null && eflRequest.Process.Length > 0 )
				process = eflRequest.Process;
		}

		public override bool Validate()
		{
			bool validLpFixedRule = true;
			bool validRateRule = true;
			bool validTermRule = true;
			bool validAccountTypeRule = true;

			// validate lpFixed
			ValidEflLpFixedRule lpFixedRule = new ValidEflLpFixedRule( lpFixed );
			if( !lpFixedRule.Validate() )
				validLpFixedRule = false;

			// validate rate
			ValidEflRateRule rateRule = new ValidEflRateRule( rate );
			if( !rateRule.Validate() )
				validRateRule = false;

			// validate term
			ValidEflTermRule termRule = new ValidEflTermRule( term, accountType, productId, process );
			if( !termRule.Validate() )
				validTermRule = false;

			// validate account type
			ValidAccountTypeRule acctTypeRule = new ValidAccountTypeRule( accountType );
			if( !acctTypeRule.Validate() )
				validAccountTypeRule = false;

			// parent exception
			if( !validLpFixedRule || !validRateRule || !validTermRule )
				this.SetException( "Invalid input data." );

			// dependent exceptions
			if( !validLpFixedRule )
				this.AddDependentException( lpFixedRule.Exception );
			if( !validRateRule )
				this.AddDependentException( rateRule.Exception );
			if( !validTermRule )
				this.AddDependentException( termRule.Exception );
			if( !validAccountTypeRule )
				this.AddDependentException( acctTypeRule.Exception );


			return this.Exception == null;
		}
	}
}
