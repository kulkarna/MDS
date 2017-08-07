using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Usage Management Exception inherits from Exception
	/// </summary>
	public class UsageManagementException : Exception
	{
		/// <summary>
		/// Base exception
		/// </summary>
		public UsageManagementException() : base() { }
		/// <summary>
		/// Base with message
		/// </summary>
		/// <param name="message">Message</param>
		public UsageManagementException(string message) : base(message) { }
		/// <summary>
		/// Base with message and inner exception
		/// </summary>
		/// <param name="message">Message</param>
		/// <param name="innerException">Inner exception</param>
		public UsageManagementException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
