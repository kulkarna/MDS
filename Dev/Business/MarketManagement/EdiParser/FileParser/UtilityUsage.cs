namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;

	/// <summary>
	/// Utility usage object that inherits from the usage object
	/// </summary>
	public class UtilityUsage : Usage
	{
		/// <summary>
		/// Measurement significance code
		/// </summary>
		public string MeasurementSignificanceCode
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
		/// Unit of measurement
		/// </summary>
		public string UnitOfMeasurement
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
		/// PTD Loop identifier
		/// </summary>
		public string PtdLoop
		{
			get;
			set;
		}

		/// <summary>
		/// Service delivery point, also called Location number in MISO
		/// </summary>
		public string ServiceDeliveryPoint
		{
			get;
			set;
		}
	}
}
