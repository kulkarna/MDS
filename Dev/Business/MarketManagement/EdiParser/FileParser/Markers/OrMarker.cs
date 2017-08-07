namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// OandR utility marker.
	///  Contains the generic cell positions of property values.
	/// </summary>
	public class OrMarker : MarkerBase
	{
		/// <summary>
		/// Two utilities, one duns number.. only way to differentiate is by the name sent in row N1*8S
		/// </summary>
		public Int16 UtilityNameResolverCell;

		/// <summary>
		/// Constructor that sets cell positions for utility.
		/// </summary>
		public OrMarker()
		{
			this.AccountNumberCell = 2;
			this.AddressCell = 1;
			this.BeginDateCell = 2;
			this.BillGroupCell = 2;
			this.BillingAccountNumberCell = 2;
			this.CityCell = 1;
			this.CustomerNameCell = 2;
			this.DunsNumberCell = 4;
			this.EndDateCell = 2;
			this.EspAccountCell = 2;											// leslie - 10/18/2010
			this.IcapCell = 2;
			this.LoadProfileCell = 2;
			this.MeasurementSignificanceCodeCell = 7;
			this.MeterNumberCell = 2;
			this.NameKeyCell = 2;
			this.PreviousAccountNumberCell = 2;
			this.QuantityAltCell = 2;
			this.QuantityCell = 3;
			this.RateClassCell = 2;
			this.StateCell = 2;
			this.TcapCell  = 2;
			this.TransactionSetPurposeCodeCell = 1;
			this.UnitOfMeasurementAltCell = 3;
			this.UnitOfMeasurementCell = 4;
            this.IcapTcapDateRangeCell = 6;
			//this.UtilityCode = "O&R";											// leslie - bug 2840 10/25/2010
			this.UtilityNameResolverCell = 2;									// leslie - bug 2840 10/25/2010
			this.ZipCell = 3;
			this.ZoneCell = 2;
            this.TransactionCreationDateCell = 3;
		}
	}
}
