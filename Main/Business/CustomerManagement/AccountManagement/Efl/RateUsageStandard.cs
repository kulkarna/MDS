using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class RateUsageStandard : RateUsage
	{
		public RateUsageStandard( decimal rate, decimal lpFixed, decimal tdspFixed, decimal tdspKwh,
			int averageMonthlyUsage, string utilityShortName )
			: base( rate, lpFixed, tdspFixed, tdspKwh, averageMonthlyUsage, utilityShortName )
		{
			CalculateRateUsage();
		}

		public RateUsageStandard( decimal rate, decimal lpFixed, decimal tdspFixed, decimal tdspKwh,
			int averageMonthlyUsage, string utilityShortName, decimal mcpe, decimal adder, string effectiveMonth )
			: base( rate, lpFixed, tdspFixed, tdspKwh, averageMonthlyUsage, utilityShortName, mcpe, adder, effectiveMonth )
		{
			CalculateRateUsage();
		}

		/// <summary>
		/// Calculation: (Rate + ((LpFixed + TdspFixed) / AverageMonthlyUsage ) + TdspKwh)
		/// </summary>
		protected override void CalculateRateUsage()
		{
			this.RateUsageComputed = (this.Rate + ((this.LpFixed + this.TdspFixed) / Convert.ToDecimal( this.AverageMonthlyUsage )) + this.TdspKwh);
		}
	}
}
