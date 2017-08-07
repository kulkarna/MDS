using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public class UsageNotFoundException : UsageManagementException
	{
		public UsageNotFoundException() : base() { }
		public UsageNotFoundException(string message) : base(message) { }
		public UsageNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
