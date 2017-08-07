using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// MeterReadNotFoundException
	/// </summary>
	class MeterReadDateNotFoundException : UsageManagementException
	{
		/// <summary>
		/// base()
		/// </summary>
		public MeterReadDateNotFoundException() : base() { }
		/// <summary>
		/// string message) : base(message)
		/// </summary>
		/// <param name="message"></param>
		public MeterReadDateNotFoundException(string message) : base(message) { }
		/// <summary>
		/// string message, Exception innerException
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public MeterReadDateNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }

	}
}
