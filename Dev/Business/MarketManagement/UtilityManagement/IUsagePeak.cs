using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public interface IUsagePeak
	{
		DateTime BeginDate
		{
			get;
			set;
		}

		DateTime EndDate
		{
			get;
			set;
		}

		int TotalKwh
		{
			get;
			set;
		}

		decimal? OffPeakKwh
		{
			get;
			set;
		}

		decimal? OnPeakKwh
		{
			get;
			set;
		}
	}
}
