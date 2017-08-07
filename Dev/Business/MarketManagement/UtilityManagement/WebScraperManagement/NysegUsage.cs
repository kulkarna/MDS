namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;

	public class NysegUsage : WebUsage
	{
		public NysegUsage()
		{
			Total = -1;
		}

		public string ReadType
		{
			get;
			set;
		}

		public decimal KwhOn
		{
			get;
			set;
		}

		public decimal KwhOff
		{
			get;
			set;
		}

		public decimal KwOn
		{
			get;
			set;
		}

		public decimal KwOff
		{
			get;
			set;
		}

		public decimal KwhMid
		{
			get;
			set;
		}

		public decimal Total
		{
			get;
			set;
		}

		public decimal TotalTax
		{
			get;
			set;
		}

		public decimal Kw
		{
			get;
			set;
		}

		public decimal Kwh
		{
			get;
			set;
		}

		public decimal Rkvah
		{
			get;
			set;
		}
	}
}
