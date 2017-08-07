namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonEntity;

	/// <summary>
	/// Rule to validate cmp's usage list data.
	/// </summary>
	[Guid( "77C14A09-C342-45b0-B0E2-E0A2D7FC122E" )]
	public class CmpUsageListDataExistsRule : WebUsageListDataExistsRule<CmpUsage>
	{
		/// <summary>
		/// Contructor that receives a cmp usage list to be
		/// validated. It validates if the list contains data
		/// and, if so, all the usages in the list will be
		/// validated also.
		/// </summary>
		/// <param name="usageList">The usage list to be validated</param>
		public CmpUsageListDataExistsRule( WebUsageList usageList )
			: base( "Cmp Usage History Rule", BrokenRuleSeverity.Error, usageList, "Cmp Usage History Data" )
		{
		}

		protected override WebUsageDataExistsRule GetWebUsageDataExistsRule( CmpUsage usage )
		{
			return new CmpUsageDataExistsRule( usage );
		}
	}
}
