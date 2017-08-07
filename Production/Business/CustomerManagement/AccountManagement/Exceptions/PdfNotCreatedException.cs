using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class PdfNotCreatedException : AccountManagementException
	{
		/// <summary>
		/// 
		/// </summary>
		public PdfNotCreatedException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public PdfNotCreatedException(string message) : base(message) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public PdfNotCreatedException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
