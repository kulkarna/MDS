namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	///  CONED utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class ConedMarker : MarkerBase
	{
		public ConedMarker()
		{
			AccountNumberCell = 2;
			AddressCell = 1;
			BeginDateCell = 2;
			BillGroupCell = 2;
			BillingAccountNumberCell = 2;
			CityCell = 1;
			CustomerNameCell = 2;
			DunsNumberCell = 4;
			EndDateCell = 2;
			IcapCell = 2;
			LoadProfileCell = 2;
			MeasurementSignificanceCodeCell = 7;
			MeterNumberCell = 2;
			NameKeyCell = 2;
			PtdLoopCell = 1;
			PreviousAccountNumberCell = 2;
			QuantityAltCell = 2;
			QuantityCell = 3;
			RateClassCell = 2;
			StateCell = 2;
			TcapCell = 3;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementAltCell = 3;
			UnitOfMeasurementCell = 4;
			UtilityCode = "CONED";
			ZipCell = 3;
			ZoneCell = 2;
            this.TransactionCreationDateCell = 3;
		}
	}
}
