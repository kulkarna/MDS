using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class InvalidFlowStartDateTermException : UsageManagementException
	{
		public InvalidFlowStartDateTermException() : base() { }
		public InvalidFlowStartDateTermException(string message) : base(message) { }
		public InvalidFlowStartDateTermException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
