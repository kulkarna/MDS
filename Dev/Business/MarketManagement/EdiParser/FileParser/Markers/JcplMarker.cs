namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// JCPL utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class JcplMarker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public JcplMarker()
		{
			UtilityCode = "JCP&L";
			AccountNumberCell = 2;
			BeginDateCell = 2;
			BillingAccountNumberCell = 2;
			CustomerNameCell = 2;
			DunsNumberCell = 4;
			EndDateCell = 2;
			IcapCell = 2;
			QuantityCell = 3;
			MeasurementSignificanceCodeCell = 7;
			MeterNumberCell = 2;
			NameKeyCell = 2;
			PreviousAccountNumberCell = 2;
			RateClassCell = 2;
			TcapCell = 2;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementCell = 4;
			ZoneCell = 2;
			BillGroupCell = 2;
			LoadProfileCell = 2;
			QuantityAltCell = 2;
			UnitOfMeasurementAltCell = 3;
			PtdLoopCell = 1;
			VoltageCell = 2;
            IcapTcapDateRangeCell = 6;
			IdrDateCell = 2;
			IdrIntervalCell = 3;
			IdrQuantityCell = 2;
			IdrUnitOfMeasurementCell = 3;
            this.TransactionCreationDateCell = 3;
		}
	}
}
