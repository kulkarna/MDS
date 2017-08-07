using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class InvalidTermException : UsageManagementException
	{
		public InvalidTermException() : base() { }
		public InvalidTermException(string message) : base(message) { }
		public InvalidTermException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
