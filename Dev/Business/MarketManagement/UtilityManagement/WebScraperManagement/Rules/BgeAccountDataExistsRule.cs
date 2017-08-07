namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Bge's account data.
	/// It adds some properties of the
	/// account to be validated:
	/// 
	/// 1. Special Billing
	/// 2. Capacity PLC
	/// 3. Trans PLC
	/// 4. Customer Segment
	/// </summary>
	[Guid( "9F32B8B0-2B0B-492f-8C62-82B430827439" )]
    public class BgeAccountDataExistsRule : BgeAccountWebDataExistsRule
	{
		/// <summary>
		/// Contructor that receives a bge account to be
		/// validated. 
		/// </summary>
		/// <param name="account">The account to be validated</param>
		public BgeAccountDataExistsRule( Bge account )
			: base( "Bge Account Rule", BrokenRuleSeverity.Information, account, "Bge Account Data" )
		{
            //StringDataExistsRule srule = new StringDataExistsRule( DefaultSeverity, account.SpecialBilling, "Special Billing" );
            //AddDataValidationRule( srule );

            //NumericalDataExistsRule nrule = new NumericalDataExistsRule( BrokenRuleSeverity.Error, account.CapPLC, "Capacity PLC" );
            //AddDataValidationRule( nrule );

            //nrule = new NumericalDataExistsRule( BrokenRuleSeverity.Error, account.TransPLC, "Trans PLC" );
            //AddDataValidationRule( nrule );

			var srule = new StringDataExistsRule( BrokenRuleSeverity.Error, account.CustomerSegment, "Customer Segment" );
			AddDataValidationRule( srule );

            //srule = new StringDataExistsRule( BrokenRuleSeverity.Error, account.BillingAddress.Street, "Billing Address" );
            //AddDataValidationRule( srule );
		}

		protected override BusinessRule GetWebUsageListRule()
		{
			return new BgeUsageListDataExistsRule( target.WebUsageList );
		}
	}
}
