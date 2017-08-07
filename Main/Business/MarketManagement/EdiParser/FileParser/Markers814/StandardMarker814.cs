namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// Marker with the most common cell positions for files 814.
	/// </summary>
	public class StandardMarker814 : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public StandardMarker814( string utilityCode )
		{
			UtilityCode = utilityCode;

			AccountNumberCell = 2;
			AccountStatusCell = 2;
			AddressCell = 1;
			AnuualUsageCell = 2;
			BillCalculationCell = 2;
			BillGroupCell = 2;
			BillingTypeCell = 2;
			BillToCell = 2;
			CityCell = 1;
			ContactInfoCell = 1;
			CustomerNameCell = 2;
			DunsNumberCell = 4;
			EspAccountCell = 2;
			IcapCell = 2;
			LoadProfileCell = 2;
			MeterAttributesCell = 9;
			MeterMultiplierCell = 2;
			MeterNumberCell = 2;
			MeterTypeCell = 2;
			NetMeterTypeCell = 2;
			MonthsToComputeKwhCell = 2;
			PreviousAccountNumberCell = 2;
			RateClassCell = 2;
			RateCodeCell = 2;
			ServiceDeliveryPointCell = 2;
			ServicePeriodEndCell = 2;
			ServicePeriodStartCell = 2;
			EffectiveDateCell = 2;
			ServiceTypeCell = 2;
			StateCell = 2;
			TcapCell = 2;
			TransactionTypeCell = 1;
			VoltageCell = 2;
			ZipCell = 3;
			ZoneCell = 3;
            DaysInArrearsCell = 2;
            TransactionCreationDateCell = 3;
            IcapEffectiveDateCell = 6;
            TcapEffectiveDateCell = 6;
		}
	}
}
