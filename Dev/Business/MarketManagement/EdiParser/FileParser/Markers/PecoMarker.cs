namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// PECO utility marker.
	/// </summary>
	public class PecoMarker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public PecoMarker()
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
			PtdLoopCell = 1;
			QuantityCell = 2;
			RateClassCell = 2;
			TcapCell = 2;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementCell = 3;
			UtilityCode = "PECO";
			IcapTcapDateRangeCell = 6;
            this.TransactionCreationDateCell = 3;
			IdrDateCell = 2;
			IdrIntervalCell = 3;
			IdrQuantityCell = 2;
			IdrUnitOfMeasurementCell = 3;
            this.MeterNumberCell = 2;
		}
	}
}
