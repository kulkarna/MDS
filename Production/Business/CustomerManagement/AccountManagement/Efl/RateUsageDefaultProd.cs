using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class RateUsageDefaultProd : RateUsage
	{
		public RateUsageDefaultProd( string utilityShortName, decimal lpFixed, decimal mcpe, decimal adder, decimal tdspFixed, decimal tdspKwh,
			decimal tdspKw, decimal tdspModifier, int averageMonthlyUsage, string effectiveMonth )
			: base( 0m, lpFixed, tdspFixed, tdspKwh, averageMonthlyUsage, utilityShortName, mcpe, adder, effectiveMonth )
		{
			this.TdspKw = tdspKw;
			this.TdspModifier = tdspModifier;
			CalculateRateUsage();
		}


		/// <summary>
		/// Calculation: (Mcpe + Adder + (TdspFixed / AverageMonthlyUsage) + TdspKwh);
		/// </summary>
		protected override void CalculateRateUsage()
		{
			this.RateUsageComputed = (this.Mcpe + this.Adder + ((this.LpFixed + this.TdspFixed + this.TdspKw * this.TdspModifier) / Convert.ToDecimal( this.AverageMonthlyUsage )) + this.TdspKwh);
		}
	}
}
