namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Ameren's account data.
	/// It adds some properties of the
	/// account to be validated:
	/// 
	/// 1. Supply Voltage
	/// 2. Delivery Voltage
	/// 3. Meter Voltage
	/// 4. Effective PLC
	/// </summary>
	[Guid( "5CD4FFDF-371D-4b7b-B1A7-931ED34EF1C4" )]
    public class AmerenAccountDataExistsRule : AmerenAccountWebDataExistsRule
	{
		/// <summary>
		/// Contructor that receives a ameren account to be
		/// validated. 
		/// </summary>
		/// <param name="account">The account to be validated</param>
		public AmerenAccountDataExistsRule( Ameren account )
			: base( "Ameren Account Rule", BrokenRuleSeverity.Information, account, "Ameren Account Data" )
		{
			//StringDataExistsRule srule = new StringDataExistsRule( BrokenRuleSeverity.Error, account.ServicePoint, "Service Point" );
			//AddDataValidationRule( srule );

			var srule = new StringDataExistsRule( BrokenRuleSeverity.Error, account.LoadShapeId, "Profile Class" );
			AddDataValidationRule( srule );

			srule = new StringDataExistsRule( BrokenRuleSeverity.Error, account.ServiceClass, "Current Delivery Services Class" );
			AddDataValidationRule( srule );

                
			//NumericalDataExistsRule nrule = new NumericalDataExistsRule( BrokenRuleSeverity.Error, account.EffectivePLC, "Effective PLC" );
			//AddDataValidationRule( nrule );
		}

		protected override BusinessRule GetWebUsageListRule()
		{
			return new AmerenUsageListDataExistsRule( target.WebUsageList );
		}
	}
}
