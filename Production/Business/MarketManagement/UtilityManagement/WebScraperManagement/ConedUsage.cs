namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;

	public class ConedUsage : WebUsage
	{
		private decimal billAmount;
		private decimal demand;

		public ConedUsage()
		{
		}

		/// <summary>
		/// Bill amount / current charges
		/// </summary>
		public decimal BillAmount
		{
			get { return billAmount; }
			set { billAmount = value; }
		}

		/// <summary>
		/// ICap for the period (in KW)
		/// </summary>
		public decimal Demand
		{
			get { return demand; }
			set { demand = value; }
		}

		/// <summary>
		/// Usage data exists business rule
		/// </summary>
        //public ConedUsageDataExistsRule UsageDataExistsRule
        //{
        //    get;
        //    set;
        //}
	}
}
