namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Cmp's usage data.
	/// It adds some properties of the
	/// usage to be validated:
	/// 
	/// 1. Highest Demand Kw
	/// 2. Rate Code
	/// </summary>
	[Guid( "F6D6B9E4-C760-4871-BF42-AC04C8385B41" )]
	public class CmpUsageDataExistsRule : WebUsageDataExistsRule
	{
		/// <summary>
		/// Contructor that receives a cmp usage to be validated. 
		/// </summary>
		/// <param name="usage">The usage to be validated</param>
		public CmpUsageDataExistsRule( CmpUsage usage )
			: base( "Cmp Usage Rule", BrokenRuleSeverity.Error, usage, "Cmp Usage Data" )
		{
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, usage.HighestDemandKw, "Highest Demand Kw" ) );
			AddDataValidationRule( new StringDataExistsRule( DefaultSeverity, usage.RateCode, "Rate Code" ) );
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, usage.TotalUnmeteredServices, "Total Unmetered Services" ) );
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, usage.TotalActiveUnmeteredServices, "Total Active Unmetered Services" ) );
		}
	}
}
