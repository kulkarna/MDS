namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Rule to validate Bge's usage data.
	/// It adds some properties of the
	/// usage to be validated:
	/// 
	/// 1. On Peak Kwh
	/// 2. Off Peak Kwh
	/// 3. Delivery Demand Kw
	/// </summary>
	[Guid( "C1B9754C-5C11-494f-B7E4-637723964905" )]
	public class BgeUsageDataExistsRule : WebUsageDataExistsRule
	{
		/// <summary>
		/// Contructor that receives a bge usage to be
		/// validated.
		/// </summary>
		/// <param name="usage">The usage to be validated</param>
		public BgeUsageDataExistsRule( BgeUsage usage )
			: base( "Bge Usage Rule", BrokenRuleSeverity.Information, usage, "Bge Usage Data" )
		{
			string period;

			try
			{
				period = " for period " + usage.BeginDate.ToString( "MM/dd/yy" ) + " - " + usage.EndDate.ToString( "MM/dd/yy" );
			}
			catch { period = ""; }

			NumericalDataExistsRule nrule = new NumericalDataExistsRule( BrokenRuleSeverity.Error, usage.OnPeakKwh, "On Peak Kwh" + period );
			AddDataValidationRule( nrule );

			nrule = new NumericalDataExistsRule( BrokenRuleSeverity.Error, usage.OffPeakKwh, "Off Peak Kwh" + period );
			AddDataValidationRule( nrule );

            //nrule = new NumericalDataExistsRule( BrokenRuleSeverity.Error, usage.DeliveryDemandKw, "Delivery Demand Kw" + period );
            //AddDataValidationRule( nrule );
		}
	}
}
