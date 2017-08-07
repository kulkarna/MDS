namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that the usages in list have data.
	/// </summary>
	[Guid( "79F1CFF1-A34E-44c5-ABC3-C89726CCCC8E" )]
	public class UsageListDataExistsRule : BusinessRule
	{
		private string accountNumber;
		private EdiUsageList usageList;

		/// <summary>
		/// Constructor that takes an account number and a edi usage list object
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="usageList">Edi usage list object</param>
		public UsageListDataExistsRule( string accountNumber, ref EdiUsageList usageList )
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
			foreach( EdiUsage usage in usageList )
			{
				UsageDataExistsRule rule = new UsageDataExistsRule( accountNumber, usage );
				if( !rule.Validate() )
				{
					AddException( rule.Exception, accountNumber );
				}
			}
			return this.Exception == null;
		}

		private void AddException( BrokenRuleException exception, string accountNumber )
		{
			if( this.Exception == null )
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
