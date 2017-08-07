namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Cmp's account data.
	/// </summary>
	[Guid( "C89EB9C8-EFC3-411a-9BA8-69F29ABAE76F" )]
	public class CmpAccountDataExistsRule : WebAccountDataExistsRule
	{
		public CmpAccountDataExistsRule( Cmp account )
			: base( "Cmp Account Data Rule", BrokenRuleSeverity.Error, account, "Cmp Account Data" )
		{
		}

		protected override BusinessRule GetWebUsageListRule()
		{
			return new CmpUsageListDataExistsRule( target.WebUsageList );
		}
	}
}
