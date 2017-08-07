namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate peco's usage list data.
	/// It validates if the list contains data
	/// and, if so, all the usages in the list will be
	/// validated also.
	/// </summary>
	[Guid( "4A832E27-400C-471d-A9E3-6723EBD72D6E" )]
	public class PecoUsageListDataExistsRule : WebUsageListDataExistsRule<PecoUsage>
	{
		/// <summary>
		/// Contructor that receives a peco usage list to be
		/// validated. 
		/// </summary>
		/// <param name="usageList">The usage list to be validated</param>
		public PecoUsageListDataExistsRule( WebUsageList usageList )
			: base( "Peco Usage History Rule", BrokenRuleSeverity.Error, usageList, "Peco Usage History Data" )
		{
		}

		protected override WebUsageDataExistsRule GetWebUsageDataExistsRule( PecoUsage usage )
		{
			return new PecoUsageDataExistsRule( usage );
		}
	}
}
