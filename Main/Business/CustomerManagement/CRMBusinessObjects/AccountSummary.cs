using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class AccountSummary : ICloneable, IValidator
    {
        #region Constructors

        public AccountSummary()
        {
        }

        #endregion

        #region Primary key(s)

        public string AccountNumber { get; set; }

        #endregion

        #region Non Primary key(s)

        public string AccountStatus { get; set; }

        public DateTime? ContractEndDate { get; set; }

        public string ProductCode { get; set; }

        public int UtilityID { get; set; }

        public string SalesChannelName { get; set; }

        public bool DefaultVariable { get; set; }

        public DateTime? AccountLatestServiceEndDate { get; set; }

        public bool IsFlex { get; set; }
        public string ContractNumber{get;set;}
        public int Channel{get;set;}
        public string EnrollmentStatus{get;set;}
        public string EnrollmentSubStatus{get;set;}
        public string UtilityCode { get; set; }
        #endregion

        #region Clone Method

        /// <summary>
        /// Creates a new object that is a copy of the current instance.
        /// </summary>
        /// <returns>A new object that is a copy of this instance.</returns>
        public Object Clone()
        {
            AccountSummary clone = new AccountSummary();

            clone.AccountNumber = this.AccountNumber;
            clone.AccountStatus = this.AccountStatus;
            clone.ContractEndDate = this.ContractEndDate;
            clone.ProductCode = this.ProductCode;
            clone.UtilityID = this.UtilityID;
            clone.SalesChannelName = this.SalesChannelName;
            clone.ContractNumber = this.ContractNumber;
            clone.Channel = this.Channel;
            clone.EnrollmentStatus = this.EnrollmentStatus;
            clone.EnrollmentSubStatus = this.EnrollmentSubStatus;
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

            if (string.IsNullOrWhiteSpace(this.AccountStatus))
                errors.Add(new GenericError() { Code = 0, Message = "AccountSummary: AccountStatus is a required field" });

            if (this.ContractEndDate != null && this.ContractEndDate != DateTime.MinValue)
                errors.Add(new GenericError() { Code = 0, Message = "AccountSummary: ContractEndDate is a required field" });

            if (string.IsNullOrWhiteSpace(this.ProductCode))
                errors.Add(new GenericError() { Code = 0, Message = "AccountSummary: ProductCode is a required field" });

            if (this.UtilityID >= 0)
                errors.Add(new GenericError() { Code = 0, Message = "AccountSummary: UtilityID is a required field" });

            return errors;
        }

        #endregion
    }
}
