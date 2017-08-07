using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class MonthlyUsageAggregate
	{
		private decimal? onPeakKwh;
		private decimal? offPeakKwh;

		public decimal? OnPeakKwh
		{
			get
			{
				return onPeakKwh;
			}
			set
			{
				onPeakKwh = value;
			}
		}

		public decimal? OffPeakKwh
		{
			get
			{
				return offPeakKwh;
			}
			set
			{
				offPeakKwh = value;
			}
		}
	}
}
