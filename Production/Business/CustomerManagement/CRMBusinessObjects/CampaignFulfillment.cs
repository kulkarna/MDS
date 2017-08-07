using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class CampaignFulfillment : IValidator
    {

        #region Primary key(s)
        [DataMember]
        public System.Int32 CampaignFulfillmentId { get; set; }
        #endregion
        [DataMember]
        public System.Int32 CampaignId { get; set; }
        [DataMember]
        public System.Int32? TriggerTypeId { get; set; }
        [DataMember]
        public System.Int32? EligibilityPeriod { get; set; }
        [DataMember]
        public System.Int32? CreatedBy { get; set; }
        [DataMember]
        public System.DateTime? CreatedDate { get; set; }
        [DataMember]
        public System.Int32? ModifiedBy { get; set; }
        [DataMember]
        public System.DateTime? ModifiedDate { get; set; }


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

            if (this.CampaignId <= 0 )
            {
                errors.Add(new GenericError() { Code = 0, Message = "Campaign Code must be selected" });
            }
           
            return errors;
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();

            if (this.CampaignId <= 0)
            {
                errors.Add(new GenericError() { Code = 0, Message = "Campaign Code must be selected" });
            }

            return errors;
        }
        #endregion
    }
}
