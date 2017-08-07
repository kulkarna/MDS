using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	class EflDefaultProductNotFoundException: AccountManagementException
	{
		/// <summary>
		/// 
		/// </summary>
		public EflDefaultProductNotFoundException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public EflDefaultProductNotFoundException(string message) : base(message) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public EflDefaultProductNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
