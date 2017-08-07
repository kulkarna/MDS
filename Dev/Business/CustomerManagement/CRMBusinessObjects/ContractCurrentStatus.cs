using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class ContractCurrentStatus: ICloneable, IValidator
    {
        #region Constructors

        public ContractCurrentStatus()
        {

        }

        #endregion

        #region Primary key(s)

        public string ContractNumber { get; set; }

        #endregion

        #region Non Primary key(s)

        public DateTime? SignedDate { get; set; }

        public string CustomerName { get; set; }

        public string Status { get; set; }

        public string ContractType { get; set; }

        public string Notes { get; set; }

        #endregion

        #region Clone Method

        /// <summary>
        /// Creates a new object that is a copy of the current instance.
        /// </summary>
        /// <returns>A new object that is a copy of this instance.</returns>
        public Object Clone()
        {
            ContractCurrentStatus clone = new ContractCurrentStatus();

            clone.ContractNumber = this.ContractNumber;
            clone.SignedDate = this.SignedDate;
            clone.CustomerName = this.CustomerName;
            clone.Status = this.Status;
            clone.ContractType = this.ContractType;
            clone.Notes = this.Notes;

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

            if (string.IsNullOrWhiteSpace(this.ContractNumber))
                errors.Add(new GenericError() { Code = 0, Message = "ContractCurrentStatus: ContractNumber is a required field" });

            if (string.IsNullOrWhiteSpace(this.Status))
                errors.Add(new GenericError() { Code = 0, Message = "ContractCurrentStatus: Status is a required field" });

            return errors;
        }

        #endregion
    }
}
