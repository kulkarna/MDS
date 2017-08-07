using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class DailyUsage
	{
		private DateTime dailyDate;
		private decimal dailyUsage;

		public DailyUsage( DateTime date, Decimal kwh )
		{
			this.dailyDate = date;
			this.dailyUsage = kwh;
		}
	
		public DateTime Date
		{
			get
			{
				return dailyDate;
			}
			set
			{
				dailyDate = value;
			}
		}

		public decimal Kwh
		{
			get
			{
				return dailyUsage;
			}
			set
			{
				dailyUsage = value;
			}
		}
	}
}
