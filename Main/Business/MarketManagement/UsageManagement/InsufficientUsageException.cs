using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class InsufficientUsageException : UsageManagementException
	{
		public InsufficientUsageException() : base() { }
		public InsufficientUsageException(string message) : base(message) { }
		public InsufficientUsageException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
