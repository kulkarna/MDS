using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Utility Management Exception inherits from Exception
	/// </summary>
	[Serializable]
	public class UtilityManagementException : Exception
	{
		/// <summary>
		/// Base exception
		/// </summary>
		public UtilityManagementException() : base() { }
		/// <summary>
		/// Base with message
		/// </summary>
		/// <param name="message">Message</param>
		public UtilityManagementException(string message) : base(message) { }
		/// <summary>
		/// Base with message and inner exception
		/// </summary>
		/// <param name="message">Message</param>
		/// <param name="innerException">Inner exception</param>
		public UtilityManagementException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
