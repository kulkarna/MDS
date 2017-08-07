using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	public class Key814NotFoundException : EdiException
	{
		/// <summary>
		/// 
		/// </summary>
		public Key814NotFoundException() : base() { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		public Key814NotFoundException( string message ) : base( message ) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public Key814NotFoundException( string message, Exception innerException ) : base( message, innerException ) { }

	}
}
