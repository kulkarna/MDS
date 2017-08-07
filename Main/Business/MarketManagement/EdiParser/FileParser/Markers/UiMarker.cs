namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{

	/// <summary>
	/// UI utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class UiMarker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public UiMarker()
		{
			UtilityCode = "UI";
			AccountNumberCell = 2;
			BeginDateCell = 6;
			BillingAccountNumberCell = 2;
			CustomerNameCell = 2;
			DunsNumberCell = 4;
			EndDateCell = 6;
			IcapCell = 2;
			QuantityCell = 3;
			MeasurementSignificanceCodeCell = 7;
			MeterNumberCell = 2;
			NameKeyCell = 2;
			PreviousAccountNumberCell = 2;
			RateClassCell = 2;
			TcapCell = 3;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementCell = 4;
			ZoneCell = 2;
			BillGroupCell = 2;
			LoadProfileCell = 2;
			QuantityAltCell = 2;
			UnitOfMeasurementAltCell = 3;
            this.TransactionCreationDateCell = 3;
		}
	}
}
