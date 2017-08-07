using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class CommissionTransaction
	{
		public int TransactionDetailId
		{
			get;
			set;
		}

		public decimal RateRequested
		{
			get;
			set;
		}

		public decimal Rate
		{
			get;
			set;
		}

		public decimal VendorPct
		{
			get;
			set;
		}

		public decimal HousePct
		{
			get;
			set;
		}

		public decimal RateSplitPoint
		{
			get;
			set;
		}

		public string AccountId
		{
			get;
			set;
		}

		public string ContractNumber
		{
			get;
			set;
		}

		public string UtilityCode
		{
			get;
			set;
		}

		public string AccountNumber
		{
			get;
			set;
		}

		public DateTime ReportDate
		{
			get;
			set;
		}
	}
}
