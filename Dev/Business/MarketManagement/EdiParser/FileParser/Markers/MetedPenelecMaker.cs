namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// Both Meted and Penelec come in one single file
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class MetedPenelecMaker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public MetedPenelecMaker()
		{
			AccountNumberCell = 2;
			BeginDateCell = 2;
			BillGroupCell = 2;
			BillingAccountNumberCell = 2;
			CustomerNameCell = 2;
			DunsNumberCell = 4;
			EndDateCell = 2;
			IcapCell = 2;
			LoadProfileCell = 2;
			LossFactorCell = 2;
			MeasurementSignificanceCodeCell = 7;
			MeterNumberCell = 2;
			NameKeyCell = 2;
			PreviousAccountNumberCell = 2;
			PtdLoopCell = 1;
			QuantityAltCell = 2;
			QuantityCell = 3;
			RateClassCell = 2;
			TcapCell = 2;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementAltCell = 3;
			UnitOfMeasurementCell = 4;
			UtilityCode = "PENELEC";
			VoltageCell = 2;
			ZoneCell = 3;
			IcapTcapDateRangeCell = 6;
            this.TransactionCreationDateCell = 3;
			IdrDateCell = 2;
			IdrIntervalCell = 3;
			IdrQuantityCell = 2;
			IdrUnitOfMeasurementCell = 3;
		}
	}
}
