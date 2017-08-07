namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	[Guid( "48EA27C8-C8A2-491b-880E-5D1C4C6B09A9" )]
	public class NimoUsageListDataExistsRule : BusinessRule
	{
		private string accountNumber;
		private WebUsageList usageList;

		/// <summary>
		/// Constructor that takes an account number and a usage list object
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="usageList">Edi usage list object</param>
		public NimoUsageListDataExistsRule( string accountNumber, WebUsageList usageList )
			: base( "Usage List Data Exists Rule", BrokenRuleSeverity.Information )
		{
			this.accountNumber = accountNumber;
			this.usageList = usageList;
		}

		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			foreach( NimoUsage usage in usageList )
			{
				NimoUsageDataExistsRule rule = new NimoUsageDataExistsRule( accountNumber, usage );
				if( !rule.Validate() )
					AddException( rule.Exception, accountNumber );

			}

			return this.Exception == null;
		}

		private void AddException( BrokenRuleException exception, string accountNumber )
		{
			if( exception == null )
			{
				string format = "Missing usage data for account {0}.";
				this.SetException( String.Format( format, accountNumber ) );
			}

			foreach( BrokenRuleException dependentException in exception.DependentExceptions )
			{
				this.AddDependentException( dependentException );

				// set severity to that of the dependent exception
				this.DefaultSeverity = dependentException.Severity;
			}
		}
	}
}
