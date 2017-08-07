namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// IDR Usage Object
	/// </summary>
	public class EdiIdrUsage
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public EdiIdrUsage() { }

		public override string ToString()
		{
			try
			{
				var description = string.Format( "Idr usage from {0} - {1}, {2}", Date, Quantity, UnitOfMeasurement );
				return description;
			}
			catch { }

			return base.ToString();
		}

        /// <summary>
        /// Meter Number
        /// </summary>
        public string MeterNumber
        {
            get;
            set;
        }

		/// <summary>
		/// Date
		/// </summary>
		public DateTime Date
		{
			get;
			set;
		}

		/// <summary>
		/// PtdLoop value (i.e. BQ, SU, etc.)
		/// </summary>
		public string PtdLoop
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
		/// Interval (i.e. 15 mins, hourly, etc)
		/// </summary>
		public short Interval
		{
			get;
			set;
		}
	}
}
