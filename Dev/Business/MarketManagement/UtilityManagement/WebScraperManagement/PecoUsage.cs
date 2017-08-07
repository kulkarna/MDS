namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;

	public class PecoUsage : WebUsage
	{
		/// <summary>
		/// The 30 minute maximum rate of energy used within the start and end dates.
		/// </summary>
		public decimal Demand
		{
			get;
			set;
		}
	}
}
