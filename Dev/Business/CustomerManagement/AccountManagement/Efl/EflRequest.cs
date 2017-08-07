using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class EflRequest
	{
		public EflRequest( string utilityCode, int term, decimal rate, 
			decimal lpFixed, string accountType, string productId )
		{
			this.AccountType = accountType;
			this.LpFixed = lpFixed;
			this.ProductId = productId;
			this.Rate = rate;
			this.Term = term;
			this.UtilityCode = utilityCode;
		}

		public EflRequest( string utilityCode, int term, decimal rate,
			decimal lpFixed, string accountType, string productId, string process )
		{
			this.AccountType = accountType;
			this.LpFixed = lpFixed;
			this.ProductId = productId;
			this.Rate = rate;
			this.Term = term;
			this.UtilityCode = utilityCode;
			this.Process = process;
		}

		public string UtilityCode
		{
			get;
			set;
		}

		public string ProductId
		{
			get;
			set;
		}

		public int Term
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

		public string AccountType
		{
			get;
			set;
		}

		public string Process
		{
			get;
			set;
		}
	}
}
