using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// 
	/// </summary>
	public class ContractNotFoundException : AccountManagementException
	{
		/// <summary>
		/// 
		/// </summary>
		public ContractNotFoundException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public ContractNotFoundException(string message) : base(message) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public ContractNotFoundException( string message, Exception innerException ) : base( message, innerException ) { }

	}
}
