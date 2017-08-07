namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	public class AmerenUsage : WebUsage
	{
		private decimal offPeakKwh;
		private decimal onPeakKwh;
		private decimal onPeakDemandKw;
		private decimal offPeakDemandKw;
		private decimal peakReactivePowerKvar;

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

		public decimal OnPeakDemandKw
		{
			get { return onPeakDemandKw; }
			set { onPeakDemandKw = value; }
		}

		public decimal OffPeakDemandKw
		{
			get { return offPeakDemandKw; }
			set { offPeakDemandKw = value; }
		}

		public decimal PeakReactivePowerKvar
		{
			get { return peakReactivePowerKvar; }
			set { peakReactivePowerKvar = value; }
		}

		public AmerenUsage()
			: base()
		{ 
			onPeakKwh             = -1;
			offPeakKwh            = -1;
			onPeakDemandKw        = -1;
			offPeakDemandKw       = -1;
			peakReactivePowerKvar = -1;
		}
	}
}
