using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// Enumeration of the possible types of addressess
	/// </summary>
	public enum AddressType
	{
		/// <summary>
		/// Billing address of an edi account
		/// </summary>
		BillingAddress = 1,
		/// <summary>
		/// Service address of an edi account
		/// </summary>
		ServiceAddress = 2,
	}
}
