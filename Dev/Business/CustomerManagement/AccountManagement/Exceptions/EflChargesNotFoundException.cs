using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class EflChargesNotFoundException: AccountManagementException
	{
		/// <summary>
		/// 
		/// </summary>
		public EflChargesNotFoundException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public EflChargesNotFoundException(string message) : base(message) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public EflChargesNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
