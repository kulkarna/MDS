using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class LoadProfileValidation
    {
        #region public constructors
        public LoadProfileValidation(LoadProfile LoadProfile)
        {
            PopulateValidationProperties(LoadProfile);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsLoadProfileNotNull { get; set; }
        bool IsLoadProfileCreatedByValid { get; set; }
        bool IsLoadProfileCreatedDateValid { get; set; }
        bool IsLoadProfileLastModifiedByValid { get; set; }
        bool IsLoadProfileLastModifiedDateValid { get; set; }
        bool IsLoadProfileLoadProfileCodeValid { get; set; }
        bool IsLoadProfileLoadProfileIdValid { get; set; }
        bool IsLoadProfileDescriptionValid { get; set; }
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
                    IsLoadProfileLoadProfileCodeValid &&
                    IsLoadProfileDescriptionValid &&
                    IsLoadProfileUtilityCompanyIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(LoadProfile LoadProfile)
        {
            IsLoadProfileNotNull = LoadProfile != null;
            IsLoadProfileCreatedByValid = Common.IsValidString(LoadProfile.CreatedBy);
            IsLoadProfileCreatedDateValid = Common.IsValidDate(LoadProfile.CreatedDate);
            IsLoadProfileLastModifiedByValid = Common.IsValidString(LoadProfile.LastModifiedBy);
            IsLoadProfileLastModifiedDateValid = Common.IsValidDate(LoadProfile.LastModifiedDate);
            IsLoadProfileLoadProfileCodeValid = Common.IsValidString(LoadProfile.LoadProfileCode) && LoadProfile.LoadProfileCode.Length <= 255;
            IsLoadProfileDescriptionValid = Common.IsValidString(LoadProfile.Description) && LoadProfile.Description.Length <= 255;
            IsLoadProfileUtilityCompanyIdValid = Common.IsValidGuid(LoadProfile.UtilityCompanyId);
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
            if (!IsLoadProfileLoadProfileCodeValid)
                message.Append("Invalid Value For Load Profile Code! ");
            if (!IsLoadProfileDescriptionValid)
                message.Append("Invalid Value For Description! ");
            if (!IsLoadProfileUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");

            return message.ToString();
        }
        #endregion
    }
}