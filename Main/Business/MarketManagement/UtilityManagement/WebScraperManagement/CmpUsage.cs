namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public class CmpUsage : WebUsage
	{
		private decimal highestDemandKw;

		public CmpUsage()
		{
			highestDemandKw = -1;
		}

		public decimal HighestDemandKw
		{
			get { return highestDemandKw; }
			set { highestDemandKw = value; }
		}

		public string RateCode
		{
			get;
			set;
		}

		public int TotalUnmeteredServices
		{
			get;
			set;
		}

		public int TotalActiveUnmeteredServices
		{
			get;
			set;
		}
	}
}
