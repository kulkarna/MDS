using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Exception used when Icap factor is not found for a given date range
	/// </summary>
	public class IcapFactorNotFoundException : UsageManagementException
	{
		/// <summary>
		/// 
		/// </summary>
		public IcapFactorNotFoundException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public IcapFactorNotFoundException(string message) : base(message) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public IcapFactorNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }

	}
}
