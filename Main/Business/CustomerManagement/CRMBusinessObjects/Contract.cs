using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DM = LibertyPower.Business.CommonBusiness.DocumentManager;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    //[System.Runtime.Serialization.DataContract( Namespace = "http://lporders.libertypowercorp.com", Name = "Contract" )]
    [System.Runtime.Serialization.DataContract]
    public class Contract : ICloneable, IValidator
    {
        public Contract()
        {
            this.SetDefaultValues();
        }

        #region Primary key(s)
        /// <summary>			
        /// ContractID : 
        /// </summary>
        /// <remarks>Member of the primary key of the underlying table "Contract"</remarks>
        public System.Int32? ContractId { get; set; }

        #endregion

        #region Non Primary key(s)

        /// <summary>
        /// Number : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String Number { get; set; }

        private System.Int32? _contractTypeId;

        /// <summary>
        /// ContractTypeID : 
        /// </summary>
        public System.Int32? ContractTypeId
        {
            get
            {
                return this._contractTypeId;
            }

            set
            {
                Enums.ContractType tempType;
                if( value.HasValue && Enum.TryParse<Enums.ContractType>( value.ToString(), out tempType ) )
                {
                    this._contractTypeId = value;
                }
                else
                {
                    throw new ArgumentOutOfRangeException( "The value is outside the valid range of values of Enums.ContractType" );
                }
            }
        }

        private System.Int32? _contractDealTypeId;

        /// <summary>
        /// ContractDealTypeID : 
        /// </summary>
        public System.Int32? ContractDealTypeId
        {
            get
            {
                return this._contractDealTypeId;
            }

            set
            {
                Enums.ContractDealType tempType;
                if( value.HasValue && Enum.TryParse<Enums.ContractDealType>( value.ToString(), out tempType ) )
                {
                    this._contractDealTypeId = value;
                }
                else
                {
                    throw new ArgumentOutOfRangeException( "The value is outside the valid range of values of Enums.ContractDealType" );
                }
            }
        }

        private System.Int32? _contractStatusId;

        /// <summary>
        /// ContractStatusID : 
        /// </summary>
        public System.Int32? ContractStatusId
        {
            get
            {
                return this._contractStatusId;
            }

            set
            {
                Enums.ContractStatus tempType;
                if( value.HasValue && Enum.TryParse<Enums.ContractStatus>( value.ToString(), out tempType ) )
                {
                    this._contractStatusId = value;
                }
                else
                {
                    throw new ArgumentOutOfRangeException( "The value is outside the valid range of values of Enums.ContractStatus" );
                }
            }
        }

        private System.Int32? _contractTemplateId;

        /// <summary>
        /// ContractTemplateID : 
        /// </summary>		
        public System.Int32? ContractTemplateId
        {
            get
            {
                return this._contractTemplateId;
            }

            set
            {
                Enums.ContractTemplate tempType;
                if( value.HasValue && Enum.TryParse<Enums.ContractTemplate>( value.ToString(), out tempType ) )
                {
                    this._contractTemplateId = value;
                }
                else
                {
                    throw new ArgumentOutOfRangeException( "The value is outside the valid range of values of Enums.ContractTemplate" );
                }
            }
        }

        [System.Runtime.Serialization.DataMember]
        public System.Int32? ContractTemplateVersionId
        {
            get;
            set;
        }
        /// <summary>
        /// ReceiptDate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.DateTime? ReceiptDate { get; set; }

        /// <summary>
        /// StartDate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.DateTime StartDate { get; set; }

        /// <summary>
        /// EndDate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.DateTime EndDate { get; set; }

        /// <summary>
        /// SignedDate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.DateTime SignedDate { get; set; }

        /// <summary>
        /// SubmitDate : 
        /// </summary>
        public System.DateTime SubmitDate { get; set; }

        /// <summary>
        /// SalesChannelID : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? SalesChannelId { get; set; }

        /// <summary>
        /// SalesRep : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String SalesRep { get; set; }

        /// <summary>
        /// SalesManagerID : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? SalesManagerId { get; set; }

        /// <summary>
        /// DateCreated : 
        /// </summary>
        public System.DateTime DateCreated { get; set; }

        /// <summary>
        /// PricingTypeID : 
        /// </summary>
        public System.Int32? PricingTypeId { get; set; }

        /// <summary>
        /// ExternalNumber : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String ExternalNumber { get; set; }

        [System.Runtime.Serialization.DataMember]
        public System.Int32? EstimatedAnnualUsage { get; set; }

        /// <summary>
        /// Set this variable to the contract template
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String ContractVersion { get; set; }

        /// <summary>
        /// Modified : 
        /// </summary>
        public System.DateTime Modified { get; set; }

        /// <summary>
        /// ModifiedBy : 
        /// </summary>
        public System.Int32 ModifiedBy { get; set; }

        /// <summary>
        /// CreatedBy : 
        /// </summary>
        public System.Int32 CreatedBy { get; set; }

        /// <summary>
        /// DigitalSignature : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String DigitalSignature { get; set; }

        /// <summary>
        /// AffinityCode: This is the code that is passed from the refereral links.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String AffinityCode { get; set; }

        /// <summary>
        /// Client Submission Source
		/// SubmitClosedDeals = new Guid("05553978-8EE9-46FE-9E9E-F3071B6C5556");
		/// BatchUpload = new Guid("72C0FEAF-FED5-4580-89D2-D24F77E91934");
		/// ContractPrepopulation = new Guid("B011637F-FB7E-479B-8AFA-C37BC3973B49");
		/// OnlineEnrollment = new Guid("BDA11D91-7ADE-4DA1-855D-24ADFE39D174");
        /// </summary>
		 [System.Runtime.Serialization.DataMember]
		public System.Guid? ClientSubmitApplicationKey;

		public LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.ClientSubmitApplicationKey ClientSubmitApplicationKeyDetails { get; set; }

		public System.Int32? ClientSubmitApplicationKeyId { get; set; }

        #endregion

        #region Entity Properties

        public LibertyPower.Business.CustomerAcquisition.SalesChannel.SalesChannel SalesChannel { get; set; }

        public LibertyPower.Business.CommonBusiness.SecurityManager.User SalesManager { get; set; }

        [System.Runtime.Serialization.DataMember]
        public Enums.ContractDealType ContractDealType
        {
            get
            {
                return (Enums.ContractDealType) Enum.Parse( typeof( Enums.ContractDealType ), this._contractDealTypeId.ToString() );
            }

            set
            {
                this._contractDealTypeId = (int) value;
            }
        }

        public Enums.ContractStatus ContractStatus
        {
            get
            {
                return (Enums.ContractStatus) Enum.Parse( typeof( Enums.ContractStatus ), this._contractStatusId.ToString() );
            }

            set
            {
                this._contractStatusId = (int) value;
            }
        }

        [System.Runtime.Serialization.DataMember]
        public Enums.ContractTemplate ContractTemplate
        {
            get
            {
                return (Enums.ContractTemplate) Enum.Parse( typeof( Enums.ContractTemplate ), this._contractTemplateId.ToString() );
            }

            set
            {
                this._contractTemplateId = (int) value;
            }
        }

        [System.Runtime.Serialization.DataMember]
        public Enums.ContractType ContractType
        {
            get
            {
                return (Enums.ContractType) Enum.Parse( typeof( Enums.ContractType ), this._contractTypeId.ToString() );
            }

            set
            {
                this._contractTypeId = (int) value;
            }
        }

        [System.Runtime.Serialization.DataMember]
        public List<AccountContract> AccountContracts { get; set; }

        [System.Runtime.Serialization.DataMember]
        public List<DM.Document> Documents { get; set; }

        //[System.Runtime.Serialization.DataMember]
        //public List<ContractQualifier> ContractQualifiers { get; set; }

        [System.Runtime.Serialization.DataMember]
        public List<String> PromotionCodes { get; set; }

        [System.Runtime.Serialization.DataMember]
        public List<TabletDocument> TabletDocuments { get; set; }

        #endregion Entity Properties

        #region Properties

        public bool HasValidClientApplicationType
        {
            get
            {
                if (this.ClientSubmitApplicationKeyDetails == null)
                    return false;

                int clientAppTypeId = this.ClientSubmitApplicationKeyDetails.ClientApplicationTypeId;
                return Enum.IsDefined(typeof(Enums.ClientApplicationType), clientAppTypeId);
            }
        }

        public Enums.ClientApplicationType ClientApplicationType
        {
            get
            {
                if (this.ClientSubmitApplicationKeyDetails != null)
                {
                    int clientAppTypeId = this.ClientSubmitApplicationKeyDetails.ClientApplicationTypeId;
                    if (Enum.IsDefined(typeof(Enums.ClientApplicationType), clientAppTypeId))
                        return (Enums.ClientApplicationType)clientAppTypeId;
                }

                throw new InvalidOperationException("Contract has an invalid ClientSubmitApplicationKey for Application Type");
            }
        }

        public bool IsTabletContract
        {
            get
            {
                if (this.ClientSubmitApplicationKeyId == null)
                    throw new InvalidOperationException("ClientSubmitApplicationKeyId cannot be null.");

                return this.ClientApplicationType == Enums.ClientApplicationType.Tablet;
            }
        }

        public bool HasValidContractNumber
        {
            get
            {
                System.Text.RegularExpressions.Regex re = new System.Text.RegularExpressions.Regex("^[a-zA-Z0-9\\-]+$");
                //if Contract# format is valid set result=true else return result as false.

                return re.IsMatch(this.Number) && (this.Number.Trim().Replace("-", "") != "");
            }
        }

        #endregion

        #region Clone Method

        /// <summary>
        /// Creates a new object that is a copy of the current instance.
        /// </summary>
        /// <returns>A new object that is a copy of this instance.</returns>
        public Object Clone()
        {
            Contract _tmp = new Contract();
            _tmp.ContractId = this.ContractId;
            _tmp.Number = this.Number;
            _tmp.ContractTypeId = this.ContractTypeId;
            _tmp.ContractDealTypeId = this.ContractDealTypeId;
            _tmp.ContractStatusId = this.ContractStatusId;
            _tmp.ContractTemplateId = this.ContractTemplateId;
            _tmp.ReceiptDate = this.ReceiptDate;
            _tmp.StartDate = this.StartDate;
            _tmp.EndDate = this.EndDate;
            _tmp.SignedDate = this.SignedDate;
            _tmp.SubmitDate = this.SubmitDate;
            _tmp.SalesChannelId = this.SalesChannelId;
            _tmp.SalesRep = this.SalesRep;
            _tmp.SalesManagerId = this.SalesManagerId;
            _tmp.DateCreated = this.DateCreated;
            _tmp.PricingTypeId = this.PricingTypeId;
            _tmp.ExternalNumber = this.ExternalNumber;
            _tmp.DigitalSignature = this.DigitalSignature;
            _tmp.Modified = this.Modified;
            _tmp.ModifiedBy = this.ModifiedBy;
            _tmp.CreatedBy = this.CreatedBy;
            return _tmp;
        }
        #endregion Clone Method

        #region IValidator Members

        public bool IsStructureValidForInsert()
        {
            return true;
        }

        public bool IsStructureValidForUpdate()
        {
            return true;
        }

        public List<GenericError> IsValidForInsert()
        {
            List<GenericError> errors = new List<GenericError>();

            errors = this.IsValid();

            return errors;
        }

        public List<GenericError> IsValidForUpdate()
        {
            return new List<GenericError>();
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();

            if ( !this.HasValidContractNumber )
            {
                errors.Add(new GenericError() { Code = 0, Message = "Contract number should be Alpha, Numeric, or Alphanumeric and might contain the special character - (dash) as part of it" });
            }

            if( this.StartDate == DateTime.MinValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract Start Date is a required field" } );
            }

            if( this.EndDate == DateTime.MinValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract End Date is a required field" } );
            }

            if( this.StartDate >= this.EndDate )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract Start Date must be at least a day before end date" } );
            }

            if( this.SubmitDate == DateTime.MinValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract Submit Date is a required field" } );
            }

            if( this.SignedDate == DateTime.MinValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract Signed Date is a required field" } );
            }
            /*  Modified on:    30th jun 2015
                Modified by:    Manish Pandey
                Purpose:        To validate Contract#
                Discription:    for validating contract# not null or empty.
                Note:           this code was already there i have uncommented.
             */
            if (string.IsNullOrEmpty(this.Number) || this.Number.Trim().Length <= 0)
            {
                errors.Add(new GenericError() { Code = 0, Message = "Invalid Contract#." });
            }

            if( !this.SalesChannelId.HasValue || this.SalesChannelId.Value == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract Sales Channel Id is a required field" } );
            }

            if( !this.SalesManagerId.HasValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract SalesManagerId is missing" } );
            }

            if( !this.ContractDealTypeId.HasValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract DealType is a required field" } );
            }

            if( !this.ContractStatusId.HasValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract Status is a required field" } );
            }

            if( !this.ContractTypeId.HasValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract Type is a required field" } );
            }

            if( this.ContractType == Enums.ContractType.PAPER && (!this.ContractTemplateId.HasValue || this.ContractTemplateId.Value == 0) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract Template is a required field" } );
            }

            //if( !this.SubmitDate )
            //{
            //    errors.Add( new GenericError() { Code = 0, Message = "SubmitDate must have a valid value" } );
            //}

            if( this.ModifiedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract ModifiedBy must have a valid value" } );
            }

            if( this.CreatedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract CreatedBy must have a valid value" } );
            }

            if( String.IsNullOrEmpty( this.SalesRep ) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract SalesRep must have a valid value" } );
            }

            if( this.ContractTemplate == Enums.ContractTemplate.NotSet )
            {
                errors.Add( new GenericError() { Code = 0, Message = "Contract ContractTemplate must have a valid value" } );
            }

            if ( !this.HasValidClientApplicationType )
            {
                errors.Add(new GenericError() { Code = 0, Message = "Contract has an invalid ClientSubmitApplicationKey for Application Type" });
            }

            return errors;

        }
        #endregion

        #region Methods

        public void SetDefaultValues()
        {
            if( !this._contractDealTypeId.HasValue )
            {
                this.ContractDealType = Enums.ContractDealType.New;
            }

            if( !this._contractStatusId.HasValue )
            {
                this.ContractStatus = Enums.ContractStatus.PENDING;
            }

            if( !this._contractTemplateId.HasValue )
            {
                this.ContractTemplate = Enums.ContractTemplate.Normal;
            }

            if( !this._contractTypeId.HasValue )
            {
                this.ContractType = Enums.ContractType.PAPER;
            }

            if( this.SubmitDate == DateTime.MinValue )
            {
                this.SubmitDate = DateTime.Now;
            }

            if( this.ContractTemplate == Enums.ContractTemplate.NotSet )
            {
                this.ContractTemplate = Enums.ContractTemplate.Normal;
            }
        }        

        //Added on Sept 03 to get minimum contract renewal Start date
        public DateTime GetMinimumContractRenewalStartDate()
        {
            LibertyPower.Business.CustomerManagement.AccountManagement.Contract contract = null;

            try
            {


                contract = LibertyPower.Business.CustomerManagement.AccountManagement.ContractFactory.GetContractWithAccounts(LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.ContractDal.GetContractNumberfromContractID(this.AccountContracts[0].Account.CurrentContractId));
               
                return contract.MinimumContractRenewalStartDate;
            }
            catch
            {
                return DateTime.MinValue;
            }
        }

        #endregion
    }
}
