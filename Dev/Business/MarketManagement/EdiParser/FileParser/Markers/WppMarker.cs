namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// WPP utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class WppMarker:MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public WppMarker()
		{
			AccountNumberCell = 2;
			BeginDateCell = 2;
			BillGroupCell = 2;
			CustomerNameCell = 2;
			DunsNumberCell = 4;
			EndDateCell = 2;
			EspAccountCell = 2;
			IcapCell = 2;
			LoadProfileCell = 2;
//			this.MeasurementSignificanceCodeCell = 7;
			MeterNumberCell = 2;
//			this.NameKeyCell = 2;
			PreviousAccountNumberCell = 2;
			PtdLoopCell = 1;
			QuantityCell = 2;
//			this.QuantityAltCell = 2;
			RateClassCell = 2;
			TcapCell = 2;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementCell = 3;
//			this.UnitOfMeasurementAltCell = 3;
			UtilityCode = "WPP";
			VoltageCell = 2;
//			this.ZoneCell = 3;
			IcapTcapDateRangeCell = 6;
            this.TransactionCreationDateCell = 3;
			IdrDateCell = 2;
			IdrIntervalCell = 3;
			IdrQuantityCell = 2;
			IdrUnitOfMeasurementCell = 3;
		}
	}
}
