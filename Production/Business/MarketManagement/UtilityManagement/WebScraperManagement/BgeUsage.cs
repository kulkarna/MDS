namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public class BgeUsage : WebUsage
	{
		public BgeUsage()
		{
		}

		public string MeterType
		{
			get;
			set;
		}

		public string ReadingSource
		{
			get;
			set;
		}

		public decimal OnPeakKwh
		{
			get;
			set;
		}

		public decimal OffPeakKwh
		{
			get;
			set;
		}

		public string SeasonalCrossover
		{
			get;
			set;
		}

		public decimal DeliveryDemandKw
		{
			get;
			set;
		}

		public decimal GenTransDemandKw
		{
			get;
			set;
		}

		public decimal IntermediatePeakKwh
		{
			get;
			set;
		}

		public decimal UsageFactorNonTOU
		{
			get;
			set;
		}

		public decimal UsageFactorOnPeak
		{
			get;
			set;
		}

		public decimal UsageFactorIntermediate
		{
			get;
			set;
		}

		public decimal UsageFactorOffPeak
		{
			get;
			set;
		}
	}
}
