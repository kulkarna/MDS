namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Cenhud's account data.
	/// It adds some properties of the
	/// account to be validated:
	/// 
	/// 1. Bill Frequency
	/// 2. Rate Code
	/// 3. Tax Rate
	/// 4. Usage Factor
	/// </summary>
	[Guid( "8653D5D3-B04F-4f5b-B554-FDF5C891F57F" )]
    public class CenhudAccountDataExistsRule : CenhudAccountWebDataExistsRule
	{
		/// <summary>
		/// Contructor that receives a cenhud account to be
		/// validated. 
		/// </summary>
		/// <param name="account">The account to be validated</param>
		public CenhudAccountDataExistsRule( Cenhud account )
			: base( "Cenhud Account Rule", BrokenRuleSeverity.Error, account, "Cenhud Account Data" )
		{
			AddDataValidationRule( new StringDataExistsRule( DefaultSeverity, account.BillFrequency, "Bill Frequency" ) );
			AddDataValidationRule( new StringDataExistsRule( DefaultSeverity, account.RateCode, "Rate Code" ) );
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, account.SalesTaxRate, "Tax Rate" ) );
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, account.UsageFactor,"Usage Factor" ) );
		}

		protected override BusinessRule GetWebUsageListRule()
		{
			return new CenhudUsageListDataExistsRule( target.WebUsageList );
		}
	}
}
