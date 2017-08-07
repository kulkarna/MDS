using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class AccountContract : ICloneable, IValidator
    {
        #region Fields

        List<AccountContractRate> accountContractRates;

        #endregion

        #region Primary key(s)
        /// <summary>			
        /// AccountContractID : 
        /// </summary>
        /// <remarks>Member of the primary key of the underlying table "AccountContract"</remarks>
        public System.Int32? AccountContractId { get; set; }

        #endregion

        #region Non Primary key(s)

        /// <summary>
        /// AccountID : 
        /// </summary>
        public System.Int32? AccountId { get; set; }

        /// <summary>
        /// ContractID : 
        /// </summary>
        public System.Int32? ContractId { get; set; }

        /// <summary>
        /// RequestedStartDate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.DateTime? RequestedStartDate { get; set; }

        /// <summary>
        /// SendEnrollmentDate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.DateTime? SendEnrollmentDate { get; set; }

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

        /// <summary>
        /// LLC Capacity Factor :
        /// </summary>
        public System.Decimal? LccCapacityFactor { get; set; }

        #endregion

        #region Entity Properties

        [System.Runtime.Serialization.DataMember]
        public Account Account { get; set; }

        public Contract Contract { get; set; }

        [System.Runtime.Serialization.DataMember]
        public AccountContractCommission AccountContractCommission { get; set; }

        [System.Runtime.Serialization.DataMember]
        public List<AccountContractRate> AccountContractRates
        {
            get
            {
                if( accountContractRates == null )
                {
                    accountContractRates = new List<AccountContractRate>();
                }
                return accountContractRates;
            }
            set
            {
                accountContractRates = value;
            }
        }

        [System.Runtime.Serialization.DataMember]
        public AccountStatus AccountStatus { get; set; }

        #endregion Entity Properties

        #region Clone Method

        /// <summary>
        /// Creates a new object that is a copy of the current instance.
        /// </summary>
        /// <returns>A new object that is a copy of this instance.</returns>
        public Object Clone()
        {
            AccountContract _tmp = new AccountContract();

            _tmp.AccountContractId = this.AccountContractId;

            _tmp.AccountId = this.AccountId;
            _tmp.ContractId = this.ContractId;
            _tmp.RequestedStartDate = this.RequestedStartDate;
            _tmp.SendEnrollmentDate = this.SendEnrollmentDate;
            _tmp.Modified = this.Modified;
            _tmp.ModifiedBy = this.ModifiedBy;
            _tmp.DateCreated = this.DateCreated;
            _tmp.CreatedBy = this.CreatedBy;

            return _tmp;
        }

        #endregion Clone Method

        #region IValidator Members

        public bool IsStructureValidForInsert()
        {
            if( this.AccountContractCommission == null )
                return false;

            if( this.AccountContractRates == null || this.AccountContractRates.Count <= 0 )
                return false;

            if( this.AccountStatus == null )
                return false;

            return true;
        }

        public bool IsStructureValidForUpdate()
        {
            return true;
        }

        public List<GenericError> IsValidForInsert()
        {
            List<GenericError> errors = new List<GenericError>();
            errors = IsValid();

            if( errors.Count > 0 )
                return errors;

            return errors;
        }

        public List<GenericError> IsValidForUpdate()
        {
            List<GenericError> errors = new List<GenericError>();

            return errors;
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();

            if( this.AccountStatus == null )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountContract: AccountStatus must be a valid object" } );
            }

            //TODO: move this were it belongs WTF is this?? cross object validation rule ???
            //if( this.AccountContractCommission == null && this.Contract.ContractDealType == Enums.ContractDealType.New )
            //{
            //    errors.Add( new GenericError() { Code = 0, Message = "AccountContract: AccountContractCommission must be a valid object" } );
            //}

            if( this.AccountContractRates == null || this.AccountContractRates.Count <= 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountContract: AccountContractRates must be a valid object" } );
            }

            if( !this.AccountId.HasValue && this.Account == null )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountContract: AccountId must have a valid value" } );
            }

            //if( !this.ContractId.HasValue && this.Contract == null )
            //{
            //    errors.Add( new GenericError() { Code = 0, Message = "AccountContract: ContractId must have a valid value" } );
            //}

            if( this.ModifiedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountContract: ModifiedBy must have a valid value" } );
            }

            if( this.CreatedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountContract: CreatedBy must have a valid value" } );
            }

            return errors;
        }

        #endregion
    }
}
