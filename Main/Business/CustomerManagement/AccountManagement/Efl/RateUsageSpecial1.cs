using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class RateUsageSpecial1 : RateUsage
	{
		public RateUsageSpecial1( decimal rate, decimal lpFixed, decimal tdspFixed, decimal tdspKwh,
			 decimal tdspKw, decimal tdspModifier, int averageMonthlyUsage, string utilityShortName ) 
			: base( rate, lpFixed, tdspFixed, tdspKwh, averageMonthlyUsage, utilityShortName )
		{
			this.TdspKw = tdspKw;
			this.TdspModifier = tdspModifier;
			CalculateRateUsage();
		}

		public RateUsageSpecial1( decimal rate, decimal lpFixed, decimal tdspFixed, decimal tdspKwh,
			 decimal tdspKw, decimal tdspModifier, int averageMonthlyUsage, string utilityShortName,
			 decimal mcpe, decimal adder, string effectiveMonth)
			: base( rate, lpFixed, tdspFixed, tdspKwh, averageMonthlyUsage, utilityShortName, mcpe, adder, effectiveMonth )
		{
			this.TdspKw = tdspKw;
			this.TdspModifier = tdspModifier;
			CalculateRateUsage();
		}

		/// <summary>
		/// Calculation: (Rate + ((LpFixed + TdspFixed + TdspKw * TdspModifier) / AverageMonthlyUsage) + TdspKwh)
		/// </summary>
		protected override void CalculateRateUsage()
		{
			this.RateUsageComputed = (this.Rate + ((this.LpFixed + this.TdspFixed + this.TdspKw * this.TdspModifier) / Convert.ToDecimal( this.AverageMonthlyUsage )) + this.TdspKwh);
		}
	}
}
