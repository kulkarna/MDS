namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	public class Comed : WebAccount
	{
		public Comed()
		{
			UtilityCode = "COMED";
		}

        public string MeterBillGroupType
        {
            get { return BillGroup;  }
        }
	    public string Rate
	    {
            get { return RateClass; }   
		}

		public List<ComedPLCMeter> CapacityPLC
		{
			get;
			set;
		}

		public List<ComedPLCMeter> NetworkServicePLC
		{
			get;
			set;
		}

		public DateTime MinimumStayDate
		{
			get;
			set;
		}

		public string CondoException
		{
			get;
			set;
		}

		public SupplyGroup CurrentSupplyGroup
		{
			get;
			set;
		}

		public SupplyGroup PendingSupplyGroup
		{
			get;
			set;
		}

		public class SupplyGroup
		{
			public string Name
			{
				get;
				set;
			}

			public DateTime EffectiveStartDate
			{
				get;
				set;
			}
		}

		public class ComedPLCMeter
		{
			public decimal Value
			{
				get;
				set;
			}

			public DateTime StartDate
			{
				get;
				set;
			}

			public DateTime EndDate
			{
				get;
				set;
			}
		}
	}
}
