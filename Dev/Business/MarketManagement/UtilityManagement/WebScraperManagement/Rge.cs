namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	using LibertyPower.Business.CommonBusiness.CommonEntity;

	/// <summary>
	/// This class inherits from UtilityAccount and represents a account from the RGE utility.
	/// Here is the list of properties mapped from UtilityAccount to RGEAccount information:
	/// 
	/// 1. Pod ID          <---> AccountNumber
	/// 2. Mailing Address <---> Address
	/// 3. Profile         <---> LoadProfile
	/// </summary>
	public class Rge : WebAccount
	{
		private string currentRateCategory;
		private string futureRateCategory;
		private string revenueClass;
		private string grid;
		private string taxJurisdiction;
		private string taxDistrict;
		private GeographicalAddress serviceAddress;

		public Rge()
		{
			UtilityCode = "RGE";
		}

		public string CurrentRateCategory
		{
			get { return currentRateCategory; }
			set { currentRateCategory = value; }
		}

		public string FutureRateCategory
		{
			get { return futureRateCategory; }
			set { futureRateCategory = value; }
		}

        public string BillGroup
        {
            get;
            set;
        }
		public string RevenueClass
		{
			get { return revenueClass; }
			set { revenueClass = value; }
		}

		public string Grid
		{
			get { return grid; }
			set { grid = value; }
		}

		public string MeterNumber
		{
			get;
			set;
		}

		public string TaxJurisdiction
		{
			get { return taxJurisdiction; }
			set { taxJurisdiction = value; }
		}

		public string TaxDistrict
		{
			get { return taxDistrict; }
			set { taxDistrict = value; }
		}

		public GeographicalAddress ServiceAddress
		{
			get { return serviceAddress; }
			set { serviceAddress = value; }
		}

	    public string Profile
	    {
            get { return LoadProfile; }
		}

		//public RgeAccountDataExistsRule AccountDataExistsRule
		//{
		//    get;
		//    set;
		//}
	}
}
