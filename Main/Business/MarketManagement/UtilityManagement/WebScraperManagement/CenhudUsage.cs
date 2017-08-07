namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public class CenhudUsage : WebUsage
	{
		public CenhudUsage()
		{
			numberOfMonths = -1;
			onPeakKwh = -1;
			offPeakKwh = -1;
			demandKw = -1;
			totalBilledAmount = -1;
			salesTax = -1;
		}

		private string  readCode;
		private decimal numberOfMonths;
		private decimal onPeakKwh;
		private decimal offPeakKwh;
		private decimal demandKw;
		private decimal totalBilledAmount;
		private decimal salesTax;

		public string ReadCode
		{
			get { return readCode; }
			set { readCode = value; }
		}

		public decimal NumberOfMonths
		{
			get { return numberOfMonths; }
			set { numberOfMonths = value; }
		}

		public decimal OnPeakKwh
		{
			get { return onPeakKwh; }
			set { onPeakKwh = value; }
		}

		public decimal OffPeakKwh
		{
			get { return offPeakKwh; }
			set { offPeakKwh = value; }
		}

		public decimal DemandKw
		{
			get { return demandKw; }
			set { demandKw = value; }
		}

		public decimal TotalBilledAmount
		{
			get { return totalBilledAmount; }
			set { totalBilledAmount = value; }
		}

		public decimal SalesTax
		{
			get { return salesTax; }
			set { salesTax = value; }
		}
	}
}
