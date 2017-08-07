using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class CampaignCode : IValidator
    {

        #region Primary key(s)
        [DataMember]
        public System.Int32 CampaignId { get; set; }
        #endregion
        [DataMember]
        public System.String Code { get; set; }
        [DataMember]
        public String Description { get; set; }
        [DataMember]
        public System.DateTime? StartDate { get; set; }
        [DataMember]
        public System.DateTime? EndDate { get; set; }
        [DataMember]
        public System.Int32? MaxEligible { get; set; }
        [DataMember]
        public System.Int32? CreatedBy { get; set; }
        [DataMember]
        public System.DateTime? CreatedDate { get; set; }
        [DataMember]
        public System.Boolean? InActive { get; set; }

        public CampaignFulfillment CampaignFulfillmentDetails { get; set; }

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
                errors.Add(new GenericError() { Code = 0, Message = "Campaign Code must have a value" });
            }
            
            return errors;
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();

            if (this.Code.Trim() == "")
            {
                errors.Add(new GenericError() { Code = 0, Message = "Campaign Code must have a value" });
            }
            
            if (this.CreatedBy == 0)
            {
                errors.Add(new GenericError() { Code = 1, Message = "CreatedBy must have a valid value" });
            }
            
            return errors;
        }
        #endregion
    }
}
