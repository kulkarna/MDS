using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	[Serializable]
	public class UtilityNotFoundException : UtilityManagementException
	{
		/// <summary>
		/// Base exception
		/// </summary>
		public UtilityNotFoundException() : base() { }
		/// <summary>
		/// Base with message
		/// </summary>
		/// <param name="message">Message</param>
		public UtilityNotFoundException(string message) : base(message) { }
		/// <summary>
		/// Base with message and inner exception
		/// </summary>
		/// <param name="message">Message</param>
		/// <param name="innerException">Inner exception</param>
		public UtilityNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }

	}
}
