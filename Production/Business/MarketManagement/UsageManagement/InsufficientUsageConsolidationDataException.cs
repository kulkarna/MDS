namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;

	/// <summary>
	/// Thrown when usage consolidation is missing, zone, load shape id, profiles, etc.
	/// </summary>
	public class InsufficientUsageConsolidationDataException : UsageManagementException
	{
		/// <summary>
		/// Base
		/// </summary>
		public InsufficientUsageConsolidationDataException() : base() { }
		/// <summary>
		/// Message
		/// </summary>
		/// <param name="message"></param>
		public InsufficientUsageConsolidationDataException( string message ) : base( message ) { }
		/// <summary>
		/// Inner exception
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public InsufficientUsageConsolidationDataException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
