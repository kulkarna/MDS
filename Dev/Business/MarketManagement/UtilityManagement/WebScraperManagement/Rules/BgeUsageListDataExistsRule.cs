namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Bge's usage list data.
	/// It validates if the list contains data
	/// and, if so, all the usages in the list will be
	/// validated also.
	/// </summary>
	[Guid( "A1B65F8F-6A22-4354-8F06-C7B24A00CFD0" )]
	public class BgeUsageListDataExistsRule : WebUsageListDataExistsRule<BgeUsage>
	{
		/// <summary>
		/// Contructor that receives a bge usage list to be
		/// validated.
		/// </summary>
		/// <param name="usageList">The usage list to be validated</param>
		public BgeUsageListDataExistsRule(WebUsageList usageList)
			: base("Bge Usage History Rule", BrokenRuleSeverity.Information, usageList, "Bge Usage History Data")
		{
		}

		protected override WebUsageDataExistsRule GetWebUsageDataExistsRule(BgeUsage usage)
		{
 			return new BgeUsageDataExistsRule(usage);
		}
	}
}
