using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Thrown when there are not enough profiles to cover usage
	/// </summary>
	public class InsufficientProfilesException : UsageManagementException
	{
		/// <summary>
		/// Base
		/// </summary>
		public InsufficientProfilesException() : base() { }
		/// <summary>
		/// Message
		/// </summary>
		/// <param name="message"></param>
		public InsufficientProfilesException( string message ) : base( message ) { }
		/// <summary>
		/// Inner exception
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public InsufficientProfilesException( string message, Exception innerException ) : base( message, innerException ) { }
	}
}
