using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.AccountSql;
using LibertyPower.Business.MarketManagement.UsageManagement;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.Business.CustomerAcquisition.Prospects;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;


namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// 
	/// </summary>
	[Serializable]
	[System.Runtime.Serialization.DataContract]
	public class CompanyAccount : ProspectAccount
	{
		#region Properties

		private Product product;
		private List<string> errors;

		/// <summary>
		/// Unique INT identifier for account (new)
		/// </summary>
		public int Identity { get; set; }


		/// <summary>
		/// Unique STRING identifier for account (legacy)
		/// </summary>
		public string Identifier { get; set; }

		/// <summary>
		/// Product rate object
		/// </summary>
		public ProductRate ProductRate
		{
			get;
			set;
		}

		/// <summary>
		/// Read Cycle ID
		/// </summary>
		public string ReadCycleId
		{
			get;
			set;
		}

		/// <summary>
		/// 
		/// </summary>
		public string EnrollmentStatus
		{
			get;
			set;
		}

		/// <summary>
		/// 
		/// </summary>
		public string EnrollmentSubStatus
		{
			get;
			set;
		}

		/// <summary>
		/// Flow Start Date
		/// </summary>
		public DateTime FlowStartDate
		{
			get;
			set;
		}

		public DateTime DeenrollmentDate
		{
			get;
			set;
		}

		/// <summary>
		/// Unique identifier for account
		/// </summary>
		new public decimal? CreditScore
		{
			get;
			set;
		}

		/// <summary>
		/// Unique identifier for account
		/// </summary>
		new public string CreditAgency
		{
			get;
			set;
		}

		public int? SettlementLocationRefID
		{
			get;
			set;
		}

		/// <summary>
		/// Identifier of contract
		/// </summary>
		public int ContractID
		{
			get;
			set;
		}

		/// <summary>
		/// Identifier of contract
		/// </summary>
		new public string ContractNumber
		{
			get;
			set;
		}

		new public string ContractType
		{
			get;
			set;
		}

		/// <summary>
		/// Contract start date
		/// </summary>
		public DateTime ContractStartDate
		{
			get;
			set;
		}

		/// <summary>
		/// Contract end date
		/// </summary>
		public DateTime ContractEndDate
		{
			get;
			set;
		}

		/// <summary>
		/// Annual Usage
		/// </summary>
		new public int AnnualUsage
		{
			get;
			set;
		}

		/// <summary>
		/// Contract term (in months)
		/// </summary>
		public int Term
		{
			get;
			set;
		}

		/// <summary>
		/// Identifier for meter read date (also known as trip number)
		/// </summary>
		public string BillCycleId
		{
			get
			{
				return this.ReadCycleId;
			}
			set
			{
				this.ReadCycleId = value;
			}
		}

		/// <summary>
		/// Current rate
		/// </summary>
		new public decimal Rate
		{
			get;
			set;
		}

		/// <summary>
		/// Account type
		/// </summary>
		new public CompanyAccountType AccountType
		{
			get;
			set;
		}

		public int AccountTypeId
		{
			get;
			set;
		}
		public string ProductId
		{
			get;
			set;
		}

		new public Product Product
		{
			get
			{
                if ( product == null )
				{
					product = ProductFactory.CreateProduct( this.ProductId );
				}
				return product;
			}
			set
			{
				product = value;
			}
		}


		public int? CurrentEtfID { get; set; }


		private Etf etf;
		public Etf Etf
		{
			get
			{
                if (etf == null)
				{
                    if (CurrentEtfID.HasValue)
					{
						etf = EtfFactory.Get( this );
					}
					else
					{
						etf = new Etf();
					}
				}
				return etf;
			}
			set
			{
				etf = value;
			}
		}

		/// <summary>
		/// If true, no ETF will be charged for this account and no TNL letter will be send out.
		/// </summary>
		public bool WaiveEtf
		{
			get;
			set;
		}


		/// <summary>
		/// If WaiveEtf = true, EtfWaivedReasonCodeID stores the reason why ETF was 
		/// waived by Enrollment specialist.
		/// </summary>
		public int? WaivedEtfReasonCodeID
		{
			get;
			set;
		}

		/// <summary>
		/// If true, Deenrollment request was made by LibertyPower
		/// </summary>
		public bool IsOutgoingDeenrollmentRequest
		{
			get;
			set;
		}

		public new DateTime DateSubmit
		{
			get;
			set;
		}

		public new DateTime DateDeal
		{
			get;
			set;
		}

		public string SalesChannelId
		{
			get;
			set;
		}

		public new string SalesRep
		{
			get;
			set;
		}

		public string PricingZoneAndClass { get; set; }

		public new string BillingType
		{
			get;
			set;
		}

		public List<string> Errors
		{
			get
			{
                if (errors == null)
				{
					errors = new List<string>();
				}
				return errors;
			}
		}

		#endregion

		#region Potential Properties
		/*
		public string CustomerID
		public string Entity
		public string RetailMarket
		public string Utility
		public string BusinessType
		public string BusinessActivity
		public string TaxID
		public Contract CurrentContract
		public List<Contract> ContractHistory
		public Product CurrentProduct
		*/
		public string BusinessName { get; set; }

		/*
		public DateTime DateCreated
		public CreditRecord CreditRecord
		public bool POR
		public BillingType BillingType
		public string Zone
		public string ServiceClass
		public int StraturmVariable
		public string BillingGroup
		public int ICAP
		public int TCAP
		public int LoadProfile
		public int LossCode
		public int EnrollmentType
		*/
		#endregion

		/// <summary>
		/// indicates if the accounts is an IDR account, therefore the account has IDR usage:
		/// 1= NON-IDR
		/// 2= IDR
		/// 3= EMPTY VALUE
		/// </summary>
		public CommonBusiness.CommonEntity.MeterType.EMeterType MeterType
		{
			get;
			set;
		}

		internal string raw_icap;
		public string RawIcap
		{
			get
			{
				return raw_icap;
			}
		}

		internal string raw_tcap;
		public string RawTcap
		{
			get
			{
				return raw_tcap;
			}
		}

		internal string por_option;
		public bool IsPor
		{
			get
			{
				bool answer = false;
                if (por_option.Trim().ToUpper() == "YES")
				{
					answer = true;
				}
                else if (por_option.Trim().ToUpper() == "NO")
				{
					answer = false;
				}
				else
				{
					throw new AccountManagementException( string.Format( "The field por_option for account [{0}/{1}] is not in the expected format of YES / NO", this.UtilityCode, this.AccountNumber ) );
				}
				return answer;
			}
		}


		public bool IsSmbOrResidential
		{
			get
			{
                if (AccountType == CompanyAccountType.LCI)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
		}

		/// <summary>
		/// EnrollmentLeadDays
		/// </summary>
		public int EnrollmentLeadDays
		{
			get;
			set;
		}

		#region Constructors

		/// <summary>
		/// Constructor for creating object with no parameters
		/// </summary>
		public CompanyAccount()
			: base()
		{
		}

		/// <summary>
		/// Constructor for creating object with no parameters
		/// </summary>
		internal CompanyAccount( string Identifier )
			: base()
		{
			this.Identifier = Identifier;
		}

		/// <summary>
		/// Constructor taking 5 parameters (accountId, productId, contractStartDate, contractEndDate, readCycleId)
		/// </summary>
		/// <param name="accountId">Unique identifier for account</param>
		/// <param name="productId">Product identifier</param>
		/// <param name="contractStartDate">Contract start date</param>
		/// <param name="contractEndDate">Contract end date</param>
		/// <param name="readCycleId">Read Cycle ID</param>
		public CompanyAccount( string accountId, string productId, DateTime contractStartDate,
			DateTime contractEndDate, string readCycleId )
			: base( null )
		{
			this.Identifier = accountId;
			this.ProductId = productId;
			this.ContractStartDate = contractStartDate;
			this.ContractEndDate = contractEndDate;
			this.ReadCycleId = readCycleId;
		}



		/// <summary>
		/// Takes an identifier and populates the properties from the database.
		/// </summary>
		/// <param name="UserName">User name.</param>
		/// <param name="AccountID">The internal unique identifier of the account.</param>
		/*
	   public CompanyAccount(string UserName, string AccountID)
		   : base(null)
	   {
		   DataSet ds = AccountSql.GetCompanyAccount(UserName, AccountID);

		   if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
		   {
			   this.accountId = AccountID;
			   //this.BillGroup = Convert.ToInt32( ds.Tables[0].Rows[0][""] );
			   //this.Created = Convert.ToDateTime( ds.Tables[0].Rows[0][""] );
			   //this.CreatedBy = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.CustomerName  = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.DealId  = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   this.enrollmentStatus = Convert.ToString(ds.Tables[0].Rows[0]["status"]);
			   this.enrollmentSubStatus = Convert.ToString(ds.Tables[0].Rows[0]["sub_status"]);
			   this.CreditScore = Convert.ToDouble(ds.Tables[0].Rows[0]["credit_score"]);
			   this.CreditAgency = Convert.ToString(ds.Tables[0].Rows[0]["credit_agency"]);
			   //this.Icap  = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.ID = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.LoadProfile = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.LoadShapeId  = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.LossFactor = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.MeterReadCycleId  = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.Meters = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.Modified  = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.ModifiedBy  = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.NameKey  = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.RateClass  = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.RateCode = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.RetailMarketCode = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.ServiceAddress = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.Status = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.StratumVariable = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.SupplyGroup = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.Tcap = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.Usage = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.UsageDictionary = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.UtilityCode = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.Voltage = Convert.ToString( ds.Tables[0].Rows[0][""] );
			   //this.ZoneCode = Convert.ToString( ds.Tables[0].Rows[0][""] );
		   }

	   }
		 */
		#endregion

		/// <summary>
		/// Update the status of an account and creates the history records of the change.
		/// </summary>
		/// <param name="accountID">The internal unique identifier of the account.</param>
		/// <param name="status">The value of the status.</param>
		/// <param name="subStatus"></param>
		/// <param name="userName"></param>
		/// <param name="processID">The application which is making the change.</param>
		/// <param name="comment">Leave a comment which will be stored on the account record.  Sending a null will prevent a record from being created.</param>
		public static CompanyAccount UpdateStatus( string accountID, string status, string subStatus, string userName, string processID, string comment )
		{
			// TODO: Create a stored procedure which will perform the following within the scope of a single transaction
			// -Update status and sub_status in lp_account.dbo.account
			// -Create status history record in lp_account.dbo.account_status_history
			// -Create comment in lp_account.dbo.account_comments
			// -Return Account object with status properties set.
			try
			{
				AccountSql.UpdateStatus( accountID, comment, processID, userName, status, subStatus );
			}
            catch (AccountStatusNotUpdatedException)
			{

				throw new AccountStatusNotUpdatedException();
			}

			CompanyAccount a = CompanyAccountFactory.GetCompanyAccount( accountID );

			return a;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="contractNumber"></param>
		/// <returns></returns>
		public static long GetAccountCountByContractNumber( string contractNumber )
		{
			return AccountSql.CountAccountsByContractNumber( contractNumber );
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns>bool.</returns>
		public bool IsWithinCancellationPeriod()
		{
			bool success = false;
            if (DateTime.Today.ToString( "dd/MM/yyyy" ) == this.FlowStartDate.AddDays( -5 ).ToString( "dd/MM/yyyy" ) || this.FlowStartDate == DateTime.MinValue)
				success = true;


			return success;
		}

		public override bool Equals( object obj )
		{
			CompanyAccount other = obj as CompanyAccount;
            if (other.AccountNumber.Trim() == this.AccountNumber.Trim())
				return true;

			return false;
		}

		public override int GetHashCode()
		{
			return this.AccountNumber.Trim().GetHashCode();
		}

		public override string ToString()
		{
			return this.AccountNumber;
		}

        private static Dictionary<string, MeterReadScheduleItem> readScheduleCache = null;

		/// Gets the smallest meter read date of an account of the contract
		/// </summary>
		public DateTime MinimumMeterReadDate
		{
			get
			{
                return CalculateReadCycleDate(DateTime.Today.Date);
                //string dicKey = "";
                //dicKey = string.Format( "{0}_{1}_{2}", DateTime.Today.Date.ToString(), this.UtilityCode, this.ReadCycleId.ToString() );
                //if (readScheduleCache == null)
                //    readScheduleCache = new Dictionary<string, MeterReadScheduleItem>();

                //MeterReadScheduleItem meterReadSchedule = null;
                //if (!readScheduleCache.ContainsKey( dicKey ))
                //{
                //    meterReadSchedule = MeterReadScheduleFactory.GetNextMeterReadDateNoThrow( DateTime.Today.Date, this.UtilityCode, this.ReadCycleId.ToString() );
                //    readScheduleCache.Add( dicKey, meterReadSchedule );
                //}
                //else
                //{
                //    meterReadSchedule = readScheduleCache[dicKey];
                //}

                //if (meterReadSchedule != null)
                //    return meterReadSchedule.ReadDate.Date;

                //if (this.FlowStartDate == new DateTime( 1900, 1, 1 ))
                //    return DateTime.Today.AddDays( -1 );

                //DateTime meterReadDate;

                //try
                //{
                //    meterReadDate = new DateTime( DateTime.Today.Year, DateTime.Today.Month, this.FlowStartDate.Day );
                //}
                //catch (ArgumentOutOfRangeException)
                //{
                //    meterReadDate = new DateTime( DateTime.Today.Year, DateTime.Today.Month, this.FlowStartDate.AddDays( 1 ).Day );
                //}

                //if (meterReadDate.Date < DateTime.Today.Date)
                //    meterReadDate = meterReadDate.AddMonths( 1 );

                //return meterReadDate;
			}
		}

        private static Dictionary<string, Product> productCache = null;

		/// <summary>
		/// Verifies if an account is in default variable
		/// </summary>
		public bool IsInDefaultVariable
		{
			get
			{
                //TODO: do caching  here ?
                if (productCache == null)
                {
                    productCache = new Dictionary<string, Product>();
                }

                Product product = null;

                if (!productCache.ContainsKey( this.ProductId ))
                {
                    product = ProductFactory.CreateProduct( this.ProductId, false );
                    productCache.Add( this.ProductId, product );
                }
                else
                {
                    product = productCache[this.ProductId];
                }

                //LibertyPower.Business.CustomerAcquisition.ProductManagement.ProductBrand pb = ProductFactory.GetProductBrand(product.ProductBrandID);

                if (product.IsDefault)// || pb.Name.ToUpper().Trim() == "DEFAULT FIXED")
					return true;
				else
					return false;

			}
		}

		/// <summary>
		/// Verifies if an account is expired: if its end date is smaller than today
		/// OR if it is in default variable
		/// </summary>
		public bool IsExpired
		{
			get
			{
				return ((this.ContractEndDate < DateTime.Today.Date) || (this.IsInDefaultVariable));
			}
		}

		/// <summary>
		/// Verifies if an account is in an active status
		/// </summary>
		public bool IsActive
		{
			get
			{
				return !((this.EnrollmentStatus.Trim() == LibertyPower.Business.CustomerManagement.AccountManagement.EnrollmentStatus.GetValue( LibertyPower.Business.CustomerManagement.AccountManagement.EnrollmentStatus.Status.NotEnrolled )
					|| this.EnrollmentStatus.Trim() == LibertyPower.Business.CustomerManagement.AccountManagement.EnrollmentStatus.GetValue( LibertyPower.Business.CustomerManagement.AccountManagement.EnrollmentStatus.Status.EnrollmentCancelled )
                    || this.EnrollmentStatus.Trim() == LibertyPower.Business.CustomerManagement.AccountManagement.EnrollmentStatus.GetValue( LibertyPower.Business.CustomerManagement.AccountManagement.EnrollmentStatus.Status.Deenrolled ))
					&& this.EnrollmentSubStatus.Trim() == "10");
			}
		}

		/// <summary>
		/// Gets the mimimum date to start a renewal of the account
		/// </summary>
		public DateTime MinimumAccountRenewalStartDate
		{
			get
			{
                if (this.IsActive)
                {
                    if (!this.IsExpired)
                    {
                        return this.ContractEndDate.AddDays(1);
                    }
                }

                return this.MinimumMeterReadDate;
            }
        }

        /// <summary>
        /// Avg. Monthly Bill
        /// </summary>
        /// <returns></returns>
        public decimal GetAverageInvoice()
        {
            return AccountSql.GetAverageInvoice( this.Identifier );
        }

        public DateTime GetCycleReadDate(DateTime date)
        {
                if (this.IsActive)
				{
                    if (!this.IsExpired)
					{
                    DateTime minimumStartDateByContract = this.ContractEndDate.AddDays(1);
                    if (minimumStartDateByContract >= date)
                    {
                        return minimumStartDateByContract;
                    }
                }
            }

            return CalculateReadCycleDate(date);
        }

        public DateTime CalculateReadCycleDate(DateTime date)
        {
            string dicKey = "";
            dicKey = string.Format("{0}_{1}_{2}", date.ToString(), this.UtilityCode, this.ReadCycleId.ToString());
            if (readScheduleCache == null)
                readScheduleCache = new Dictionary<string, MeterReadScheduleItem>();

            MeterReadScheduleItem meterReadSchedule = null;
            if (!readScheduleCache.ContainsKey(dicKey))
            {
                meterReadSchedule = MeterReadScheduleFactory.GetNextMeterReadDateNoThrow(date, this.UtilityCode, this.ReadCycleId.ToString());
                readScheduleCache.Add(dicKey, meterReadSchedule);
            }
            else
            {
                meterReadSchedule = readScheduleCache[dicKey];
            }

            if (meterReadSchedule != null)
                return meterReadSchedule.ReadDate.Date;

            if (this.FlowStartDate == new DateTime(1900, 1, 1))
                return date.AddDays(-1);

            DateTime meterReadDate;

            try
            {
				//32993: 1-402739991 - Unable to process renewal Year, Month, and Day parameters describe an un- representable DateTime
				//Feb 11 2014
				meterReadDate = new DateTime( date.Year, date.Month, 1 ).AddDays( this.FlowStartDate.Day-1 );
              //  meterReadDate = new DateTime(date.Year, date.Month, this.FlowStartDate.Day);
            }
            catch (ArgumentOutOfRangeException)
            {
				if( date.Month == 12 )
				{
					meterReadDate = new DateTime( date.Year + 1, 1, 1 );
				}
				else
				{
					meterReadDate = new DateTime( date.Year, date.Month+1, 1 );
				}

               
            }

            if (meterReadDate.Date < DateTime.Today.Date)
                meterReadDate = meterReadDate.AddMonths(1);

            return meterReadDate;
        }



		public	DateTime GetFlowStartDate(DateTime ReadStartMonth)
		{
			if( this.FlowStartDate == new DateTime( 1900, 1, 1 ) )
			{
				//return DateTime.MinValue;
				return new DateTime( ReadStartMonth.Year, ReadStartMonth.Month, 1 );
			}


			DateTime flowStartDate = new DateTime( ReadStartMonth.Year, ReadStartMonth.Month, 1 );
			

			try
			{
				//32993: 1-402739991 - Unable to process renewal Year, Month, and Day parameters describe an un- representable DateTime
				//Feb 11 2014
				flowStartDate = new DateTime( ReadStartMonth.Year, ReadStartMonth.Month, 1 ).AddDays( this.FlowStartDate.Day - 1 );
				//  meterReadDate = new DateTime(date.Year, date.Month, this.FlowStartDate.Day);
			}
			catch( ArgumentOutOfRangeException )
			{
				if( ReadStartMonth.Month == 12 )
				{
					flowStartDate = new DateTime( ReadStartMonth.Year + 1, 1, 1 );
				}
				else
				{
					flowStartDate = new DateTime( ReadStartMonth.Year, ReadStartMonth.Month + 1, 1 );
				}


			}
			return flowStartDate;
		}

		public MeterReadCalendar GetUtility_Min_EligibleDate()
		{
			LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccount ca = null;
			MeterReadCalendar meterReadCalendar = null;
			DateTime MinAttainableEndDeadline = System.DateTime.Now;
			int RateChangeLeadTime = 0;
			int EnrollLeadTime = 0;

			try
			{
				ca = LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccountFactory.GetCompanyAccount( this.AccountNumber, this.UtilityCode );
                //RateChangeLeadTime = ca.EnrollmentLeadDays;
				EnrollLeadTime = ca.EnrollmentLeadDays;
				MeterReadCalendarFactory BAL = new MeterReadCalendarFactory();
				//If Account is Flowing -Find the cycle Date containing the given Date
				//else find the Cycle date after the given date
				if( ca.IsActive )
				{
					//getBilling Cycle StartDate Containing- if there is no data in meter read table, the read date could be this month
					DateTime ModifiedMinAttainableDate=MinAttainableEndDeadline.AddDays( RateChangeLeadTime )  ;
					meterReadCalendar = BAL.GetTheBillingCycleContainingGivenDate( this.UtilityCode, this.ReadCycleId.ToString(), ModifiedMinAttainableDate );
					if( !meterReadCalendar.Read_Start_Date.HasValue || meterReadCalendar.Read_Start_Date == DateTime.MinValue )
						meterReadCalendar = GetMeterReadCalendarObject(true, ModifiedMinAttainableDate );						
				}
				else
				{
					DateTime ModifiedMinAttainableDate = MinAttainableEndDeadline.AddDays( EnrollLeadTime );
					meterReadCalendar = BAL.GetTheBillingCycleAfterGivenDate( this.UtilityCode, this.ReadCycleId.ToString(), ModifiedMinAttainableDate );
					if( !meterReadCalendar.Read_Start_Date.HasValue || meterReadCalendar.Read_Start_Date == DateTime.MinValue )
						meterReadCalendar = GetMeterReadCalendarObject( false, ModifiedMinAttainableDate );		
				}
			}
			catch( AccountNotFoundException )// for new account
			{
				meterReadCalendar = new MeterReadCalendar();
				meterReadCalendar.Start_Month = System.DateTime.Now;
				//If Company Account doesn't exist then its a new account- so the min eligiblity is the today + EnrollLeadTime
				meterReadCalendar.Read_Start_Date = MinAttainableEndDeadline.AddDays( EnrollLeadTime );
			}
			return meterReadCalendar;
		}

		private MeterReadCalendar GetMeterReadCalendarObject(bool AccountIsActive, DateTime MinAttainableDate)
		{
			MeterReadCalendar meterReadCalendar = new MeterReadCalendar();
			//get the flow Start date- if there is no flow start date available then, it returns the first day of the MinAttainableDate 
			meterReadCalendar.Read_Start_Date = GetFlowStartDate( MinAttainableDate );
			//when the read start date is lesser than the MinAttainableDate then, they could renew for the same month.
			if( meterReadCalendar.Read_Start_Date < MinAttainableDate )
				meterReadCalendar.Start_Month = new DateTime( MinAttainableDate.Year, MinAttainableDate.Month, 1 );
            else // else if the read date is greater they could possibly renew for the previous month itself
            //(eg:meterreadStartdate= 5/20, MinAttainableDate=5/1 => the account is still flowing, then we could allow them to start on 4/20 since the billing end is going to be in(5/20) future)  
            {
                if (MinAttainableDate.Month == 1)
                {
                    meterReadCalendar.Start_Month = AccountIsActive ? new DateTime(MinAttainableDate.Year, 12, 1) : new DateTime(MinAttainableDate.Year, MinAttainableDate.Month, 1);
                }
                else
                {
                    meterReadCalendar.Start_Month = AccountIsActive ? new DateTime(MinAttainableDate.Year, MinAttainableDate.Month - 1, 1) : new DateTime(MinAttainableDate.Year, MinAttainableDate.Month, 1);
                }
            }
			return meterReadCalendar;
		}

		private MeterReadCalendar GetLP_Min_EligibleDate()
		{
			LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccount ca = null;
			MeterReadCalendar meterReadCalendar = null;
			DateTime MinAttainableEndDealline = System.DateTime.Now;
			int RateChangeLeadTime = 0;
			int EnrollLeadTime = 0;

			try
			{
				ca = LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccountFactory.GetCompanyAccount( this.AccountNumber, this.UtilityCode );
				//RateChangeLeadTime = ca.EnrollmentLeadDays;
				EnrollLeadTime = ca.EnrollmentLeadDays;

				MeterReadCalendarFactory BAL = new MeterReadCalendarFactory();
				if( ca.IsActive )
				{
					if( ca.IsExpired )
					{
						//getBilling Cycle StartDate Containing
						meterReadCalendar = BAL.GetTheBillingCycleContainingGivenDate( this.UtilityCode, this.ReadCycleId.ToString(), MinAttainableEndDealline.AddDays( RateChangeLeadTime ) );
						if( !meterReadCalendar.Read_Start_Date.HasValue || meterReadCalendar.Read_Start_Date== DateTime.MinValue )
							meterReadCalendar = GetMeterReadCalendarObject( true, MinAttainableEndDealline.AddDays( RateChangeLeadTime ) );
					}
					else
					{
						//ContractEndDate+1;
						//return (new DateTime( ca.ContractEndDate.Year, ca.ContractEndDate.Month, 1 ));
                        meterReadCalendar = BAL.GetTheBillingCycleContainingGivenDate(this.UtilityCode, this.ReadCycleId.ToString(), ca.ContractEndDate.AddDays(1));
                        if (!meterReadCalendar.Read_Start_Date.HasValue || meterReadCalendar.Read_Start_Date == DateTime.MinValue)
                            meterReadCalendar = GetMeterReadCalendarObject(false, ca.ContractEndDate);
					}
				}
				else
				{
					//getBIlling Cyle StartdateAfter
					meterReadCalendar = BAL.GetTheBillingCycleAfterGivenDate( this.UtilityCode, this.ReadCycleId.ToString(), MinAttainableEndDealline.AddDays( EnrollLeadTime ) );
					if( !meterReadCalendar.Read_Start_Date.HasValue || meterReadCalendar.Read_Start_Date == DateTime.MinValue )
						meterReadCalendar = GetMeterReadCalendarObject( false, MinAttainableEndDealline.AddDays( EnrollLeadTime ) );
				}
			}
			catch( AccountNotFoundException )
			{
				meterReadCalendar = new MeterReadCalendar();
				meterReadCalendar.Start_Month = System.DateTime.MinValue;
				meterReadCalendar.Read_Start_Date = System.DateTime.MinValue;
			}

			if( meterReadCalendar == null && meterReadCalendar.Start_Month== null )
			{
				meterReadCalendar = new MeterReadCalendar();
				meterReadCalendar.Start_Month = new DateTime( System.DateTime.Now.Year, System.DateTime.Now.Month, 1 );
				meterReadCalendar.Read_Start_Date = new DateTime( System.DateTime.Now.Year, System.DateTime.Now.Month, 1 );
				
				//return meterReadCalendar;
				//return (new DateTime(System.DateTime.Now.Year, System.DateTime.Now.Month, 1));
			}
		    
            return meterReadCalendar;

		}






		public MeterReadCalendar GetMinEligiblePricingMonth()
		{
			MeterReadCalendar meterReadCalendar;
			try
			{

				MeterReadCalendar UtilityMinEligibleDate;
				UtilityMinEligibleDate = GetUtility_Min_EligibleDate();
				MeterReadCalendar LPMinEligibleDate;
				LPMinEligibleDate = GetLP_Min_EligibleDate();
				if( UtilityMinEligibleDate.Start_Month >= LPMinEligibleDate.Start_Month )
					return UtilityMinEligibleDate;
				else
					return LPMinEligibleDate;
		}
			catch( AccountNotFoundException )
		{
				//return DateTime.MinValue;
				meterReadCalendar = new MeterReadCalendar();
				meterReadCalendar.Start_Month = new DateTime( System.DateTime.Now.Year, System.DateTime.Now.Month, 1 );
				meterReadCalendar.Read_Start_Date = GetFlowStartDate( meterReadCalendar.Start_Month );
				return meterReadCalendar;
			}

		}
        
        /// <summary>
        /// Credit Insurance Flag
        /// </summary>
        public bool CreditInsuranceFlag
        {
            get;
            set;
        }

	}
}
