namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

	/// <summary>
	/// Pricing mode enum
	/// </summary>
	public enum PricingMode
	{
		/// <summary>
		/// Utility
		/// </summary>
		Utility = 1,
		/// <summary>
		/// Utility, zone
		/// </summary>
		Utility_Zone = 2,
		/// <summary>
		/// Utility, zone, service class
		/// </summary>
		Utility_Zone_ServiceClass = 3
	}
}
