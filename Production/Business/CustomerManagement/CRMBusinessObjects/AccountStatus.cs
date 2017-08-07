using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    public class AccountStatus : ICloneable, IValidator
    {
        #region Primary key(s)
        /// <summary>			
        /// AccountStatusID : 
        /// </summary>
        /// <remarks>Member of the primary key of the underlying table "AccountStatus"</remarks>
        public System.Int32? AccountStatusId { get; set; }

        #endregion

        #region Non Primary key(s)

        /// <summary>
        /// AccountContractID : 
        /// </summary>
        public System.Int32? AccountContractId { get; set; }

        /// <summary>
        /// Status : 
        /// </summary>
        public System.String Status { get; set; }

        /// <summary>
        /// SubStatus : 
        /// </summary>
        public System.String SubStatus { get; set; }

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
            AccountStatus _tmp = new AccountStatus();
            _tmp.AccountStatusId = this.AccountStatusId;
            _tmp.AccountContractId = this.AccountContractId;
            _tmp.Status = this.Status;
            _tmp.SubStatus = this.SubStatus;
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

            //TODO: room to validate better status codes

            if( string.IsNullOrEmpty( this.Status ) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountStatus: Status must have a valid value" } );
            }

            if( string.IsNullOrEmpty( this.SubStatus ) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountStatus: Sub Status must have a valid value" } );
            }

            if( this.ModifiedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountStatus: ModifiedBy must have a valid value" } );
            }

            if( this.CreatedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountStatus: CreatedBy must have a valid value" } );
            }

            return errors;
        }





        #endregion

        #region Properties

        public bool IsActive
        {
            get
            {
                return !((this.Status.Trim() == LibertyPower.Business.CustomerManagement.AccountManagement.EnrollmentStatus.GetValue( LibertyPower.Business.CustomerManagement.AccountManagement.EnrollmentStatus.Status.NotEnrolled )
                    || this.Status.Trim() == LibertyPower.Business.CustomerManagement.AccountManagement.EnrollmentStatus.GetValue( LibertyPower.Business.CustomerManagement.AccountManagement.EnrollmentStatus.Status.EnrollmentCancelled ))
                    && this.SubStatus.Trim() == "10");
            }
        }


        #endregion
    }

}
