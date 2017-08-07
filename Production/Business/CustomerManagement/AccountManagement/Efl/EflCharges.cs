using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class EflCharges
	{
		public string UtilityCode
		{
			get;
			set;
		}

		public string AccountType
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
		public decimal TdspFixedAbove
		{
			get;
			set;
		}

		public decimal TdspKwhAbove
		{
			get;
			set;
		}
		public decimal TdspKw
		{
			get;
			set;
		}
	}
}
