namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// PEPCO-DC utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class PepcodcMarker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public PepcodcMarker()
		{
            // Abhi Kulkarni (1/23/2015): The utility code has already been passed in through the constructor
			//this.UtilityCode = "PEPCO-DC";
			this.AccountNumberCell = 2;
			this.BeginDateCell = 2;
			this.BillingAccountNumberCell = 2;
			this.CustomerNameCell = 2;
			this.DunsNumberCell = 4;
			this.EndDateCell = 2;
			this.IcapCell = 2;
			this.QuantityCell = 3;
			this.MeasurementSignificanceCodeCell = 7;
			this.MeterNumberCell = 2;
			this.NameKeyCell = 2;
			this.PreviousAccountNumberCell = 2;
			this.RateClassCell = 2;
			this.TcapCell = 2;
			this.TransactionSetPurposeCodeCell = 1;
			this.UnitOfMeasurementCell = 4;
			this.ZoneCell = 3;
			this.BillGroupCell = 2;
			this.LoadProfileCell = 2;
			this.QuantityAltCell = 2;
			this.UnitOfMeasurementAltCell = 3;
			this.PtdLoopCell = 1;
            this.IcapTcapDateRangeCell = 6;
            this.IdrDateCell = 2;
            this.IdrIntervalCell = 3;
            this.IdrQuantityCell = 2;
            this.TransactionCreationDateCell = 3;
		}
	}
}
