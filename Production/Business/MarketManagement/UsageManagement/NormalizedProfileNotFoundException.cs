using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class NormalizedProfileNotFoundException : UsageManagementException
	{
		public NormalizedProfileNotFoundException() : base() { }
		public NormalizedProfileNotFoundException(string message) : base(message) { }
		public NormalizedProfileNotFoundException( string message, Exception innerException ) : base(message, innerException) { }
	}
}
