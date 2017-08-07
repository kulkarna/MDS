using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class InvalidFlowStartDateException : UsageManagementException
	{
		public InvalidFlowStartDateException() : base() { }
		public InvalidFlowStartDateException(string message) : base(message) { }
		public InvalidFlowStartDateException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
