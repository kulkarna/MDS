namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Collections.Generic;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate WebUsage's data.
	/// It adds some properties of the
	/// usage to be validated:
	/// 
	/// 1. Begin Date
	/// 2. End Date
	/// 3. Days
	/// 4. Total Kwh
	/// </summary>
	[Guid( "1B81C908-2A6F-47ae-BC8F-136DFF6E49F8" )]
	public abstract class WebUsageDataExistsRule : GenericCompositeDataExistsRule<WebUsage>
	{
		/// <summary>
		/// Constructor that receives the rule name,
		/// the data to be validated and its description
		/// </summary>
		/// <param name="ruleName">The name of the rule</param>
		/// <param name="usage">Data to be validated</param>
		/// <param name="dataDescription">The description of tedata to be validated</param>
		public WebUsageDataExistsRule( string ruleName, WebUsage usage, string dataDescription )
			: this( ruleName, BrokenRuleSeverity.Error, usage, dataDescription )
		{
		}

		/// <summary>
		/// Constructor that receives the name of the rule, its severity,
		/// the data to be validated and its description
		/// </summary>
		/// <param name="ruleName">The name of the rule</param>
		/// <param name="severity">Te severity of the rule</param>
		/// <param name="usage">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public WebUsageDataExistsRule( string ruleName, BrokenRuleSeverity severity, WebUsage usage, string dataDescription )
			: base( ruleName, severity, usage, dataDescription )
		{
			usage.UsageDataExistsRule = this;

			string period;

			try
			{
				period = " for period " + usage.BeginDate.ToString( "MM/dd/yy" ) + " - " + usage.EndDate.ToString( "MM/dd/yy" );
			}
			catch { period = ""; }

			AddDataValidationRule( new DateTimeDataExistsRule( BrokenRuleSeverity.Error, usage.BeginDate, "Begin Date" ) );
			AddDataValidationRule( new DateTimeDataExistsRule( BrokenRuleSeverity.Error, usage.EndDate, "End Data" ) );
			//AddDataValidationRule( new NumericalDataExistsRule( BrokenRuleSeverity.Error, usage.Days, "Days" + period ) );
			AddDataValidationRule( new NumericalDataExistsRule( BrokenRuleSeverity.Error, usage.TotalKwh, "Total Kwh" + period ) );
		}
	}
}
