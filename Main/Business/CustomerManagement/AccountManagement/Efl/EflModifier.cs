using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class EflModifier
	{
		public EflModifier(decimal rateUsage1, decimal rateUsage2, decimal rateUsage3)
		{
			this.RateUsage1 = rateUsage1;
			this.RateUsage2 = rateUsage2;
			this.RateUsage3 = rateUsage3;
		}
		public decimal RateUsage1
		{
			get;
			set;
		}

		public decimal RateUsage2
		{
			get;
			set;
		}

		public decimal RateUsage3
		{
			get;
			set;
		}
	}
}
