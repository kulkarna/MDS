namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;

	public class NimoUsage : WebUsage
	{
		public NimoUsage()
		{ }

		public string BillCode
		{
			get;
			set;
		}

		public decimal BilledKwhTotal
		{
			get;
			set;
		}

		public decimal MeteredPeakKw
		{
			get;
			set;
		}

		public decimal MeteredOnPeakKw
		{
			get;
			set;
		}

		public decimal BilledPeakKw
		{
			get;
			set;
		}

		public decimal BilledOnPeakKw
		{
			get;
			set;
		}

		public decimal BillDetailAmt
		{
			get;
			set;
		}

		public decimal BilledRkva
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

		public decimal ShoulderKwh
		{
			get;
			set;
		}

		public decimal OffSeasonKwh
		{
			get;
			set;
		}
	}
}
