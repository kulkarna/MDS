using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class LpStandardLoadProfileValidation
    {
        #region public constructors
        public LpStandardLoadProfileValidation(LpStandardLoadProfile lpStandardLoadProfile)
        {
            PopulateValidationProperties(lpStandardLoadProfile);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsLoadProfileNotNull { get; set; }
        bool IsLoadProfileCreatedByValid { get; set; }
        bool IsLoadProfileCreatedDateValid { get; set; }
        bool IsLoadProfileLastModifiedByValid { get; set; }
        bool IsLoadProfileLastModifiedDateValid { get; set; }
        bool IsLpStandardLoadProfileLoadProfileCodeValid { get; set; }
        bool IsLoadProfileUtilityCompanyIdValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsLoadProfileNotNull &&
                    IsLoadProfileCreatedByValid &&
                    IsLoadProfileCreatedDateValid &&
                    IsLoadProfileLastModifiedByValid &&
                    IsLoadProfileLastModifiedDateValid &&
                    IsLpStandardLoadProfileLoadProfileCodeValid &&
                    IsLoadProfileUtilityCompanyIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(LpStandardLoadProfile lpStandardLoadProfile)
        {
            IsLoadProfileNotNull = lpStandardLoadProfile != null;
            IsLoadProfileCreatedByValid = Common.IsValidString(lpStandardLoadProfile.CreatedBy);
            IsLoadProfileCreatedDateValid = Common.IsValidDate(lpStandardLoadProfile.CreatedDate);
            IsLoadProfileLastModifiedByValid = Common.IsValidString(lpStandardLoadProfile.LastModifiedBy);
            IsLoadProfileLastModifiedDateValid = Common.IsValidDate(lpStandardLoadProfile.LastModifiedDate);
            IsLpStandardLoadProfileLoadProfileCodeValid = Common.IsValidString(lpStandardLoadProfile.LpStandardLoadProfileCode);
            IsLoadProfileUtilityCompanyIdValid = Common.IsValidGuid(lpStandardLoadProfile.UtilityCompanyId);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsLoadProfileNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsLoadProfileCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsLoadProfileCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsLoadProfileLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsLoadProfileLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsLpStandardLoadProfileLoadProfileCodeValid)
                message.Append("Invalid Value For LP Standard Rate Class Code! ");
            if (!IsLoadProfileUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");

            return message.ToString();
        }
        #endregion
    }
}