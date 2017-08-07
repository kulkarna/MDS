namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	public class Cenhud : WebAccount
	{
		public Cenhud()
			: base( "CENHUD" )
		{
			usageFactor = -1;
			salesTaxRate = -1;
		}

		private string  billFrequency;
		private string  rateCode;
		private string  loadZone;
		private decimal usageFactor;
		private decimal salesTaxRate;

		public string County
		{
			get;
			set;
		}
	    
        public string BillCycle
	    {
	        get { return Cycle; }
		}

		public string BillFrequency
		{
			get { return billFrequency; }
			set { billFrequency = value; }
		}

		public string RateCode
		{
			get { return rateCode; }
			set { rateCode = value; }
		}

		public string LoadZone
		{
			get { return loadZone; }
			set { loadZone = value; }
		}

		public decimal UsageFactor
		{
			get { return usageFactor; }
			set { usageFactor = value; }
		}

		public decimal SalesTaxRate
		{
			get { return salesTaxRate; }
			set { salesTaxRate = value; }
		}

        public string Municipality
		{
            get; 
            set;
		}

		public DateTime? NextScheduledMeterRead
		{
			get;
			set;
		}

	}
}
