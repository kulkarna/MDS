namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// SCE utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class SceMarker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public SceMarker()
		{
			UtilityCode = "SCE";
			AccountNumberCell = 2;
			BeginDateCell = 6;
			BillingAccountNumberCell = 2;
			CustomerNameCell = 2;
			DunsNumberCell = 4;
			EndDateCell = 6;
			IcapCell = 3;
			QuantityCell = 3;
			MeasurementSignificanceCodeCell = 7;
			MeterNumberCell = 2;
			NameKeyCell = 2;
			PreviousAccountNumberCell = 2;
			RateClassCell = 2;
			TcapCell = 3;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementCell = 2;
			ZoneCell = 3;
			BillGroupCell = 2;
			LoadProfileCell = 2;
			QuantityAltCell = 2;
			UnitOfMeasurementAltCell = 3;

			IdrDateCell = 2;
			IdrIntervalCell = 3;
			IdrQuantityCell = 2;
			IdrUnitOfMeasurementCell = 3;
            this.TransactionCreationDateCell = 3;
		}
	}
}
