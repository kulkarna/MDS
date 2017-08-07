namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Cenhud's usage data.
	/// It adds some properties of the
	/// usage to be validated:
	/// 
	/// 1. Read Code
	/// 2. Number of Months
	/// 3. Total Billed Amount
	/// 4. On Peak Kwh
	/// 5. Off Peak Kwh
	/// 6. Demand Kw
	/// 7. Sales Tax
	/// </summary>
	[Guid( "E9E26AB2-7F95-4528-A625-9C321A7C9827" )]
	public class CenhudUsageDataExistsRule : WebUsageDataExistsRule
	{
		/// <summary>
		/// Contructor that receives a cenhud usage to be validated. 
		/// </summary>
		/// <param name="usage">The usage to be validated</param>
		public CenhudUsageDataExistsRule( CenhudUsage usage )
			: base( "Cenhud Usage Rule", BrokenRuleSeverity.Error, usage, "Cenhud Usage Data" )
		{
			AddDataValidationRule( new StringDataExistsRule( DefaultSeverity, usage.ReadCode, "Read Code" ) );
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, usage.NumberOfMonths, "Number of Months" ) );
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, usage.TotalBilledAmount, "Total Billed Amount" ) );
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, usage.OnPeakKwh, "On Peak Kwh" ) );
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, usage.OffPeakKwh, "Off Peak Kwh" ) );
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, usage.DemandKw, "Demand Kw" ) );
			AddDataValidationRule( new NumericalDataExistsRule( DefaultSeverity, usage.SalesTax, "Sales Tax" ) );
		}
	}
}
