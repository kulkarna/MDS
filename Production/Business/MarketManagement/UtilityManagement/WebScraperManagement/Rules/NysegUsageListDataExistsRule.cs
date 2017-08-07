namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	[Guid( "EE2CC5D8-4AD7-461f-ABCC-3865F63B02C4" )]
	public class NysegUsageListDataExistsRule : BusinessRule
	{
		private string accountNumber;
		private WebUsageList usageList;

		/// <summary>
		/// Constructor that takes an account number and a usage list object
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="usageList">Edi usage list object</param>
		public NysegUsageListDataExistsRule( string accountNumber, WebUsageList usageList )
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
			foreach( NysegUsage usage in usageList )
			{
				NysegUsageDataExistsRule rule = new NysegUsageDataExistsRule( accountNumber, usage );
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
