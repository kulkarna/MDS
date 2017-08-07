using System;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// 
	/// </summary>
	[Serializable]
	public class Usage : IUsageBase, IUsagePeak
	{
		private long? id;
		protected string accountNumber;
		protected string utilityCode;
		protected UsageSource usageSource;
		protected UsageType usageType;
		protected DateTime beginDate;
		protected DateTime endDate;
		protected int days;
		protected int totalKwh;
		protected decimal? billingDemandKw;
		protected decimal? offPeakKwh;
		protected decimal? onPeakKwh;
		protected DateTime? dateCreated;
		protected string createdBy;
		protected DateTime? dateModified;
		protected string modifiedBy;
		protected decimal? monthlyPeakDemandKw;
		protected bool isConsolidated;
		protected Int16 isAcive;
		protected ReasonCode reasonCode;

		#region added for CA Support

		private decimal? intermediateKwh;
		private decimal? monthlyOffPeakDemandKw;

		#endregion //added for CA support
		public Usage Clone()
		{
			return (Usage) this.MemberwiseClone();
		}

		public override string ToString()
		{
			try
			{
				var description = string.Format( "Usage from {0} to {1}: {2}", beginDate.ToShortDateString(), endDate.ToShortDateString(), TotalKwh );
				return description;
			}
			catch { }

			return base.ToString();
		}

		public Usage()
		{
			beginDate = DateTime.MinValue;
			endDate = DateTime.MinValue;
		}

		public Usage( long? id )
		{
			this.id = (long?) id;
			beginDate = DateTime.MinValue;
			endDate = DateTime.MinValue;
		}

		public Usage( string accountNumber, string utilityCode, UsageSource usageSource, UsageType usageType, DateTime beginDate, DateTime endDate )
		{
			this.accountNumber = accountNumber;
			this.utilityCode = utilityCode;
			this.usageSource = usageSource;
			this.usageType = usageType;
			this.beginDate = beginDate;
			this.endDate = endDate;
		}

		public Usage( string accountNumber, string utilityCode, UsageSource usageSource, UsageType usageType, DateTime beginDate, DateTime endDate, int totalKwh )
		{
			this.accountNumber = accountNumber;
			this.utilityCode = utilityCode;
			this.usageSource = usageSource;
			this.usageType = usageType;
			this.beginDate = beginDate;
			this.endDate = endDate;
			this.totalKwh = totalKwh;
		}

		public string AccountNumber
		{
			get { return this.accountNumber; }
			set { this.accountNumber = value; }
		}

		public string UtilityCode
		{
			get { return this.utilityCode; }
			set { this.utilityCode = value; }
		}

		public string ISO
		{
			get;
			set;
		}

		public UsageSource UsageSource
		{
			get { return this.usageSource; }
			set { this.usageSource = value; }
		}

		public UsageType UsageType
		{
			get { return this.usageType; }
			set { this.usageType = value; }
		}

		public DateTime BeginDate
		{
			get { return this.beginDate; }
			set { this.beginDate = value; }
		}

		public DateTime EndDate
		{
			get { return this.endDate; }
			set { this.endDate = value; }
		}

		public int Days
		{
			get { return ((this.endDate - this.beginDate).Days + 1); }
			set { this.days = value; }
		}

		public int TotalKwh
		{
			get { return this.totalKwh; }
			set { this.totalKwh = value; }
		}

		/// <summary>
		/// Billing demand in kilowatts.
		/// </summary>
		public decimal? BillingDemandKw
		{
			get { return this.billingDemandKw; }
			set { this.billingDemandKw = value; }
		}

		/// <summary>
		/// Off peak kilowatt hours.
		/// </summary>
		public decimal? OffPeakKwh
		{
			get { return this.offPeakKwh; }
			set { this.offPeakKwh = value; }
		}

		/// <summary>
		/// On peak kilowatt hours.
		/// </summary>
		public decimal? OnPeakKwh
		{
			get { return this.onPeakKwh; }
			set { this.onPeakKwh = value; }
		}

		public DateTime? DateCreated
		{
			get { return this.dateCreated; }
			set { this.dateCreated = value; }
		}

		public string CreatedBy
		{
			get { return this.createdBy; }
			set { this.createdBy = value; }
		}

		public DateTime? DateModified
		{
			get { return this.dateModified; }
			set { this.dateModified = value; }
		}

		#region added for CA support

		public decimal? IntermediateKwh
		{
			get { return intermediateKwh; }
			set
			{
				if( intermediateKwh == null )
					intermediateKwh = value;
				else
					throw new UtilityManagementException( "Field cannot be reassigned" );
			}
		}

		public decimal? MonthlyOffPeakDemandKw
		{
			get { return monthlyOffPeakDemandKw; }
			set
			{
				if( monthlyOffPeakDemandKw == null )
					monthlyOffPeakDemandKw = value;
				else
					throw new UtilityManagementException( "Field cannot be reassigned" );
			}
		}

		#endregion //added for CA support

		/// <summary>
		/// Name of user or process that modified this object.
		/// </summary>
		public string ModifiedBy
		{
			get { return this.modifiedBy; }
			set { this.modifiedBy = value; }
		}

		public decimal? MonthlyPeakDemandKw
		{
			get
			{ return this.monthlyPeakDemandKw; }
			set
			{ monthlyPeakDemandKw = value; }
		}
		/*
				/// <summary>
				/// Placeholder for ISTA’s transaction numbers (used for Cancels UsageType)
				/// </summary>
				public string TransactionNumber
				{
					get
					{ return transactionNumber; }
					set
					{ transactionNumber = value; }
				}

				/// <summary>
				/// Transmission and Distribution Service Providers (ERCOT)
				/// </summary>
				public decimal? TdspCharges
				{
					get { return tdspCharges; }
					set { tdspCharges = value; }
				}
		*/
		/// <summary>
		/// Unique (read only) row identifier from the database (used for auditing purposes)
		/// </summary>
		public long? ID
		{
			get
			{ return this.id; }
			set
			{ id = value; }
		}

		/// <summary>
		/// True if the record is coming from the consolidated table false otherwise (legacy tables)
		/// </summary>
		public bool IsConsolidated
		{
			get
			{ return isConsolidated; }
			set
			{ isConsolidated = value; }
		}

		public void AddOnPeakKwh( decimal? onPeakKwh )
		{
			if( this.onPeakKwh == null )
			{
				this.onPeakKwh = 0m;
			}
			this.onPeakKwh += onPeakKwh;
		}

		public void AddOffPeakKwh( decimal? offPeakKwh )
		{
			if( this.offPeakKwh == null )
			{
				this.offPeakKwh = 0m;
			}
			this.offPeakKwh += offPeakKwh;
		}

		/// <summary>
		/// Is the meter read active or not.
		/// </summary>
		public Int16 IsActive
		{
			get { return this.isAcive; }
			set { this.isAcive = value; }
		}

		/// <summary>
		/// If the meter read is not active, then what's the reason code.
		/// </summary>
		public ReasonCode ReasonCode
		{
			get { return this.reasonCode; }
			set { this.reasonCode = value; }
		}

		/// <summary>
		/// Meter Number
		/// </summary>
		public string MeterNumber
		{
			get;
			set;
		}

	}
}
