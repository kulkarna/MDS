using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	public class Ista814ServiceAccountChange
	{
		public string ChangeReason
		{
			get;
			set;
		}

		public string ChangeDescription
		{
			get;
			set;
		}

		public int ServiceKey
		{
			get;
			set;
		}
	}
}
