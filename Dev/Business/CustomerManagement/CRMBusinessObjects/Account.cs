using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using LibertyPower.Business.CustomerManagement.AccountManagement;
using DAL = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	[Serializable]
	//[System.Runtime.Serialization.DataContract( Namespace = "http://lporders.libertypowercorp.com", Name = "Account" )]
	[System.Runtime.Serialization.DataContract]
	public class Account : ICloneable, IValidator
	{
		#region Fields

		[NonSerialized]
		List<AccountContract> accountContracts;

		
		#endregion

		#region Constructors

		public Account()
		{
			SetDefaultValues();
		}

		/// <summary>
		/// Sets the class' default values, it is called on object construction, but it is also used in WCF implementation
		/// </summary>
		public void SetDefaultValues()
		{
			if( !this.MeterTypeId.HasValue )
				this.MeterTypeId = 3;
			if( !this.BillingTypeId.HasValue )
				this.BillingType = Enums.BillingType.NotSet;
			if( !TaxStatusId.HasValue )
				this.TaxStatus = Enums.TaxStatus.Full;
			if( string.IsNullOrEmpty( this.AccountName ) )
				this.AccountName = "not entered";

			if( string.IsNullOrEmpty( this.Zone ) )
				this.Zone = "";
			if( string.IsNullOrEmpty( this.ServiceRateClass ) )
				this.ServiceRateClass = "";
			if( string.IsNullOrEmpty( this.LoadProfile ) )
				this.LoadProfile = "";
			if( string.IsNullOrEmpty( this.LossCode ) )
				this.LossCode = "";
			if( string.IsNullOrEmpty( this.StratumVariable ) )
				this.StratumVariable = "";

		}

		#endregion

		#region Properties

		#region Primary key(s)

		/// <summary>			
		/// AccountID : 
		/// </summary>
		/// <remarks>Member of the primary key of the underlying table "Account"</remarks>
		public System.Int32? AccountId { get; set; }

		#endregion

		#region Non Primary key(s)

		/// <summary>
		/// AccountIdLegacy : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String AccountIdLegacy { get; set; }


		private System.String _accountNumber;
		/// <summary>
		/// AccountNumber : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String AccountNumber
		{
			get
			{
				return _accountNumber;
			}
			set
			{
				this._accountNumber = value;
				if( !string.IsNullOrEmpty( this._accountNumber ) )
					this._accountNumber = this._accountNumber.Trim();
			}
		}

		private System.Int32? _AccountTypeId;

		/// <summary>
		/// AccountTypeID : 
		/// </summary>
		public System.Int32? AccountTypeId
		{
			get
			{
				return this._AccountTypeId;
			}

			set
			{
				Enums.AccountType tempType;
				if( value.HasValue && Enum.TryParse<Enums.AccountType>( value.ToString(), out tempType ) )
				{
					this._AccountTypeId = value;
				}
			}
		}

		/// <summary>
		/// CustomerID : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.Int32? CustomerId { get; set; }

		/// <summary>
		/// CustomerIdLegacy : 
		/// </summary>
		public System.String CustomerIdLegacy { get; set; }

		/// <summary>
		/// EntityID : 
		/// </summary>
		public System.String EntityId { get; set; }

		/// <summary>
		/// RetailMktID : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.Int32? RetailMktId { get; set; }

		/// <summary>
		/// UtilityID : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.Int32? UtilityId { get; set; }

		/// <summary>
		/// AccountNameID : 
		/// </summary>
		public System.Int32? AccountNameId { get; set; }

		/// <summary>
		/// BillingAddressID : 
		/// </summary>
		public System.Int32? BillingAddressId { get; set; }

		/// <summary>
		/// BillingContactID : 
		/// </summary>
		public System.Int32? BillingContactId { get; set; }

		/// <summary>
		/// ServiceAddressID : 
		/// </summary>
		public System.Int32? ServiceAddressId { get; set; }

		/// <summary>
		/// Origin : 
		/// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String Origin { get; set; }


		private System.Int32? _taxStatusId;

		/// <summary>
		/// TaxStatusID : 
		/// </summary>
		public System.Int32? TaxStatusId
		{
			get
			{
				return this._taxStatusId;
			}

			set
			{
				Enums.TaxStatus tempType;
				if( value.HasValue && Enum.TryParse<Enums.TaxStatus>( value.ToString(), out tempType ) )
				{
					this._taxStatusId = value;
				}
				//else
				//{
				//    throw new ArgumentOutOfRangeException( "The value is outside the valid range of values of TaxStatus" );
				//}

			}
		}

		/// <summary>
		/// PorOption : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.Boolean? PorOption { get; set; }

		private System.Int32? _billingTypeId;

		/// <summary>
		/// BillingTypeID : 
		/// </summary>
		public System.Int32? BillingTypeId
		{
			get
			{
				return this._billingTypeId;
			}

			set
			{
				Enums.BillingType tempType;
				if( value.HasValue && Enum.TryParse<Enums.BillingType>( value.ToString(), out tempType ) )
				{
					this._billingTypeId = value;
				}
				//else
				//{
				//    throw new ArgumentOutOfRangeException( "The value is outside the valid range of values of Enums.BillingType" );
				//}
			}
		}

		/// <summary>
		/// Zone : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String Zone { get; set; }

		/// <summary>
		/// ServiceRateClass : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String ServiceRateClass { get; set; }

		/// <summary>
		/// StratumVariable : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String StratumVariable { get; set; }

		/// <summary>
		/// BillingGroup : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String BillingGroup { get; set; }

		/// <summary>
		/// Icap : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String Icap { get; set; }

		/// <summary>
		/// Tcap : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String Tcap { get; set; }

		/// <summary>
		/// LoadProfile : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String LoadProfile { get; set; }

		/// <summary>
		/// LossCode : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.String LossCode { get; set; }

		/// <summary>
		/// MeterTypeID : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public System.Int32? MeterTypeId { get; set; }

		private List<string> _meters = new List<string>();

		/// <summary>
		/// AccountNumber : 
		/// </summary>
		[System.Runtime.Serialization.DataMember]
		public List<System.String> MeterNumbers
		{
			get
			{
				return this._meters;
			}

			set
			{
				if( value != null )
				{
					this._meters = value;
				}
			}
		}

		/// <summary>
		/// CurrentContractID : 
		/// </summary>
		public System.Int32? CurrentContractId { get; set; }

		/// <summary>
		/// CurrentRenewalContractID : 
		/// </summary>
		public System.Int32? CurrentRenewalContractId { get; set; }

		/// <summary>
		/// Modified : 
		/// </summary>
		public System.DateTime Modified { get; set; }

		/// <summary>
		/// ModifiedBy : 
		/// </summary>
		public System.Int32 ModifiedBy { get; set; }

		/// <summary>
		/// DateCreated : 
		/// </summary>
		public System.DateTime DateCreated { get; set; }

		/// <summary>
		/// CreatedBy : 
		/// </summary>
		public System.Int32 CreatedBy { get; set; }

		#endregion

		#region Entity Properties

		[System.Runtime.Serialization.DataMember]
		public string AccountName { get; set; }

		[System.Runtime.Serialization.DataMember]
		public Enums.AccountType AccountType
		{
			get
			{
				return (Enums.AccountType) Enum.Parse( typeof( Enums.AccountType ), this._AccountTypeId.ToString() );
			}
			set
			{
				this._AccountTypeId = (int) value;
			}
		}

		[System.Runtime.Serialization.DataMember]
		public Enums.BillingType BillingType
		{
			get
			{
				return (Enums.BillingType) Enum.Parse( typeof( Enums.BillingType ), this._billingTypeId.ToString() );
			}
			set
			{
				this._billingTypeId = (int) value;
			}
		}

		[System.Runtime.Serialization.DataMember]
		public Enums.TaxStatus TaxStatus
		{
			get
			{
				return (Enums.TaxStatus) Enum.Parse( typeof( Enums.TaxStatus ), this._taxStatusId.ToString() );
			}
			set
			{
				this._taxStatusId = (int) value;
			}
		}

		[System.Runtime.Serialization.DataMember]
		public Contact BillingContact { get; set; }

		[System.Runtime.Serialization.DataMember]
		public Address BillingAddress { get; set; }

		[System.Runtime.Serialization.DataMember]
		public Address ServiceAddress { get; set; }

		[System.Runtime.Serialization.DataMember]
		public Customer Customer { get; set; }

		[System.Runtime.Serialization.DataMember]
		public AccountDetail Details { get; set; }

		public LibertyPower.Business.MarketManagement.UtilityManagement.Utility Utility { get; set; }

		public LibertyPower.Business.MarketManagement.UtilityManagement.RetailMarket RetailMarket { get; set; }

		public List<AccountContract> AccountContracts
		{
			get
			{
				if( accountContracts == null )
				{
					accountContracts = new List<AccountContract>();
				}
				return accountContracts;
			}
			set
			{
				accountContracts = value;
			}
		}

		[System.Runtime.Serialization.DataMember]
		public List<AccountUsage> AccountUsages { get; set; }

		[System.Runtime.Serialization.DataMember]
		public AccountInfo AccountInfo { get; set; }

		/// <summary>
		/// DeliveryLocationRefID : Liberty power internal value that represents the zone
		/// </summary>
		public System.Int32? DeliveryLocationRefID { get; set; }

		/// <summary>
		/// ServiceClassRefID : Liberty power internal value that represents the profile
		/// </summary>
		public System.Int32? LoadProfileRefID { get; set; }

		public System.Int32? ServiceClassRefID { get; set; }

		#endregion Entity properties

		#endregion

		#region Methods

		#region Clone Method

		/// <summary>
		/// Creates a new object that is a copy of the current instance.
		/// </summary>
		/// <returns>A new object that is a copy of this instance.</returns>
		public Object Clone()
		{
			Account _tmp = new Account();
			_tmp.AccountId = this.AccountId;
			_tmp.AccountIdLegacy = this.AccountIdLegacy;
			_tmp.AccountNumber = this.AccountNumber;
			_tmp.AccountTypeId = this.AccountTypeId;
			_tmp.CustomerId = this.CustomerId;
			_tmp.CustomerIdLegacy = this.CustomerIdLegacy;
			_tmp.EntityId = this.EntityId;
			_tmp.RetailMktId = this.RetailMktId;
			_tmp.UtilityId = this.UtilityId;
			_tmp.AccountNameId = this.AccountNameId;
			_tmp.BillingAddressId = this.BillingAddressId;
			_tmp.BillingContactId = this.BillingContactId;
			_tmp.ServiceAddressId = this.ServiceAddressId;
			_tmp.Origin = this.Origin;
			_tmp.TaxStatusId = this.TaxStatusId;
			_tmp.PorOption = this.PorOption;
			_tmp.BillingTypeId = this.BillingTypeId;
			_tmp.Zone = this.Zone;
			_tmp.ServiceRateClass = this.ServiceRateClass;
			_tmp.StratumVariable = this.StratumVariable;
			_tmp.BillingGroup = this.BillingGroup;
			_tmp.Icap = this.Icap;
			_tmp.Tcap = this.Tcap;
			_tmp.LoadProfile = this.LoadProfile;
			_tmp.LossCode = this.LossCode;
			_tmp.MeterTypeId = this.MeterTypeId;
			_tmp.CurrentContractId = this.CurrentContractId;
			_tmp.CurrentRenewalContractId = this.CurrentRenewalContractId;
			_tmp.Modified = this.Modified;
			_tmp.ModifiedBy = this.ModifiedBy;
			_tmp.DateCreated = this.DateCreated;
			_tmp.CreatedBy = this.CreatedBy;

			return _tmp;
		}

		#endregion

		#region IValidator Members

		public bool IsStructureValidForInsert()
		{
			//// Details object is required to save this object
			//if( this.Details == null )
			//    return false;

			//// a new accounts detail object is required
			//if( !this.Details.IsStructureValidForInsert() )
			//    return false;

			//// This field can be created before account insert is called or at the same time the account uis created
			//if( this.BillingAddress == null && !this.BillingAddressId.HasValue )
			//    return false;

			//if( !this.BillingAddress.IsStructureValidForInsert() )
			//    return false;

			//// This field can be created before account insert is called or at the same time the account uis created
			//if( this.ServiceAddress == null && !this.ServiceAddressId.HasValue )
			//    return false;

			//if( !this.ServiceAddress.IsStructureValidForInsert() )
			//    return false;

			//// This field can be created before account insert is called or at the same time the account uis created
			//if( this.BillingContact == null && !this.BillingContactId.HasValue )
			//    return false;

			//if( !this.BillingContact.IsStructureValidForInsert() )
			//    return false;

			// Customer Id needs to be inserted before account, there must be a customer before an account is created
			//if( !this.CustomerId.HasValue )
			//    return false;

			return true;
		}

		public bool IsStructureValidForUpdate()
		{
			/* Commented on 5/16 by Cghazal: when attempting to update the account object, the Details is not loaded and it is always null, therefore update always fails
			 * According to Jaime, this section should be commented for now.
            // Details object is required to save this object
            if (this.Details == null)
                return false;

            // a new accounts detail object is required
            if (!this.Details.IsStructureValidForInsert())
                return false;
			 */
			return true;
		}

		public List<GenericError> IsValid()
		{
			List<GenericError> errors = new List<GenericError>();

			// BAL level validation, data validation
            if (!this.HasValidAccountNumber)
            {
                errors.Add(new GenericError() { Code = 0, Message = "Account Number should not contain special characters" });
            }

			if( (!this.AccountNameId.HasValue || this.AccountNameId.Value == 0) && string.IsNullOrEmpty( this.AccountName ) )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account NameID must have a valid value" } );
			}

			if( (!this.BillingAddressId.HasValue || this.BillingAddressId.Value == 0) && this.BillingAddress == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account BillingAddressID must have a valid value" } );
			}

			if( (!this.BillingContactId.HasValue || this.BillingContactId.Value == 0) && this.BillingContact == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account BillingContactId must have a valid value" } );
			}

			if( (!this.ServiceAddressId.HasValue || this.ServiceAddressId.Value == 0) && this.ServiceAddress == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account ServiceAddressId must have a valid value" } );
			}

			if( !this.UtilityId.HasValue || this.UtilityId.Value == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account UtilityId must have a valid value" } );
			}

			if( !this.RetailMktId.HasValue || this.RetailMktId.Value == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account Market is must have a valid value" } );
			}

			if( !this.AccountTypeId.HasValue || this.AccountTypeId.Value == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account TypeId must have a valid value" } );
			}

			if( string.IsNullOrEmpty( this.AccountNumber ) )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account Number must have a valid value" } );
			}

			if( string.IsNullOrEmpty( this.Origin ) )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account Origin must have a valid value" } );
			}

			if( this.ModifiedBy == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account Modified By must have a valid value" } );
			}

			if( this.CreatedBy == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account Created By must have a valid value" } );
			}

			if( this.BillingTypeId == null || this.BillingTypeId == 0 )
			{
				errors.Add( new GenericError() { Code = 0, Message = "BillingTypeId By must have a valid value" } );
			}

			if( this.TaxStatusId == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "TaxStatusId By must have a valid value" } );
			}

			if( (this.CustomerId == null || this.CustomerId == 0) && this.Customer == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "CustomerId must have a valid value" } );
			}



			return errors;
		}

		public List<GenericError> IsValidForInsert()
		{
			List<GenericError> tmpErrors = null;
			List<GenericError> errors = new List<GenericError>();

			errors = IsValid();

			if( errors.Count > 0 )
			{
				return errors;
			}

			if( !this.IsValidUtilityAccountNumber( out tmpErrors ) )
			{
				errors.AddRange( tmpErrors );
			}

			if( this.Utility == null )
			{
				this.Utility = LibertyPower.Business.MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById( this.UtilityId.Value );
			}

			if( AccountFactory.IsAccountNumberInTheSystem( this.AccountNumber, this.Utility.Identity ) )
			{
				errors.Add( new GenericError() { Code = 1, Message = string.Format( "The account number already exists, please verify. Submitted value ='{0}'", this.AccountNumber ) } );
			}

			return errors;
		}

		#endregion

		#region General Validation

		public List<GenericError> IsValidForUpdate()
		{
			// careful with this call
			List<GenericError> errors = new List<GenericError>();
			errors = IsValid();

			if( this.Zone == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Zone cannot be null for update" } );
			}

			if( this.Tcap == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Tcap cannot be null for update" } );
			}

			if( this.StratumVariable == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "StratumVariable cannot be null for update" } );
			}

			if( this.ServiceRateClass == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "ServiceRateClass cannot be null for update" } );
			}

			if( this.Origin == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Origin cannot be null for update" } );
			}

			if( this.LossCode == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "LossCode cannot be null for update" } );
			}


			if( this.LoadProfile == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "LoadProfile cannot be null for update" } );
			}

			if( this.Icap == null )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Icap cannot be null for update" } );
			}


			return errors;
		}

		/// <summary>
		/// Checks that the account number meets the utility account numbering criteria
		/// </summary>
		/// <param name="errors"></param>
		/// <returns></returns>
		public bool IsValidUtilityAccountNumber( out List<GenericError> errors )
		{
			errors = new List<GenericError>();

			if( !this.UtilityId.HasValue )
			{
				throw new InvalidOperationException( "Trying to validate the account number when the utility is not set" );
			}

			if( this.Utility == null )
			{
				this.Utility = LibertyPower.Business.MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById( this.UtilityId.Value );
			}

			if( this.AccountNumber.Length != this.Utility.AccountNumberLength )
			{
				errors.Add( new GenericError() { Code = 0, Message = "Account Number length is not valid for utility " + this.Utility.FullName } );
				return false;
			}

            if ( !String.IsNullOrEmpty( this.Utility.AccountNumberPrefix ) && !this.AccountNumber.StartsWith( this.Utility.AccountNumberPrefix ) )
            {
                errors.Add(new GenericError() { Code = 0, Message = "Account Number prefix is not valid for utility " + this.Utility.FullName });
                return false;
            }

			return true;
		}

		public bool IsBillingTypeAllowedInUtility()
		{
			if( !this.UtilityId.HasValue )
			{
				throw new InvalidOperationException( "Trying to validate Billing for Account and the utility Id is not set" );
			}

			if( this.Utility == null )
			{
				this.Utility = LibertyPower.Business.MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById( this.UtilityId.Value );
			}

			// check that the Billing type is whithin the values allowed in the utility billing type settings:
			using( DAL.LibertyPowerEntities dal = new DAL.LibertyPowerEntities() )
			{
				var matches = from bt in dal.UtilityBillingTypes
							  //join u in dal.Utilities on bt.UtilityID equals u.ID
							  where bt.UtilityID == this.UtilityId.Value
								&& bt.BillingTypeID == this.BillingTypeId.Value
							  //select new { bt.BillingTypeID, u.UtilityCode };
							  select new { bt.BillingTypeID };

				if( matches == null || matches.Count() == 0 )
				{
					//errors.Add( new GenericError() { Code = 0, Message = string.Format( "The Billing Type: {0}, is not allowed for utility: {1}", this.BillingType, this.Utility.Code ) } );
					return false;
				}
			}
			return true;
		}

		#endregion General Validation

		public bool IsTexasAccount()
		{
			if( this.RetailMktId.HasValue && this.RetailMktId.Value == 1 )
				return true;
			else
				return false;
		}

		public override string ToString()
		{
			string tmp = string.Empty;
			tmp = string.Format( "Name: {0} Number: {1} LegacyId: {2}", this.AccountName, this.AccountNumber, this.AccountIdLegacy );
			return tmp;
		}

		public bool HasRequiredAdditionalFields()
		{
			// First get any additional fields that the utility requires:
			if( this.Utility == null )
			{
				this.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityById( this.UtilityId.Value );
			}
			List<UtilityRequiredData> requiredUtilityData = CRMBaseFactory.GetUtilityRequiredData( this.Utility.Code );
			if( requiredUtilityData == null || requiredUtilityData.Count == 0 )
				return false;
			else
				return true;
		}

        public bool HasValidAccountNumber
        {
            get
            {
                System.Text.RegularExpressions.Regex re = new System.Text.RegularExpressions.Regex("^[a-zA-Z0-9]+$");

                return (re.IsMatch(this.AccountNumber) && (this.AccountNumber.Trim() != ""));
            }
        }

		public DateTime GetMinimumMeterReadDate()
		{
			LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccount ca = null;

			try
			{
				ca = LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccountFactory.GetCompanyAccount( this.AccountNumber, this.Utility.Code );
				return ca.MinimumMeterReadDate;
			}
			catch( AccountNotFoundException )
			{
				return DateTime.MinValue;
			}
		}

		public DateTime GetMinimumAccountRenewalStartDate()
		{
			LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccount ca = null;

			try
			{
				ca = LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccountFactory.GetCompanyAccount( this.AccountNumber, this.Utility.Code );
				return ca.MinimumAccountRenewalStartDate;
			}
			catch( AccountNotFoundException )
			{
				return DateTime.MinValue;
			}
		}

		public DateTime GetMinimumAccountRenewalStartDate_NEW()
		{
			LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccount ca = null;

			try
			{
				ca = LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccountFactory.GetCompanyAccount( this.AccountNumber, this.Utility.Code );
				return ca.GetMinEligiblePricingMonth().Read_Start_Date.Value;
			}
			catch( AccountNotFoundException )
			{
				return DateTime.MinValue;
			}
		}

		public DateTime GetFlowStartDate_NEW(DateTime ReadStartMonth)
		{
			LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccount ca = null;

			try
			{
				ca = LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccountFactory.GetCompanyAccount( this.AccountNumber, this.Utility.Code );
				return ca.GetFlowStartDate( ReadStartMonth );
			}
			catch( AccountNotFoundException )
			{
				return DateTime.MinValue;
			}
		}

        public void SetOriginBasedOnContractApplicationType (Enums.ClientApplicationType clientApplicationType)
        {
            switch (clientApplicationType)
            {
                case Enums.ClientApplicationType.OnlineEnrollment:
                    this.Origin = Enums.AccountOrigin.Web.ToString().ToUpper();
                    break;
                case Enums.ClientApplicationType.Tablet:
                    this.Origin = Enums.AccountOrigin.Genie.ToString().ToUpper();
                    break;
            }
        }


		#endregion

		[OnDeserialized]
		private void SetValuesOnDeserialized( StreamingContext context )
		{
			SetDefaultValues();
		}

	}
}
