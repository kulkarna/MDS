using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	class InvalidEflInputException: AccountManagementException
	{
		/// <summary>
		/// 
		/// </summary>
		public InvalidEflInputException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public InvalidEflInputException(string message) : base(message) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public InvalidEflInputException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
