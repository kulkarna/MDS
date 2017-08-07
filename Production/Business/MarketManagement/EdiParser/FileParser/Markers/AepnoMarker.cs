namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// AEPNO utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class AepnoMarker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public AepnoMarker()
		{
			AccountNumberCell = 3;
			BeginDateCell = 2;
			BillGroupCell = 2;
			BillingAccountNumberCell = 2;
			CustomerNameCell = 2;
			DunsNumberCell = 4;
			EndDateCell = 2;
			IcapCell = 3;
			LoadProfileCell = 2;
			MeasurementSignificanceCodeCell = 7;
			MeterNumberCell = 2;
			NameKeyCell = 2;
			PreviousAccountNumberCell = 2;
			PtdLoopCell = 1;
			QuantityAltCell = 2;
			QuantityCell = 3;
			RateClassCell = 2;
			TcapCell = 3;
			TransactionSetPurposeCodeCell = 1;
			UnitOfMeasurementAltCell = 3;
			UnitOfMeasurementCell = 4;
			UsageTypeCell = 2;
			UtilityCode = "AEPNO";
			ZoneCell = 3;
            this.IdrMeterNumberCell = 5;
			IdrDateCell = 2;
			IdrIntervalCell = 3;
			IdrQuantityCell = 2;
//			IdrUnitOfMeasurementCell = 3;
            this.TransactionCreationDateCell = 3;
		}
	}
}
