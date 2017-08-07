using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class AccountStatusSummary : ICloneable, IValidator
    {
        #region Constructors

        public AccountStatusSummary()
        {
        }

        #endregion

        #region Primary key(s)

        public string AccountNumber { get; set; }

        public int UtilityID { get; set; }

        #endregion

        #region Non Primary key(s)

        public int StatusID { get; set; }
        public DateTime? ContractEndDate{get;set;}
        public string ContractNumber { get; set; }
        public int Channel { get; set; }
        public string EnrollmentStatus { get; set; }
        public string EnrollmentSubStatus { get; set; }
        public DateTime? DeEnrollmentDate { get; set; }
        public string UtilityCode { get; set; }
        #endregion

        #region Clone Method

        /// <summary>
        /// Creates a new object that is a copy of the current instance.
        /// </summary>
        /// <returns>A new object that is a copy of this instance.</returns>
        public Object Clone()
        {
            AccountStatusSummary clone = new AccountStatusSummary();

            clone.AccountNumber = this.AccountNumber;
            clone.UtilityID = this.UtilityID;
            clone.StatusID = this.StatusID;
            clone.ContractEndDate = this.ContractEndDate;
            clone.ContractNumber = this.ContractNumber;
            clone.Channel = this.Channel;
            clone.EnrollmentStatus = this.EnrollmentStatus;
            clone.EnrollmentSubStatus = this.EnrollmentSubStatus;
            clone.DeEnrollmentDate = this.DeEnrollmentDate;
            clone.UtilityCode = this.UtilityCode;
            
            return clone;
        }

        #endregion Clone Method

        #region IValidator Members

        public bool IsStructureValidForInsert()
        {
            return false;
        }

        public bool IsStructureValidForUpdate()
        {
            return false;
        }

        public List<GenericError> IsValidForInsert()
        {
            List<GenericError> errors = new List<GenericError>();
            errors = this.IsValid();
            return new List<GenericError>();
        }

        public List<GenericError> IsValidForUpdate()
        {
            return new List<GenericError>();
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();

            if (string.IsNullOrWhiteSpace(this.AccountNumber))
                errors.Add(new GenericError() { Code = 0, Message = "AccountSummary: AccountNumber is a required field" });

            if (this.UtilityID >= 0)
                errors.Add(new GenericError() { Code = 0, Message = "AccountSummary: UtilityID is a required field" });

            if (this.StatusID >= 0)
                errors.Add(new GenericError() { Code = 0, Message = "AccountSummary: StatusID is a required field" });

            return errors;
        }

        #endregion
    }
}
