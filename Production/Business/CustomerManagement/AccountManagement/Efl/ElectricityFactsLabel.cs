using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class ElectricityFactsLabel
	{
		public ElectricityFactsLabel( DateTime dateRate, RateUsageList rateUsages,
			int term, string utilityCode, string utilityShortName )
		{
			this.DateRate = dateRate;
			this.RateUsages = rateUsages;
			this.Term = term;
			this.UtilityCode = utilityCode;
			this.UtilityShortName = utilityShortName;
		}

		public string UtilityShortName
		{
			get;
			set;
		}

		public string UtilityCode
		{
			get;
			set;
		}

		public RateUsageList RateUsages
		{
			get;
			set;
		}

		public int Term
		{
			get;
			set;
		}

		public DateTime DateRate
		{
			get;
			set;
		}
	}
}
