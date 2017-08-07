namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// ALLEGMD utility mapper.
	/// Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class AlleghenyMarker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public AlleghenyMarker()
		{
			AccountNumberCell = 2;
			AddressCell = 1;
			BeginDateCell = 2;
			BillGroupCell = 2;
			BillingAccountNumberCell = 2;
			CityCell = 1;
			CustomerNameCell = 2;
			CustomerNameCell = 2;
			DunsNumberCell = 4;
			EndDateCell = 2;
			IcapCell = 2;
			LoadProfileCell = 2;
			MeasurementSignificanceCodeCell = 7;
			MeterNumberCell = 2;
			PtdLoopCell = 1;
			PreviousAccountNumberCell = 2;
			QuantityAltCell = 2;
			QuantityCell = 3;
			RateClassCell = 2;
			StateCell = 2;
			TcapCell = 2;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementAltCell = 3;
			UnitOfMeasurementCell = 4;
			UtilityCode = "ALLEGMD";
			VoltageCell = 2;
			ZipCell = 3;
            this.TransactionCreationDateCell = 3;
		}
	}
}
