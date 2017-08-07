namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	using LibertyPower.Business.MarketManagement.UtilityManagement;

	/// <summary>
	/// Class for EDI usage data
	/// </summary>
	public class EdiUsage
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public EdiUsage() { }

		/// <summary>
		/// Record identifier
		/// </summary>
		public int ID
		{
			get;
			set;
		}

		/// <summary>
		/// EDI account record identifier
		/// </summary>
		public int EdiAccountID
		{
			get;
			set;
		}

		/// <summary>
		/// Begin date
		/// </summary>
		public DateTime BeginDate
		{
			get;
			set;
		}

		/// <summary>
		/// End date
		/// </summary>
		public DateTime EndDate
		{
			get;
			set;
		}

		/// <summary>
		/// Quantity
		/// </summary>
		public decimal Quantity
		{
			get;
			set;
		}

		/// <summary>
		/// Meter number
		/// </summary>
		public string MeterNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Measurement significance code
		/// </summary>
		public string MeasurementSignificanceCode
		{
			get;
			set;
		}

		/// <summary>
		/// Transaction set purpose code
		/// </summary>
		public string TransactionSetPurposeCode
		{
			get;
			set;
		}

		/// <summary>
		/// Unit of measurement
		/// </summary>
		public string UnitOfMeasurement
		{
			get;
			set;
		}

		/// <summary>
		/// Service delivery point
		/// </summary>
		public string ServiceDeliveryPoint
		{
			get;
			set;
		}
	}
}
