using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	class EflAvgMonthluUsageNotFoundException: AccountManagementException
	{
		/// <summary>
		/// 
		/// </summary>
		public EflAvgMonthluUsageNotFoundException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public EflAvgMonthluUsageNotFoundException(string message) : base(message) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public EflAvgMonthluUsageNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
