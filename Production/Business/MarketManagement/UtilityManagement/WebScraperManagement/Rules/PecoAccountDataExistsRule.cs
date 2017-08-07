namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Peco's account data.
	/// It adds some properties of the
	/// account to be validated:
	/// 
	/// 1. Icap Start Date
	/// 2. Icap End Date
	/// 3. Tcap Begin Date
	/// 4. Tcap End Date
	/// 5. Rate Code
	/// </summary>
	[Guid( "DF936EB6-3F46-4490-B9CC-CD40A1859D85" )]
    public class PecoAccountDataExistsRule : PecoAccountWebDataExistsRule
	{
		/// <summary>
		/// Contructor that receives a peco account to be
		/// validated. 
		/// </summary>
		/// <param name="account">The account to be validated</param>
		public PecoAccountDataExistsRule( Peco account )
			: base( "Peco Account Rule", BrokenRuleSeverity.Error, account, "Peco Account Data" )
		{
			AddDataValidationRule( new DateTimeDataExistsRule( DefaultSeverity, account.IcapStartDate, "Icap Start Date" ) );
			AddDataValidationRule( new DateTimeDataExistsRule( DefaultSeverity, account.IcapEndDate, "Icap End Date" ) );
			AddDataValidationRule( new DateTimeDataExistsRule( DefaultSeverity, account.TcapBeginDate, "Tcap Begin Date" ) );
			AddDataValidationRule( new DateTimeDataExistsRule( DefaultSeverity, account.TcapEndDate, "Tcap End Date" ) );
			
		}

		protected override BusinessRule GetWebUsageListRule()
		{
			return new PecoUsageListDataExistsRule( target.WebUsageList );
		}
	}
}
