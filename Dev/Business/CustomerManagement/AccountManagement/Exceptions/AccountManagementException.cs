using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// 
	/// </summary>
	public class AccountManagementException : Exception
	{
		/// <summary>
		/// 
		/// </summary>
		public AccountManagementException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public AccountManagementException(string message) : base(message) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public AccountManagementException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}