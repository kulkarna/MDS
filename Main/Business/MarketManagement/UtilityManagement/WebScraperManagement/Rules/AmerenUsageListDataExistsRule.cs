namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Ameren's usage list data.
	/// It validates if the list contains data
	/// and, if so, all the usages in the list will be
	/// validated also.
	/// </summary>
	[Guid( "6B116775-BBDD-47b4-A625-B8D505EE3FB1" )]
	public class AmerenUsageListDataExistsRule : WebUsageListDataExistsRule<AmerenUsage>
	{
		/// <summary>
		/// Contructor that receives a ameren usage list to be
		/// validated. 
		/// </summary>
		/// <param name="usageList">The usage list to be validated</param>
		public AmerenUsageListDataExistsRule( WebUsageList usageList )
			: base( "Ameren Usage History Rule", BrokenRuleSeverity.Error, usageList, "Ameren Usage History Data" )
		{ 
		}

		protected override WebUsageDataExistsRule GetWebUsageDataExistsRule( AmerenUsage usage )
		{
			return new AmerenUsageDataExistsRule( usage );
		}
	}
}
