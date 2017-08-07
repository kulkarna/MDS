namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonEntity;

	public class Nyseg : WebAccount
	{

        public Nyseg()
        {
            UtilityCode = "NYSEG";
        }

		public string CurrentRateCategory
		{
			get;
			set;
		}

        public string BillGroup
        {
            get;
            set;
        }

        public string FutureRateCategory
        {
			get;
			set;
		}

        public string RevenueClass
        {
			get;
			set;
		}

        public string Grid
        {
			get;
			set;
		}

        public string TaxJurisdiction
        {
			get;
			set;
		}

        public string TaxDistrict
        {
			get;
			set;
		}

	    public string Profile
	    {
            get { return LoadShapeId; }
		}

        public GeographicalAddress ServiceAddress
        {
			get;
			set;
		}
	}
}
