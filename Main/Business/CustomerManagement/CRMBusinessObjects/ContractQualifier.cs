using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class ContractQualifier : ICloneable, IValidator
    {
        #region Primary key(s)
        public System.Int32 ContractQualifierId { get; set; }

        public System.Int32 ContractId { get; set; }
        public System.Int32? AccountId { get; set; }
        public System.Int32 QualifierId { get; set; }
      //  public System.Int32 PromotionStatusID { get; set; }
        public System.String Comment { get; set; }
        public System.Int32 CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public System.Int32 ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
       
        private System.Int32 _PromotionStatusID;

        public System.Int32 PromotionStatusID
        {
            get
            {
                return this._PromotionStatusID;
            }

            set
            {
                Enums.PromotionStatus tempType;
                if(  Enum.TryParse<Enums.PromotionStatus>( value.ToString(), out tempType ) )
                {
                    this._PromotionStatusID = value;
                }
                else
                {
                    throw new ArgumentOutOfRangeException( "The value is outside the valid range of values of Enums.ContractDealType" );
                }
            }
        }

           public Enums.PromotionStatus PromotionStatus
        {
            get
            {
                return (Enums.PromotionStatus) Enum.Parse( typeof( Enums.PromotionStatus ), this._PromotionStatusID.ToString() );
            }

            set
            {
                this._PromotionStatusID = (int) value;
            }
        }


        #endregion


        
        #region Constructors

           public ContractQualifier()
        {
            SetDefaultValues();
        }

        /// <summary>
        /// Sets the class' default values, it is called on object construction, but it is also used in WCF implementation
        /// </summary>
        public void SetDefaultValues()
        {
            this.PromotionStatus=Enums.PromotionStatus.Pending;
             this.CreatedDate = DateTime.Now;
             this.ModifiedDate = DateTime.Now;

        }

        #endregion

        #region Clone Method

        /// <summary>
        /// Creates a new object that is a copy of the current instance.
        /// </summary>
        /// <returns>A new object that is a copy of this instance.</returns>
        public Object Clone()
        {
            ContractQualifier _tmp = new ContractQualifier();

            _tmp.ContractQualifierId = this.ContractQualifierId;
            _tmp.ContractId = this.ContractId;
            _tmp.AccountId = this.AccountId;
            _tmp.QualifierId = this.QualifierId;
            _tmp.PromotionStatusID = this.PromotionStatusID;
            _tmp.Comment = this.Comment;           
            _tmp.CreatedBy = this.CreatedBy;
            _tmp.CreatedDate = this.CreatedDate;
            _tmp.ModifiedBy = this.ModifiedBy;
            _tmp.ModifiedDate = this.ModifiedDate;
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
            errors = IsValid();

            if (errors.Count > 0)
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

            if (this.PromotionStatusID == 0)
            {
                errors.Add(new GenericError() { Code = 0, Message = "ContractQualifier: ContractQualifier  must have a valid status" });
            }


            if (this.CreatedBy == 0)
            {
                errors.Add(new GenericError() { Code = 0, Message = "ContractQualifier: CreatedBy must have a valid value" });
            }
            if (this.ModifiedBy == 0)
            {
                errors.Add(new GenericError() { Code = 0, Message = "ContractQualifier: ModifiedBy must have a valid value" });
            }

            return errors;
        }

        #endregion
    }   
}
