namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	public class OhpMaker : MarkerBase
	{
		public OhpMaker()
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
			TcapCell = 2;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementAltCell = 3;
			UnitOfMeasurementCell = 4;
			UsageTypeCell = 2;
			UtilityCode = "OHP";
			ZipCell = 3;
			ZoneCell = 2;
            IcapTcapDateRangeCell = 6;
			IdrDateCell = 2;
			IdrIntervalCell = 3;
			IdrQuantityCell = 2;
            this.TransactionCreationDateCell = 3;
		}
	}
}
