namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that the usages in list have data.
	/// </summary>
	[Guid( "012ACED9-3681-41c0-AE81-955BDF00A6CE" )]
	public class ConedUsageListDataExistsRule : BusinessRule
	{
		private string accountNumber;
		private WebUsageList usageList;

		/// <summary>
		/// Constructor that takes an account number and a usage list object
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="usageList">Edi usage list object</param>
		public ConedUsageListDataExistsRule( string accountNumber, WebUsageList usageList )
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
			foreach( ConedUsage usage in usageList )
			{
				ConedUsageDataExistsRule rule = new ConedUsageDataExistsRule( accountNumber, usage );
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
