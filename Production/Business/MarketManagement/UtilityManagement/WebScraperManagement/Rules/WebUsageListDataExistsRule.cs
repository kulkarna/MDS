namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate webusage's history.
	/// </summary>
	/// <typeparam name="T">The type of WebUsage to validate</typeparam>
	[Guid( "92B25377-AE15-4a68-9AC2-27C18D6E92B1" )]
	public abstract class WebUsageListDataExistsRule<T>
		: GenericCompositeDataExistsRule<WebUsageList> where T : WebUsage
	{
		/// <summary>
		/// Constructor that receives the data to be validated and its description
		/// </summary>
		/// <param name="usageList">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public WebUsageListDataExistsRule( WebUsageList usageList, string dataDescription )
			: this( "Web Usage History Rule", BrokenRuleSeverity.Error, usageList, dataDescription )
		{
		}

		/// <summary>
		/// Constructor that receives severity,
		/// the data to be validated and its description
		/// </summary>
		/// <param name="defaultSeverity">Te severity of the rule</param>
		/// <param name="usageList">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public WebUsageListDataExistsRule( BrokenRuleSeverity defaultSeverity, WebUsageList usageList, string dataDescription )
			: this( "Web Usage History Rule", defaultSeverity, usageList, dataDescription )
		{
		}

		/// <summary>
		/// Constructor that receives the name of the rule, its severity,
		/// the data to be validated and its description
		/// </summary>
		/// <param name="ruleName">The name of the rule</param>
		/// <param name="defaultSeverity">Te severity of the rule</param>
		/// <param name="target">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public WebUsageListDataExistsRule( string ruleName, BrokenRuleSeverity defaultSeverity, WebUsageList usageList, string dataDescription ) :
			base( ruleName, defaultSeverity, usageList, dataDescription )
		{
			AddDataValidationRule
			(
				new ListDataExistsRule
				(
					"Web Usage List Rule",
					defaultSeverity,
					usageList,
					"Web Usage List Data"
				)
			);

			if( usageList != null )
			{
				foreach( T usage in usageList )
					AddDataValidationRule( GetWebUsageDataExistsRule( usage ) );
			}
		}

		protected abstract WebUsageDataExistsRule GetWebUsageDataExistsRule( T usage );
	}
}
