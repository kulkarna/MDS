using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	[Serializable]
	class ZoneNotFoundException : UsageManagementException
	{
		/// <summary>
		/// base()
		/// </summary>
		public ZoneNotFoundException() : base() { }
		/// <summary>
		/// string message) : base(message)
		/// </summary>
		/// <param name="message"></param>
		public ZoneNotFoundException(string message) : base(message) { }
		/// <summary>
		/// string message, Exception innerException
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public ZoneNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }

	}
}
