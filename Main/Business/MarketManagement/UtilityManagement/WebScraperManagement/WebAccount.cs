namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonEntity;
    // Changes to Bill Group type by ManojTFS-63739 -3/09/15
	public class WebAccount
	{
		private decimal icap;
		private decimal tcap;
		private string billGroup;

		public WebAccount()
		{
			usageList = new WebUsageList();

			icap = -1;
			tcap = -1;
			billGroup = "-1";
		}

		public WebAccount( string utilityCode )
			: this()
		{
			UtilityCode = utilityCode;
		}

		private WebUsageList usageList;

		public string AccountNumber
		{
			get;
			set;
		}

		public string UtilityCode
		{
			get;
			set;
		}

		public string CustomerName
		{
			get;
			set;
		}

		public GeographicalAddress Address
		{
			get;
			set;
		}

		/// <summary>
		/// Represents a customer’s contribution to the grdi’s peak load at the time of highest demand.
		/// </summary>
		public decimal Icap
		{
			get { return icap; }
			set { icap = value; }
		}

		/// <summary>
		/// Account's load profile
		/// </summary>
		public string LoadProfile
		{
			get;
			set;
		}

		/// <summary>
		/// Account's load shape
		/// </summary>
		public string LoadShapeId
		{
			get;
			set;
		}

		public string Cycle
		{
			get;
			set;
		}

		/// <summary>
		/// A strata is an energy load shape used by the ISO's energy forecasting process. Each year the ISO analyzes customer usage and demand and places the customer in the appropriate strata to ensure more accurate forecasts.
		/// </summary>
		public string StratumVariable
		{
			get;
			set;
		}

		/// <summary>
		/// Voltage
		/// </summary>
		public string Voltage
		{
			get;
			set;
		}

		/// <summary>
		/// ISO zone
		/// </summary>
		public string ZoneCode
		{
			get;
			set;
		}

		/// <summary>
		/// Represents a customer’s contribution to the transmission network peak load.
		/// </summary>
		public decimal Tcap
		{
			get { return tcap; }
			set { tcap = value; }
		}

		/// <summary>
		/// Account's tariff rate is (sometimes) associated with the Rate Code
		/// </summary>
		public string RateClass
		{
			get;
			set;
		}

		/// <summary>
		/// List of web-usage
		/// </summary>
		public WebUsageList WebUsageList
		{
			get { return usageList; }
			set { usageList = value; }
		}

		/// <summary>
		/// A number corresponding to the time of the month that the meter is read
		/// </summary>
		public string BillGroup
		{
			get { return billGroup; }
			set { billGroup = value; }
		}

		public BusinessRule AccountDataExistsRule
		{
			get;
			set;
		}
	}
}
