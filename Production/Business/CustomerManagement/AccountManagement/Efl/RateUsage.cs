using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public abstract class RateUsage
	{
		public RateUsage( decimal rate, decimal lpFixed, decimal tdspFixed, decimal tdspKwh,
			int averageMonthlyUsage, string utilityShortName )
		{
			this.AverageMonthlyUsage = averageMonthlyUsage;
			this.Rate = rate;
			this.LpFixed = lpFixed;
			this.TdspFixed = tdspFixed;
			this.TdspKwh = tdspKwh;
			this.UtilityShortName = utilityShortName;
		}

		public RateUsage( decimal rate, decimal lpFixed, decimal tdspFixed, decimal tdspKwh,
			int averageMonthlyUsage, string utilityShortName, decimal mcpe, decimal adder, string effectiveMonth )
		{
			this.AverageMonthlyUsage = averageMonthlyUsage;
			this.Rate = rate;
			this.LpFixed = lpFixed;
			this.TdspFixed = tdspFixed;
			this.TdspKwh = tdspKwh;
			this.UtilityShortName = utilityShortName;
			this.Mcpe = mcpe;
			this.Adder = adder;
			this.EffectiveMonth = effectiveMonth;
		}

		public string UtilityShortName
		{
			get;
			set;
		}

		public int AverageMonthlyUsage
		{
			get;
			set;
		}

		public decimal Rate
		{
			get;
			set;
		}

		public decimal LpFixed
		{
			get;
			set;
		}

		public decimal TdspFixed
		{
			get;
			set;
		}

		public decimal TdspKwh
		{
			get;
			set;
		}

		public decimal TdspKw
		{
			get;
			set;
		}

		public decimal TdspModifier
		{
			get;
			set;
		}

		public decimal RateUsageComputed
		{
			get;
			set;
		}

		public decimal Mcpe
		{
			get;
			set;
		}

		public decimal Adder
		{
			get;
			set;
		}

		public string EffectiveMonth
		{
			get;
			set;
		}

		protected abstract void CalculateRateUsage();
	}
}
