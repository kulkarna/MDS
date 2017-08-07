using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public interface IUsageBase
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

	}
}
