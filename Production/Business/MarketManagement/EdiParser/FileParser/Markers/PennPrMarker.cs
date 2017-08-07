namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// PENNPR utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class PennPrMarker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public PennPrMarker()
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
			LossFactorCell = 2;
//			MeasurementSignificanceCodeCell = 7;
			MeterNumberCell = 2;
//			NameKeyCell = 2;
			PreviousAccountNumberCell = 2;
			PtdLoopCell = 1;
			QuantityCell = 2;
//			QuantityAltCell = 2;
			RateClassCell = 2;
			TcapCell = 2;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementCell = 3;
            IdrDateCell = 2;
            IdrIntervalCell = 3;
//			UnitOfMeasurementAltCell = 3;
			UtilityCode = "PENNPR";
			VoltageCell = 2;
//			ZoneCell = 3;
			IcapTcapDateRangeCell = 6;
            this.TransactionCreationDateCell = 3;
		}
	}
}
