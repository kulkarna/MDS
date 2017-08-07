namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// CTPEN utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class CtpenMarker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public CtpenMarker()
		{
			this.AccountNumberCell = 3;
			this.BeginDateCell = 2;
			this.BillGroupCell = 2;
			this.BillingAccountNumberCell = 2;
			this.CustomerNameCell = 2;
			this.DunsNumberCell = 4;
			this.EndDateCell = 2;
			this.IcapCell = 3;
			this.LoadProfileCell = 2;
			this.MeasurementSignificanceCodeCell = 7;
			this.MeterNumberCell = 2;
			this.NameKeyCell = 2;
			this.PreviousAccountNumberCell = 2;
			this.PtdLoopCell = 1;
			this.QuantityAltCell = 2;
			this.QuantityCell = 3;
			this.RateClassCell = 2;
			this.TcapCell = 3;
			this.TransactionSetPurposeCodeCell = 1;
			this.UnitOfMeasurementAltCell = 3;
			this.UnitOfMeasurementCell = 4;
			this.UsageTypeCell = 2;
			this.UtilityCode = "CTPEN";
			this.ZoneCell = 3;
            this.IdrMeterNumberCell = 5;
			this.IdrDateCell = 2;
			this.IdrIntervalCell = 3;
			this.IdrQuantityCell = 2;
//			this.IdrUnitOfMeasurementCell = 3;		-- REF*MT*KH015		:-??
            this.TransactionCreationDateCell = 3;
		}
	}
}
