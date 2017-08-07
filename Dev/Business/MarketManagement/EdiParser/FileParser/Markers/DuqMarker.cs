namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{

	/// <summary>
	/// DUQ utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class DuqMarker : MarkerBase
	{
		/// <summary>
		/// Measurement Significance Code Cell (Historical records)
		/// </summary>
		public int MeasurementSignificanceCodeCellHistorical
		{
			get;
			set;
		}

		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public DuqMarker()
		{
			UtilityCode = "DUQ";
			AccountNumberCell = 2;
			BeginDateCell = 2;
			BillingAccountNumberCell = 2;
			CustomerNameCell = 2;
			DunsNumberCell = 4;
			EndDateCell = 2;
			IcapCell = 2;
			QuantityCell = 3;
			MeasurementSignificanceCodeCellHistorical = 4;
			MeasurementSignificanceCodeCell = 7;
			MeterNumberCell = 2;
			NameKeyCell = 2;
			PreviousAccountNumberCell = 2;
			RateClassCell = 2;
			TcapCell = 2;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementCell = 4;
			ZoneCell = 3;
			BillGroupCell = 2;
			LoadProfileCell = 2;
			QuantityAltCell = 2;
			UnitOfMeasurementAltCell = 3;
			PtdLoopCell = 1;
			IcapTcapDateRangeCell = 6;

			IdrDateCell = 2;
			IdrIntervalCell = 3;
			IdrQuantityCell = 2;
			IdrUnitOfMeasurementCell = 3;
            this.TransactionCreationDateCell = 3;
		}
	}
}
