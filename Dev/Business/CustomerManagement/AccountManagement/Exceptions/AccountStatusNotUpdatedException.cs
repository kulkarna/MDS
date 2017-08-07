using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// 
	/// </summary>
	public class AccountStatusNotUpdatedException : AccountManagementException
	{
		/// <summary>
		/// 
		/// </summary>
		public AccountStatusNotUpdatedException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public AccountStatusNotUpdatedException(string message) : base(message) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public AccountStatusNotUpdatedException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}