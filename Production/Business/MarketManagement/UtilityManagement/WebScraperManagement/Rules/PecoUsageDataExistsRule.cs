namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Peco's usage data.
	/// It adds some properties of the
	/// usage to be validated:
	/// 
	/// 1. Demand
	/// </summary>
	[Guid( "6B52E3AB-E0C3-430f-B0FB-6E4F81B654EA" )]
	public class PecoUsageDataExistsRule : WebUsageDataExistsRule
	{
		public PecoUsageDataExistsRule( PecoUsage usage )
			: base( "Peco Usage Rule", BrokenRuleSeverity.Error, usage, "Peco Usage Data" )
		{
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, usage.Demand, "Demand" ) );
		}
	}
}
