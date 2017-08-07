namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	using LibertyPower.Business.MarketManagement.UtilityManagement;

	/// <summary>
	/// Class for EDI account data
	/// </summary>
	public class EdiAccount
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public EdiAccount() { }

		/// <summary>
		/// Record identifier
		/// </summary>
		public int ID
		{
			get;
			set;
		}

		/// <summary>
		/// EDI file log record identifier
		/// </summary>
		public int EdiFileLogID
		{
			get;
			set;
		}

		/// <summary>
		/// Account number
		/// </summary>
		public string AccountNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Billing account number
		/// </summary>
		public string BillingAccountNumber
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
		/// ICAP
		/// </summary>
		public decimal Icap
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
		/// Load profile
		/// </summary>
		public string LoadProfile
		{
			get;
			set;
		}

		/// <summary>
		/// Bill group
		/// </summary>
		public string BillGroup
		{
			get;
			set;
		}

		/// <summary>
		/// Retail market code
		/// </summary>
		public string RetailMarketCode
		{
			get;
			set;
		}

		/// <summary>
		/// TCAP
		/// </summary>
		public decimal Tcap
		{
			get;
			set;
		}

		/// <summary>
		/// Utility code
		/// </summary>
		public string UtilityCode
		{
			get;
			set;
		}

		/// <summary>
		/// Zone code
		/// </summary>
		public string ZoneCode
		{
			get;
			set;
		}

		/// <summary>
		/// Transaction type
		/// </summary>
		public string TransactionType
		{
			get;
			set;
		}

		/// <summary>
		/// Service type
		/// </summary>
		public string ServiceType
		{
			get;
			set;
		}

		/// <summary>
		/// Product type
		/// </summary>
		public string ProductType
		{
			get;
			set;
		}

		/// <summary>
		/// Product alternate type
		/// </summary>
		public string ProductAltType
		{
			get;
			set;
		}

		/// <summary>
		/// ESP account number
		/// </summary>
		public string EspAccountNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Account status
		/// </summary>
		public string AccountStatus
		{
			get;
			set;
		}

		/// <summary>
		/// Billing type
		/// </summary>
		public string BillingType
		{
			get;
			set;
		}

		/// <summary>
		/// Bill calculation
		/// </summary>
		public string BillCalculation
		{
			get;
			set;
		}

		/// <summary>
		/// Service period start
		/// </summary>
		public DateTime ServicePeriodStart
		{
			get;
			set;
		}

		/// <summary>
		/// Service period end
		/// </summary>
		public DateTime ServicePeriodEnd
		{
			get;
			set;
		}

		/// <summary>
		/// Annual usage
		/// </summary>
		public int AnuualUsage
		{
			get;
			set;
		}

		/// <summary>
		/// Months to compute Kilowatts
		/// </summary>
		public int MonthsToComputeKwh
		{
			get;
			set;
		}

		/// <summary>
		/// Meter type
		/// </summary>
		public string MeterType
		{
			get;
			set;
		}

		/// <summary>
		/// Meter multiplier
		/// </summary>
		public int MeterMultiplier
		{
			get;
			set;
		}

		/// <summary>
		/// Contact name
		/// </summary>
		public string ContactName
		{
			get;
			set;
		}

		/// <summary>
		/// Email address
		/// </summary>
		public string EmailAddress
		{
			get;
			set;
		}

		/// <summary>
		/// Telephone
		/// </summary>
		public string Telephone
		{
			get;
			set;
		}

		/// <summary>
		/// Home phone
		/// </summary>
		public string HomePhone
		{
			get;
			set;
		}

		/// <summary>
		/// Work phone
		/// </summary>
		public string Workphone
		{
			get;
			set;
		}

		/// <summary>
		/// Fax
		/// </summary>
		public string Fax
		{
			get;
			set;
		}

		/// <summary>
		/// Service delivery point
		/// </summary>
		public string ServiceDeliveryPoint
		{
			get;
			set;
		}

		/// <summary>
		/// Meter number
		/// </summary>
		public string MeterNumber
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
		/// Voltage
		/// </summary>
		public string Voltage
		{
			get;
			set;
		}

		/// <summary>
		/// Load shape ID
		/// </summary>
		public string LoadShapeId
		{
			get;
			set;
		}

		/// <summary>
		/// Account type
		/// </summary>
		public string AccountType
		{
			get;
			set;
		}

		private EdiUsageList ediUsageList;

		/// <summary>
		/// EDI usage list for account
		/// </summary>
		public EdiUsageList EdiUsageList
		{
			get
			{
				if( ediUsageList == null )
				{
					ediUsageList = new EdiUsageList();
				}
				return ediUsageList;
			}
			set
			{
				ediUsageList = value;
			}
		}

		/// <summary>
		/// Adds an EDI usage object to EdiUsageList
		/// </summary>
		/// <param name="ediUsage">EDI usage object</param>
		public void AddEdiUsage( EdiUsage ediUsage )
		{
			if( ediUsageList == null )
			{
				ediUsageList = new EdiUsageList();
			}
			ediUsageList.Add( ediUsage );
		}
	}
}
