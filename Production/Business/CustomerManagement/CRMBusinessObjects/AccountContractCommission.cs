using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class AccountContractCommission : ICloneable, IValidator
    {
        #region Primary key(s)
        /// <summary>			
        /// AccountContractCommissionID : 
        /// </summary>
        /// <remarks>Member of the primary key of the underlying table "AccountContractCommission"</remarks>
        public System.Int32? AccountContractCommissionId { get; set; }

        #endregion

        #region Non Primary key(s)

        /// <summary>
        /// AccountContractID : 
        /// </summary>
        public System.Int32? AccountContractId { get; set; }

        /// <summary>
        /// EvergreenOptionID : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? EvergreenOptionId { get; set; }

        /// <summary>
        /// EvergreenCommissionEnd : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.DateTime? EvergreenCommissionEnd { get; set; }

        /// <summary>
        /// EvergreenCommissionRate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Double? EvergreenCommissionRate { get; set; }

        /// <summary>
        /// ResidualOptionID : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? ResidualOptionId { get; set; }

        /// <summary>
        /// ResidualCommissionEnd : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.DateTime? ResidualCommissionEnd { get; set; }

        /// <summary>
        /// InitialPymtOptionID : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? InitialPymtOptionId { get; set; }

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

        #region Clone Method

        /// <summary>
        /// Creates a new object that is a copy of the current instance.
        /// </summary>
        /// <returns>A new object that is a copy of this instance.</returns>
        public Object Clone()
        {
            AccountContractCommission _tmp = new AccountContractCommission();
            _tmp.AccountContractCommissionId = this.AccountContractCommissionId;
            _tmp.AccountContractId = this.AccountContractId;
            _tmp.EvergreenOptionId = this.EvergreenOptionId;
            _tmp.EvergreenCommissionEnd = this.EvergreenCommissionEnd;
            _tmp.EvergreenCommissionRate = this.EvergreenCommissionRate;
            _tmp.ResidualOptionId = this.ResidualOptionId;
            _tmp.ResidualCommissionEnd = this.ResidualCommissionEnd;
            _tmp.InitialPymtOptionId = this.InitialPymtOptionId;
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
            errors = IsValid();

            if( errors.Count > 0 )
                return errors;

            return errors;
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();
            return errors;
        }

        #endregion
    }
}
