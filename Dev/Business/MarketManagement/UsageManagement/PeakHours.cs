using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class PeakHours
	{
		private int onPeakHours;
		private int offPeakHours;
		private int month;
		private int year;

		public int OnPeakHours
		{
			get{return onPeakHours;}
			set{onPeakHours = value;}
		}

		public int OffPeakHours
		{
			get{return offPeakHours;}
			set{offPeakHours = value;}
		}

		public int Month
		{
			get{return month;}
			set{month = value;}
		}

		public int Year
		{
			get{return year;}
			set{year = value;}
		}
	}
}
