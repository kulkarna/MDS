namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Edi usage object
	/// </summary>
	public class EdiUsage
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public EdiUsage() 
		{
			this.BeginDate = DateHelper.DefaultDate;
			this.EndDate = DateHelper.DefaultDate;
			this.UnitOfMeasurement = string.Empty;
			this.MeasurementSignificanceCode = string.Empty;
			this.Quantity = 0;
		}

		public override string ToString()
		{
			try
			{
				var description = string.Format( "Usage from {0} to {1}: {2}, {3}, {4}, {5}", BeginDate.ToShortDateString(), EndDate.ToShortDateString(), Quantity, UnitOfMeasurement, TransactionSetPurposeCode, MeasurementSignificanceCode );
				return description;
			}
			catch { }

			return base.ToString();
		}

		/// <summary>
		/// Usage data exists business rule
		/// </summary>
		public UsageDataExistsRule UsageDataExistsRule
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
		/// Meter number
		/// </summary>
		public string MeterNumber
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
		/// Measurement significance code
		/// </summary>
		public string MeasurementSignificanceCode
		{
			get;
			set;
		}

		/// <summary>
		/// Product transfer type code - indicates whether meter is billied, summary, meter level, etc
		/// </summary>
		public string PtdLoop
		{
			get;
			set;
		}

		/// <summary>
		/// Service delivery point, also called location number (MISO)
		/// </summary>
		public string ServiceDeliveryPoint
		{
			get;
			set;
		}

        /// <summary>
        /// Historical section.
        /// For further information <see cref="T:LibertyPower.Business.MarketManagement.EdiParser.FileParser.HistoricalSection"/>.
        /// </summary>
        public string HistoricalSection
        {
            get;
            set;
        }
	}
}
