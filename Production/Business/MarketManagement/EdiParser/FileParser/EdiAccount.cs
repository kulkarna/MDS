namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using CommonBusiness.CommonEntity;

	/// <summary>
	/// Edi account object
	/// </summary>
	public class EdiAccount
	{
		private IcapList icapList;
		private TcapList tcapList;

		/// <summary>
		/// Default constructor
		/// </summary>
		public EdiAccount() { }

		/// <summary>
		/// Constructor that takes all properties of account object.
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="billGroup">Bill group</param>
		/// <param name="billingAccount">Billing account number</param>
		/// <param name="customerName">Customer name</param>
		/// <param name="icap">Icap</param>
		/// <param name="loadProfile">Load profile</param>
		/// <param name="nameKey">Name key</param>
		/// <param name="previousAccountNumber">Previous account number</param>
		/// <param name="rateClass">Rate class</param>
		/// <param name="marketCode">Market identifier</param>
		/// <param name="tcap">Tcap</param>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="zoneCode">Zone code</param>
		public EdiAccount( string accountNumber, string billGroup, string billingAccount, string customerName,
			string icap, string loadProfile, string nameKey, string previousAccountNumber,
			string rateClass, string marketCode, string tcap, string utilityCode, string zoneCode )
		{
			AccountNumber = accountNumber;
            BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1"; ;
			BillingAccount = billingAccount;
			CustomerName = customerName;
			Icap = (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : Convert.ToDecimal( -1 );
			LoadProfile = loadProfile;
			NameKey = nameKey;
			PreviousAccountNumber = previousAccountNumber;
			RateClass = rateClass;
			RetailMarketCode = marketCode;
			Tcap = (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : Convert.ToDecimal( -1 );
			UtilityCode = utilityCode;
			ZoneCode = zoneCode;
			//set default values
			AnnualUsage = -1;
			ServicePeriodStart = DateHelper.DefaultDate;
			ServicePeriodEnd = DateHelper.DefaultDate;
			EffectiveDate = DateHelper.DefaultDate;
			LossFactor = -1;
			MeterMultiplier = -1;
			MonthsToComputeKwh = -1;
			IcapList.Add( new Icap( Icap ) );
			TcapList.Add( new Tcap( Tcap ) );
		}


        public EdiAccount(string accountNumber, string billGroup, string billingAccount, string customerName,
            string icap, string loadProfile, string nameKey, string previousAccountNumber,
            string rateClass, string marketCode, string tcap, string utilityCode, string zoneCode,string daysInArrear)
        {
            AccountNumber = accountNumber;
            BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1"; ;
            BillingAccount = billingAccount;
            CustomerName = customerName;
            Icap = (icap != null && icap.Length > 0) ? Convert.ToDecimal(icap) : Convert.ToDecimal(-1);
            LoadProfile = loadProfile;
            NameKey = nameKey;
            PreviousAccountNumber = previousAccountNumber;
            RateClass = rateClass;
            RetailMarketCode = marketCode;
            Tcap = (tcap != null && tcap.Length > 0) ? Convert.ToDecimal(tcap) : Convert.ToDecimal(-1);
            UtilityCode = utilityCode;
            ZoneCode = zoneCode;
            //set default values
            AnnualUsage = -1;
            ServicePeriodStart = DateHelper.DefaultDate;
            ServicePeriodEnd = DateHelper.DefaultDate;
            EffectiveDate = DateHelper.DefaultDate;
            LossFactor = -1;
            MeterMultiplier = -1;
            MonthsToComputeKwh = -1;
            IcapList.Add(new Icap(Icap));
            TcapList.Add(new Tcap(Tcap));
            this.DaysInArrear = daysInArrear;
        }
		/// <summary>
		/// Account identifier
		/// </summary>
		public string AccountNumber
		{
			get;
			set;
		}

        /// <summary>
        /// Account identifier
        /// </summary>
        public string DaysInArrear
        {
            get;
            set;
        }

        /// <summary>
        /// Account identifier
        /// </summary>
        public DateTime? TransactionCreatedDate
        {
            get;
            set;
        }

        /// <summary>
        /// IcapEffectiveDate identifier
        /// </summary>
        public DateTime IcapEffectiveDate
        {
            get;
            set;
        }
        /// <summary>
        /// FutureIcapEffectiveDate identifier
        /// </summary>
        public DateTime FutureIcapEffectiveDate
        {
            get;
            set;
        }
        /// <summary>
        /// FutureTcapEffectiveDate identifier
        /// </summary>
        public DateTime FutureTcapEffectiveDate
        {
            get;
            set;
        }
        /// <summary>
        /// TcapEffectiveDate identifier
        /// </summary>
        public DateTime TcapEffectiveDate
        {
            get;
            set;
        }
		/// <summary>
		/// Bill group
		/// </summary>
		public dynamic BillGroup
		{
			get;
			set;
		}

		/// <summary>
		/// Billing account number
		/// </summary>
		public string BillingAccount
		{
			get;
			set;
		}

		/// <summary>
		/// Customer name
		/// </summary>
		public string CustomerName
		{
			get;
			set;
		}

		/// <summary>
		/// DUNS number
		/// </summary>
		public string DunsNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Icap
		/// </summary>
		public decimal Icap
		{
			get;
			set;
		}
        /// <summary>
        /// FutureIcap
        /// </summary>
        public decimal FutureIcap
        {
            get;
            set;
        }

        /// <summary>
        /// FutureTcap
        /// </summary>
        public decimal FutureTcap
        {
            get;
            set;
        }
		/// <summary>
		/// Load profile
		/// </summary>
		public string LoadProfile
		{
			get;
			set;
		}

		/// <summary>
		/// Name key
		/// </summary>
		public string NameKey
		{
			get;
			set;
		}

		/// <summary>
		/// Previous account number
		/// </summary>
		public string PreviousAccountNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Rate class
		/// </summary>
		public string RateClass
		{
			get;
			set;
		}

        /// <summary>
        /// Rate class
        /// </summary>
        public string RateClassNH
        {
            get;
            set;
        }

		/// <summary>
		/// Market identifier
		/// </summary>
		public string RetailMarketCode
		{
			get;
			set;
		}

		/// <summary>
		/// Tcap
		/// </summary>
		public decimal Tcap
		{
			get;
			set;
		}

		/// <summary>
		/// Utility identifier
		/// </summary>
		public string UtilityCode
		{
			get;
			set;
		}

		/// <summary>
		/// Utility identifier (for ORNJ)
		/// </summary>
		public string UtilityIdentifier
		{
			get;
			set;
		}

		/// <summary>
		/// Zone identifier
		/// </summary>
		public string ZoneCode
		{
			get;
			set;
		}

		/// <summary>
		/// Edi usage list
		/// </summary>
		public EdiUsageList EdiUsageList
		{
			get;
			set;
		}

		/// <summary>
		/// Account data exists business rule
		/// </summary>
		public AccountDataExistsRule AccountDataExistsRule
		{
			get;
			set;
		}

		/// <summary>
		/// Usage list data exists business rule
		/// </summary>
		public UsageListDataExistsRule UsageListDataExistsRule
		{
			get;
			set;
		}

		/// <summary>
		/// BillingAddress identifier
		/// </summary>
		public GeographicalAddress BillingAddress
		{
			get;
			set;
		}

		/// <summary>
		/// Account's Status (flowing, moved, closed, etc)
		/// </summary>
		public string AccountStatus
		{
			get;
			set;
		}

		/// <summary>
		/// Identifies whether the bill is consolidated by the Utility (LDC), by LP (ESP), or whether each party will render their own bill (DUAL).
		/// </summary>
		public string BillingType
		{
			get;
			set;
		}

		/// <summary>
		/// Identifies the party that is to calculate the charges on the bill (LDC/ESP/DUAL).
		/// </summary>
		public string BillCalculation
		{
			get;
			set;
		}

		/// <summary>
		/// Date that the service with the Service Provider will start.
		/// </summary>
		public DateTime ServicePeriodStart
		{
			get;
			set;
		}

		/// <summary>
		/// Date that the service with the Service Provider will end.
		/// </summary>
		public DateTime ServicePeriodEnd
		{
			get;
			set;
		}

		/// <summary>
		/// Date that dictates when a certain identifier is valid from
		/// </summary>
		public DateTime EffectiveDate { get; set; }

		/// <summary>
		/// Annual Usage (Total Kwh)
		/// </summary>
		public int AnnualUsage
		{
			get;
			set;
		}

		/// <summary>
		/// Number of months over which Total kWh are calculated.
		/// </summary>
		public short MonthsToComputeKwh
		{
			get;
			set;
		}

		/// <summary>
		/// Meter type used to identify the type of consumption measured by this meter and the interval between measurements
		/// </summary>
		public string MeterType
		{
			get;
			set;
		}

		/// <summary>
		/// Meter constant or meter multiplier. Billed Usage = (Ending Meter Reading - Beginning Meter Reading) * Meter Multiplier
		/// </summary>
		public short MeterMultiplier
		{
			get;
			set;
		}

		/// <summary>
		/// Beginning Segment: 06-Confirmation; 11-Response; 13-Request; etc.
		/// </summary>
		public string TransactionType
		{
			get;
			set;
		}

		/// <summary>
		/// Electric Service (EL), Gas Service (GAS), Water Service (WA), etc.
		/// </summary>
		public string ServiceType
		{
			get;
			set;
		}

		/// <summary>
		/// Customer Enrollment (CE), Historical Usage (HU), Historical Interval (HI), etc.
		/// </summary>
		public string ProductType
		{
			get;
			set;
		}

		/// <summary>
		/// Electronic Credit (EC), Special Meter Read (SR), etc.
		/// </summary>
		public string ProductAltType
		{
			get;
			set;
		}

		/// <summary>
		/// Service Address
		/// </summary>
		public GeographicalAddress ServiceAddress
		{
			get;
			set;
		}

		/// <summary>
		/// Bill To Customer (Contact) Name
		/// </summary>
		public string BillTo
		{
			get;
			set;
		}

		/// <summary>
		/// Contact information 
		/// </summary>
		public EdiAccountContact Contact
		{
			get;
			set;
		}

		/// <summary>
		/// Meter Number
		/// </summary>
		public string NetMeterType { get; set; }

		/// <summary>
		/// Meter Number
		/// </summary>
		public string MeterNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Change Meter Attributes - this code is used to change the meter attributes, including Number of Dials, Meter Constant, Type of Metering, Meter Role and Special Meter Configuration.
		/// </summary>
		public string MeterAttributes { get; set; }

		/// <summary>
		/// Esp Account Number
		/// </summary>
		public string EspAccount
		{
			get;
			set;
		}

		/// <summary>
		/// Voltage description
		/// </summary>
		public string Voltage
		{
			get;
			set;
		}

		/// <summary>
		/// Loss factor
		/// </summary>
		public decimal LossFactor
		{
			get;
			set;
		}

		/// <summary>
		/// Idr Usage List
		/// </summary>
		public Dictionary<string, EdiIdrUsage> IdrUsageList
		{
			get;
			set;
		}

		/// <summary>
		/// Service delivery point, also called Location number in MISO
		/// </summary>
		public string ServiceDeliveryPoint
		{
			get;
			set;
		}

		public IcapList IcapList
		{
			get
			{
				return icapList ?? new IcapList();
			}
			set
			{
				icapList = value;
			}
		}

		public TcapList TcapList
		{
			get
			{
				return tcapList ?? new TcapList();
			}
			set
			{
				tcapList = value;
			}
		}

		public bool HasIcap
		{
			get
			{
				return Icap > -1;
			}
		}

		public bool HasTcap
		{
			get
			{
				return Tcap > -1;
			}
		}
	}
}
