namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// This class inherits from Usage and represents a usage from the RGE utility.
	/// Here is the list of properties mapped from Usage to RGEUsage information:
	/// 
	/// 1. Read Date <---> BeginDate
	/// 2. Kwh On    <---> OnPeakKwh
	/// 3. Kwh Off   <---> OffPeakKwh
	/// </summary>
	public class RgeUsage : WebUsage
	{
		private string  readType;
		private decimal kwhOn;
		private decimal kwhOff;
		private decimal kwOn;
		private decimal kw;
		private decimal kwh;
		private decimal kwOff;
		private decimal kwhMid;
		private decimal rkvah;
		private decimal total;
		private decimal totalTax;

		public string ReadType
		{
			get { return readType; }
			set { readType = value; }
		}

		public decimal KwhOn
		{
			get { return kwhOn; }
			set { kwhOn = value; }
		}

		public decimal KwhOff
		{
			get { return kwhOff; }
			set { kwhOff = value; }
		}

		public decimal KwOn
		{
			get { return kwOn; }
			set { kwOn = value; }
		}

		public decimal KwOff
		{
			get { return kwOff; }
			set { kwOff = value; }
		}

		public decimal KwhMid
		{
			get { return kwhMid; }
			set { kwhMid = value; }
		}

		public decimal Total
		{
			get { return total; }
			set { total = value; }
		}

		public decimal TotalTax
		{
			get { return totalTax; }
			set { totalTax = value; }
		}

		public decimal Kwh
		{
			get { return kwh; }
			set { kwh = value; }
		}

		public decimal Kw
		{
			get { return kw; }
			set { kw = value; }
		}

		public decimal Rkvah
		{
			get { return rkvah; }
			set { rkvah = value; }
		}

	}
}
