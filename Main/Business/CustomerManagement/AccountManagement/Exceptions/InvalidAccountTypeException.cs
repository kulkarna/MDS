using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	class InvalidAccountTypeException : AccountManagementException
	{
		/// <summary>
		/// 
		/// </summary>
		public InvalidAccountTypeException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public InvalidAccountTypeException(string message) : base(message) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public InvalidAccountTypeException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
