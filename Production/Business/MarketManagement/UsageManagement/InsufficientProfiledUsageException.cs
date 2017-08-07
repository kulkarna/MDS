using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Exception to be raised when there is insufficient profiled (utility) usage
	/// </summary>
	// EP - 01-26-2009
	public class InsufficientProfiledUsageException : UsageManagementException
	{
		public InsufficientProfiledUsageException() : base() { }
		public InsufficientProfiledUsageException( string message ) : base( message ) { }
		public InsufficientProfiledUsageException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
