using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class LpStandardRateClassValidation
    {
        #region public constructors
        public LpStandardRateClassValidation(LpStandardRateClass lpStandardRateClass)
        {
            PopulateValidationProperties(lpStandardRateClass);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsRateClassNotNull { get; set; }
        bool IsRateClassCreatedByValid { get; set; }
        bool IsRateClassCreatedDateValid { get; set; }
        bool IsRateClassLastModifiedByValid { get; set; }
        bool IsRateClassLastModifiedDateValid { get; set; }
        bool IsLpStandardRateClassRateClassCodeValid { get; set; }
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
                    IsLpStandardRateClassRateClassCodeValid &&
                    IsRateClassUtilityCompanyIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(LpStandardRateClass lpStandardRateClass)
        {
            IsRateClassNotNull = lpStandardRateClass != null;
            IsRateClassCreatedByValid = Common.IsValidString(lpStandardRateClass.CreatedBy);
            IsRateClassCreatedDateValid = Common.IsValidDate(lpStandardRateClass.CreatedDate);
            IsRateClassLastModifiedByValid = Common.IsValidString(lpStandardRateClass.LastModifiedBy);
            IsRateClassLastModifiedDateValid = Common.IsValidDate(lpStandardRateClass.LastModifiedDate);
            IsLpStandardRateClassRateClassCodeValid = Common.IsValidString(lpStandardRateClass.LpStandardRateClassCode);
            IsRateClassUtilityCompanyIdValid = Common.IsValidGuid(lpStandardRateClass.UtilityCompanyId);
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
            if (!IsLpStandardRateClassRateClassCodeValid)
                message.Append("Invalid Value For LP Standard Rate Class Code! ");
            if (!IsRateClassUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");

            return message.ToString();
        }
        #endregion
    }
}