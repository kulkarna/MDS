using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class PromotionCode:IValidator
    {

        #region Primary key(s)
        [DataMember]
        public System.Int32 PromotionCodeId { get; set; }
        #endregion
        [DataMember]
        public System.Int32? PromotionTypeId { get; set; }
        [DataMember]
        public System.String Code { get; set; }
        [DataMember]
        public String Description { get; set; }
        [DataMember]
        public System.String MarketingDescription { get; set; }
        [DataMember]
        public System.String LegalDescription { get; set; }
        [DataMember]
        public System.Int32? CreatedBy { get; set; }
        [DataMember]
        public System.DateTime? CreatedDate { get; set; }
        [DataMember]
        public System.Boolean? InActive { get; set; }

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

            List<GenericError> errors = new List<GenericError>();

            if (this.Code.Trim() == "")
            {
                errors.Add(new GenericError() { Code = 0, Message = "Promotion Code must have a value" });
            }
            if (this.PromotionTypeId <= 0)
            {
                errors.Add(new GenericError() { Code = 1, Message = "Promotion Type Id must have a valid value" });
            }
            return errors;
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();


            if (this.CreatedBy == 0)
            {
                errors.Add(new GenericError() { Code = 0, Message = "Promotion Code CreatedBy must have a valid value" });
            }
            if (this.PromotionTypeId <= 0)
            {
                errors.Add(new GenericError() { Code = 1, Message = "Promotion Type Id must have a valid value" });
            }
            return errors;
        }
        #endregion
    }

}

