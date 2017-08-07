namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate cenhud's usage list data.
	/// It validates if the list contains data
	/// and, if so, all the usages in the list will be
	/// validated also.
	/// </summary>
	[Guid( "A25416AB-6CC0-44d3-967D-9D77A1BFFE4A" )]
	public class CenhudUsageListDataExistsRule : WebUsageListDataExistsRule<CenhudUsage>
	{
		/// <summary>
		/// Contructor that receives a cenhud usage list to be
		/// validated. 
		/// </summary>
		/// <param name="usageList">The usage list to be validated</param>
		public CenhudUsageListDataExistsRule( WebUsageList usageList )
			: base( "Cenhud Usage History Rule", BrokenRuleSeverity.Error, usageList, "Cenhud Usage History Data" )
		{
		}

		protected override WebUsageDataExistsRule GetWebUsageDataExistsRule( CenhudUsage usage )
		{
			return new CenhudUsageDataExistsRule( usage );
		}
	}
}
