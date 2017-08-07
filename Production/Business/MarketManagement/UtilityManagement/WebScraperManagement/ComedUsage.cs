namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	public class ComedUsage : WebUsage
	{
		public string Rate
		{
			get;
			set;
		}

		public decimal OnPeakKwh
		{
			get;
			set;
		}

		public decimal OffPeakKwh
		{
			get;
			set;
		}

		public decimal BillingDemandKw
		{
			get;
			set;
		}

		public decimal MonthlyPeakDemandKw
		{
			get;
			set;
		}
	}
}
