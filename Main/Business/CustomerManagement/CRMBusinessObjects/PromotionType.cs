using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class PromotionType : IValidator
    {

        #region Primary key(s)
        [DataMember]
        public System.Int32 PromotionTypeId { get; set; }
        #endregion
        [DataMember]
        public System.String Code { get; set; }
        [DataMember]
        public String Description { get; set; }
        [DataMember]
        public System.Int32? CreatedBy { get; set; }
        [DataMember]
        public System.DateTime? CreatedDate { get; set; }

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

            return errors;
        }

        public List<GenericError> IsValidForUpdate()
        {
            List<GenericError> errors = new List<GenericError>();

            if (string.IsNullOrEmpty(this.Code))
            {
                errors.Add(new GenericError() { Code = 0, Message = "Promotion Type Code must have a value" });
            }

            if (string.IsNullOrEmpty(this.Description))
            {
                errors.Add(new GenericError() { Code = 1, Message = "Promotion Type Description must have a valid value" });
            }

            return errors;
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = IsValidForUpdate();

            if (this.CreatedBy == 0)
            {
                errors.Add(new GenericError() { Code = 0, Message = "Promotion Type CreatedBy must have a valid value" });
            }

            if (this.CreatedDate == null || this.CreatedDate == DateTime.MinValue)
            {
                errors.Add(new GenericError() { Code = 1, Message = "Promotion Type CreatedDate must have a valid value" });
            }

            return errors;
        }

        #endregion
    }
}
