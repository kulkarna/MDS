using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class InvalidDateRange : UsageManagementException
	{
		public InvalidDateRange() : base() { }
		public InvalidDateRange( string message ) : base( message ) { }
		public InvalidDateRange( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
