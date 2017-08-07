using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	/// <summary>
	/// Base exception for Edi Management, inherits from Exception
	/// </summary>
	public class EdiException : Exception
	{
		/// <summary>
		/// 
		/// </summary>
		public EdiException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public EdiException( string message ) : base( message ) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public EdiException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
