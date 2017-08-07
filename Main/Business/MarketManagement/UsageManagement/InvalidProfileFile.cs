using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	class InvalidProfileFile : UsageManagementException
	{
		public InvalidProfileFile() : base() { }
		public InvalidProfileFile(string message) : base(message) { }
		public InvalidProfileFile( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
