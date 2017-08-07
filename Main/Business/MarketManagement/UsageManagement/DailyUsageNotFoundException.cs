using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class DailyUsageNotFoundException : UsageManagementException
	{
		public DailyUsageNotFoundException() : base() { }
		public DailyUsageNotFoundException(string message) : base(message) { }
		public DailyUsageNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
