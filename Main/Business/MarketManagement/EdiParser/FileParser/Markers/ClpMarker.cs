namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// CLP utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class ClpMarker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public ClpMarker()
		{
			this.AccountNumberCell = 2;
			this.BeginDateCell = 6;
			this.BillGroupCell = 2;
			this.BillingAccountNumberCell = 2;
			this.DunsNumberCell = 4;
			this.EndDateCell = 6;
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
			this.UtilityCode = "CL&P";
			this.ZoneCell = 2;
            this.TransactionCreationDateCell = 3;
		}
	}
}
