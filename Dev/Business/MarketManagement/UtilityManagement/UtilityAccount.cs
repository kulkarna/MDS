using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonEntity;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Container for utility account data.
	/// </summary>
	/// 
	[Serializable]
	public class UtilityAccount
	{
		private long? id;
		private string accountNumber;
		private string billingAccount;
		private string customerName;
		private string retailMarketCode;
		private string utilityCode;
		private string zoneCode;
		private GeographicalAddress serviceAddress;
		private GeographicalAddress billingAddress;
		private MeterList meters;
		private dynamic billGroup;
		private string supplyGroup;
		private string loadProfile;
		private string loadShapeId;
		private string voltage;
		private string rateClass;
		private string rateCode;
		private string stratumVariable;
		private decimal? icap;
		private decimal? tcap;
		private decimal? lossFactor;
		private string nameKey;
		private string meterReadCycleId;
        private string lossFactorID;

		private int? deliveryLocationRefId;
		private int? loadProfileRefId;
		private int? serviceClassRefId;

		#region added for CA support (PGE, SCE, SDGE)

		private string energyServiceProvider;
		private string meterInstaller;
		private string meterMaintainer;
		private string meterOwner;
		private string meterReader;
		private string meterOption;
		private string cycle;

		#endregion


		private UsageDictionary usageDictionary;
		private UtilityAccountRuleException exception;

		/// <summary>
		/// Internal constructor.
		/// </summary>	
		internal UtilityAccount( long id, string accountNumber, string utilityCode, GeographicalAddress serviceAddress )
		{
			this.id = (long?) id;
			this.accountNumber = accountNumber;
			this.utilityCode = utilityCode;
			this.serviceAddress = serviceAddress;
		}

		/// <summary>
		/// Supports inheritance by UtilityAccountStarter in MarketParsing
		/// </summary>
		protected UtilityAccount()
		{
		}

		/// <summary>
		/// Public constructor.
		/// </summary>	
		public UtilityAccount( string accountNumber )
		{
			this.accountNumber = accountNumber;
		}

		/// <summary>
		/// Public constructor.
		/// </summary>	
		public UtilityAccount( string accountNumber, string utilityCode )
		{
			this.accountNumber = accountNumber;
			this.utilityCode = utilityCode;
		}

		/// <summary>
		/// Public constructor.
		/// </summary>	
		public UtilityAccount( long id, string accountNumber, string utilityCode )
		{
			this.id = id;
			this.accountNumber = accountNumber;
			this.utilityCode = utilityCode;
		}


		/// <summary>
		/// Creates a shallow copy of the current instance
		/// </summary>
		/// <returns></returns>
		public UtilityAccount Clone()
		{
			return (UtilityAccount) this.MemberwiseClone();
		}

		/// <summary>
		/// Unique identifier from database.
		/// </summary>
		public long? ID
		{
			get { return this.id; }
			set { this.id = value; }
		}

		/// <summary>
		/// Account number.
		/// </summary>
		public string AccountNumber
		{
			get { return this.accountNumber; }

			set
			{
				//added to support the empty constructor
				if( this.accountNumber == null )
					this.accountNumber = value;
			}
		}

        /// <summary>
        /// LossFactorID.
        /// </summary>
        public string LossFactorID
        {
            get { return this.lossFactorID; }

            set
            {
                //added to support the empty constructor
                if (this.lossFactorID == null)
                    this.lossFactorID = value;
            }
        }
		/// <summary>
		/// Billing Account Number
		/// </summary>
		public string BillingAccount
		{
			get { return this.billingAccount; }
			set { this.billingAccount = value; }
		}

		/// <summary>
		/// Customer name.
		/// </summary>
		public string CustomerName
		{
			get { return this.customerName; }
			set { this.customerName = value; }
		}

		/// <summary>
		/// Retail market ( state ).
		/// </summary>
		public string RetailMarketCode
		{
			get { return this.retailMarketCode; }
			set { this.retailMarketCode = value; }
		}

		/// <summary>
		/// Unique identifier for utility.
		/// </summary>
		public string UtilityCode
		{
			get { return this.utilityCode; }
			set { this.utilityCode = value; }
		}

		/// <summary>
		/// Utility zone.
		/// </summary>
		public string ZoneCode
		{
			get { return this.zoneCode; }
			set { this.zoneCode = value; }
		}

		/// <summary>
		/// Account service address.
		/// </summary>
		public GeographicalAddress ServiceAddress
		{
			get { return this.serviceAddress; }
			set { this.serviceAddress = value; }
		}

		/// <summary>
		/// Account billing  address.
		/// </summary>
		public GeographicalAddress BillingAddress
		{
			get { return this.billingAddress; }
			set { this.billingAddress = value; }
		}

		/// <summary>
		/// List of meter numbers.
		/// </summary>
		public MeterList Meters
		{
			get { return this.meters; }
			set { this.meters = value; }
		}

		/// <summary>
		/// Bill group.
		/// </summary>
		public dynamic BillGroup
		{
			get { return this.billGroup; }
			set { this.billGroup = value; }
		}

		/// <summary>
		/// Supply group.
		/// </summary>
		public string SupplyGroup
		{
			get { return this.supplyGroup; }
			set { this.supplyGroup = value; }
		}

		/// <summary>
		/// Load profile.
		/// </summary>
		public string LoadProfile
		{
			get { return this.loadProfile; }
			set { this.loadProfile = value; }
		}

		/// <summary>
		/// delivery point.
		/// </summary>
		public int? DeliveryLocationRefID
		{
			get { return this.deliveryLocationRefId; }
			set { this.deliveryLocationRefId = value; }
		}

		/// <summary>
		/// Load profile.
		/// </summary>
		public int? LoadProfileRefID
		{
			get { return this.loadProfileRefId; }
			set { this.loadProfileRefId = value; }
		}

		public int? ServiceClassRefID
		{
			get { return this.serviceClassRefId; }
			set { this.serviceClassRefId = value; }
		}
		/// <summary>
		/// Load shape ID.
		/// </summary>
		public string LoadShapeId
		{
			get { return this.loadShapeId; }
			set { this.loadShapeId = value; }
		}

		/// <summary>
		/// Voltage type.
		/// </summary>
		public string Voltage
		{
			get { return this.voltage; }
			set { this.voltage = value; }
		}

		/// <summary>
		/// Rate class.
		/// </summary>
		public string RateClass
		{
			get { return this.rateClass; }
			set { this.rateClass = value; }
		}

		/// <summary>
		/// Rate code.
		/// </summary>
		public string RateCode
		{
			get { return this.rateCode; }
			set { this.rateCode = value; }
		}

		/// <summary>
		/// Stratum variable.
		/// </summary>
		public string StratumVariable
		{
			get { return this.stratumVariable; }
			set { this.stratumVariable = value; }
		}

		/// <summary>
		/// Installed capacity.
		/// </summary>
		public decimal? Icap
		{
			get { return this.icap; }
			set { this.icap = value; }
		}

		/// <summary>
		/// Transmission capacity.
		/// </summary>
		public decimal? Tcap
		{
			get { return this.tcap; }
			set { this.tcap = value; }
		}

		/// <summary>
		/// Loss factor.
		/// </summary>
		public decimal? LossFactor
		{
			get { return this.lossFactor; }
			set { this.lossFactor = value; }
		}

		/// <summary>
		/// Utility specific name key.
		/// </summary>
		public string NameKey
		{
			get { return this.nameKey; }
			set { this.nameKey = value; }
		}

		/// <summary>
		/// Meter read cycle identifier.
		/// </summary>
		/// <remarks>The utility associates accounts to a cycle identifier
		/// that, based on a predetermined meter read schedule, defines
		/// specific calendar dates in which the meter read for the account
		/// will be or was read.</remarks>
		public string MeterReadCycleId
		{
			get { return this.meterReadCycleId; }
			set { this.meterReadCycleId = value; }
		}

		#region Added to support CA (PGE, SCE, SDGE)

		/// <summary>
		/// Gets or sets the energy service provider.
		/// </summary>
		/// <value>The energy service provider.</value>
		public string EnergyServiceProvider
		{
			get { return energyServiceProvider; }

			set
			{
				if( energyServiceProvider == null || energyServiceProvider.Trim().Length == 0 )
					energyServiceProvider = value;
			}
		}

		/// <summary>
		/// Gets or sets the meter installer.
		/// </summary>
		/// <value>The meter installer.</value>
		public string MeterInstaller
		{
			get { return meterInstaller; }

			set
			{
				if( meterInstaller == null || meterInstaller.Trim().Length == 0 )
					meterInstaller = value;
			}
		}

		/// <summary>
		/// Gets or sets the meter maintainer.
		/// </summary>
		/// <value>The meter maintainer.</value>
		public string MeterMaintainer
		{
			get { return meterMaintainer; }

			set
			{
				if( meterMaintainer == null || meterMaintainer.Trim().Length == 0 )
					meterMaintainer = value;
			}
		}

		/// <summary>
		/// Gets or sets the meter owner.
		/// </summary>
		/// <value>The meter owner.</value>
		public string MeterOwner
		{
			get { return meterOwner; }

			set
			{
				if( meterOwner == null || meterOwner.Trim().Length == 0 )
					meterOwner = value;

			}
		}

		/// <summary>
		/// Gets or sets the meter reader.
		/// </summary>
		/// <value>The meter reader.</value>
		public string MeterReader
		{
			get { return meterReader; }

			set
			{
				if( meterReader == null || meterReader.Trim().Length == 0 )
					meterReader = value;

			}
		}

		/// <summary>
		/// Gets or sets the meter option.
		/// </summary>
		/// <value>The meter option.</value>
		public string MeterOption
		{
			get { return meterOption; }

			set
			{
				if( meterOption == null || meterOption.Trim().Length == 0 )
					meterOption = value;

			}
		}

		/// <summary>
		/// Gets or sets the cycle.
		/// </summary>
		/// <value>The cycle.</value>
		public string Cycle
		{
			get { return cycle; }

			set
			{
				if( cycle == null || cycle.Trim().Length == 0 )
					cycle = value;

			}
		}

		#endregion //CA support
		/// <summary>
		/// Service class string
		/// </summary>
		public string ServiceClass
		{
			get;
			set;
		}

		/// <summary>
		/// Grid string
		/// </summary>
		public string Grid
		{
			get;
			set;
		}

		/// <summary>
		/// LBMP zone string
		/// </summary>
		public string LBMPZone
		{
			get;
			set;
		}

		/// <summary>
		/// Tariff code
		/// </summary>
		public string TariffCode
		{
			get;
			set;
		}

		/// <summary>
		/// Account type string
		/// </summary>
		public string AccountType
		{
			get;
			set;
		}

		/// <summary>
		/// Usage dictionary
		/// </summary>
		public UsageDictionary Usages
		{
			get
			{
				if( usageDictionary == null )
					usageDictionary = new UsageDictionary();
				return this.usageDictionary;
			}
			set
			{
				this.usageDictionary = value;
			}
		}

		/// <summary>
		/// Utility class and utility zone mapping collections
		/// </summary>
		public UtilityMapping UtilityMapping
		{
			get;
			set;
		}

		/// <summary>
		/// Utility account rule exception
		/// </summary>
		public UtilityAccountRuleException Exception
		{
			get { return this.exception; }
			set { this.exception = value; }
		}

		/// <summary>
		/// Adds a meter to the meter collection
		/// </summary>
		/// <param name="meterNumber">Meter number</param>
		/// <param name="meterType">Meter type object</param>
		/// <returns>Returns a meter type object</returns>
		public Meter AddMeter( string meterNumber, MeterType meterType )
		{
			Meter meter = new Meter( meterNumber, meterType );

			if( this.meters == null )
			{
				this.meters = new MeterList();
			}
			this.meters.Add( meter );

			return meter;
		}

		/// <summary>
		/// Adds a usage object to the usage collection
		/// </summary>
		/// <param name="usage">Usage object</param>
		public void AddUsage( Usage usage )
		{
			if( usageDictionary == null )
				usageDictionary = new UsageDictionary();
			usageDictionary.Add( usage.BeginDate, usage );
		}

		/// <summary>
		/// Overrides ToString() to provide better information in watch window
		/// </summary>
		/// <returns></returns>
		public override string ToString()
		{
			return string.Format( "{0},{1}", accountNumber ?? "accountNumber not set", utilityCode ?? "utilityCode not set" );
		}
	}
}
