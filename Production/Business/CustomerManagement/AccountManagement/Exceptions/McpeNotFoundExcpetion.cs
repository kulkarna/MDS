using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class McpeNotFoundExcpetion : AccountManagementException
	{
		/// <summary>
		/// 
		/// </summary>
		public McpeNotFoundExcpetion() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public McpeNotFoundExcpetion(string message) : base(message) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public McpeNotFoundExcpetion( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
