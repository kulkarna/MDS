namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using LibertyPower.Business.MarketManagement.UtilityManagement;

	/// <summary>
	/// Utility idr usage object that inherits from the idrUsage object
	/// </summary>
	public class UtilityIdrUsage : IdrUsage
	{
		/// <summary>
		/// Ptd loop
		/// </summary>
		public string PtdLoop
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
	}
}
