namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// DELDE utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class DelmarvaMarker : MarkerBase
	{
		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public DelmarvaMarker()
		{
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
            this.TransactionCreationDateCell = 3;
		}
	}
}
