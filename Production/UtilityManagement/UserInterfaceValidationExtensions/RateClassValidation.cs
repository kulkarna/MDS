using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class RateClassValidation
    {
        #region public constructors
        public RateClassValidation(RateClass rateClass)
        {
            PopulateValidationProperties(rateClass);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsRateClassNotNull { get; set; }
        bool IsRateClassCreatedByValid { get; set; }
        bool IsRateClassCreatedDateValid { get; set; }
        bool IsRateClassLastModifiedByValid { get; set; }
        bool IsRateClassLastModifiedDateValid { get; set; }
        bool IsRateClassRateClassCodeValid { get; set; }
        bool IsRateClassDescriptionValid { get; set; }
        bool IsRateClassUtilityCompanyIdValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsRateClassNotNull &&
                    IsRateClassCreatedByValid &&
                    IsRateClassCreatedDateValid &&
                    IsRateClassLastModifiedByValid &&
                    IsRateClassLastModifiedDateValid &&
                    IsRateClassRateClassCodeValid &&
                    IsRateClassDescriptionValid &&
                    IsRateClassUtilityCompanyIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(RateClass rateClass)
        {
            IsRateClassNotNull = rateClass != null;
            IsRateClassCreatedByValid = Common.IsValidString(rateClass.CreatedBy);
            IsRateClassCreatedDateValid = Common.IsValidDate(rateClass.CreatedDate);
            IsRateClassLastModifiedByValid = Common.IsValidString(rateClass.LastModifiedBy);
            IsRateClassLastModifiedDateValid = Common.IsValidDate(rateClass.LastModifiedDate);
            IsRateClassRateClassCodeValid = Common.IsValidString(rateClass.RateClassCode) && rateClass.RateClassCode.Length <= 255;
            IsRateClassDescriptionValid = Common.IsValidString(rateClass.Description) && rateClass.Description.Length <= 255;
            IsRateClassUtilityCompanyIdValid = Common.IsValidGuid(rateClass.UtilityCompanyId);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsRateClassNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsRateClassCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsRateClassCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsRateClassLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsRateClassLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsRateClassRateClassCodeValid)
                message.Append("Invalid Value For Meter Type Code! ");
            if (!IsRateClassDescriptionValid)
                message.Append("Invalid Value For Description! ");
            if (!IsRateClassUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");

            return message.ToString();
        }
        #endregion
    }
}