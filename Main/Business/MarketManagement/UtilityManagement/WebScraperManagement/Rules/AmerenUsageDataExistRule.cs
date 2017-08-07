namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Ameren's usage data.
	/// It adds some properties of the usage to be validated:
	/// 
	/// 1. On Peak Kwh
	/// 2. Off Peak Kwh
	/// 3. On Peak Demand Kw
	/// 4. Off Peak Demand Kw
	/// </summary>
	[Guid( "F3640DCE-44E0-4ee1-9DD4-25118D652181" )]
	public class AmerenUsageDataExistsRule : WebUsageDataExistsRule
	{
		/// <summary>
		/// Contructor that receives a ameren usage to be validated. 
		/// </summary>
		/// <param name="usage">The usage to be validated</param>
		public AmerenUsageDataExistsRule( AmerenUsage usage )
			: base( "Ameren Usage Rule", BrokenRuleSeverity.Information, usage, "Ameren Usage Data" )
		{
		    return;
			string period;

			try
			{
				period = " for period " + usage.BeginDate.ToString( "MM/dd/yy" ) + " - " + usage.EndDate.ToString( "MM/dd/yy" );
			}
			catch { period = ""; }

			AddDataValidationRule( new StringDataExistsRule( DefaultSeverity, usage.MeterNumber, "Meter Number(s)" + period ) );
		}
	}
}
