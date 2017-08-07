namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that the generic web account object has valid data..
	/// </summary>
	[Guid( "8444B4A8-D9A7-44fa-81D5-060AFAE54AE5" )]
	public class ConedAccountDataExistsRule : BusinessRule
	{
		private Coned account;

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Constructor that takes a Coned account list
		/// </summary>
		/// <param name="account">Coned account list</param>
		public ConedAccountDataExistsRule( Coned account )
			: base( "Account Data Exists Rule", BrokenRuleSeverity.Information )
		{
			this.account = account;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			string accountNumber = account.AccountNumber;

			DataExistsRule rule = new DataExistsRule( accountNumber, "Stratum Variable", account.StratumVariable );
			if( !rule.Validate() )
				AddException( rule.Exception );

            //rule = new DataExistsRule( accountNumber, "ICAP", Convert.ToInt32( account.Icap ) );
            //if( !rule.ValidateNumber() )
            //    AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "Zone", account.ZoneCode );
			if( !rule.Validate() )
				AddException( rule.Exception );

            //rule = new DataExistsRule( accountNumber, "Bill Group", account.BillGroup );
            //if( !rule.ValidateNumber() )
            //    AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "Rate Class", account.RateClass );
			if( !rule.Validate() )
				AddException( rule.Exception );

			ConedUsageListDataExistsRule usageRule = new ConedUsageListDataExistsRule( accountNumber, account.WebUsageList );
			if( !usageRule.Validate() )
				AddException( usageRule.Exception );

			account.AccountDataExistsRule = this;

			return this.Exception == null;
		}

		// ------------------------------------------------------------------------------------
		private void AddException( BrokenRuleException exception )
		{
			if( this.Exception == null )
				this.SetException( "Missing account data." );

			exception.Severity = BrokenRuleSeverity.Warning;
			this.DefaultSeverity = BrokenRuleSeverity.Error;

			this.AddDependentException( exception );
		}

	}
}
