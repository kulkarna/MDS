using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class PeakProfileNotFoundException : UsageManagementException
	{
		public PeakProfileNotFoundException() : base() { }
		public PeakProfileNotFoundException( string message ) : base( message ) { }
		public PeakProfileNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
