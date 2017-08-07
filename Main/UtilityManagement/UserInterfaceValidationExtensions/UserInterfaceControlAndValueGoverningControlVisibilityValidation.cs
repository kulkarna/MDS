using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class UserInterfaceControlAndValueGoverningControlVisibilityValidation
    {
        #region public constructors
        public UserInterfaceControlAndValueGoverningControlVisibilityValidation(UserInterfaceControlAndValueGoverningControlVisibility userInterfaceControlAndValueGoverningControlVisibility)
        {
            PopulateValidationProperties(userInterfaceControlAndValueGoverningControlVisibility);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsUserInterfaceControlAndValueGoverningControlVisibilityNotNull { get; set; }
        bool IsUserInterfaceControlAndValueGoverningControlVisibilityCreatedByValid { get; set; }
        bool IsUserInterfaceControlAndValueGoverningControlVisibilityCreatedDateValid { get; set; }
        bool IsUserInterfaceControlAndValueGoverningControlVisibilityLastModifiedByValid { get; set; }
        bool IsUserInterfaceControlAndValueGoverningControlVisibilityLastModifiedDateValid { get; set; }

        bool IsUserInterfaceControlAndValueGoverningControlVisibilityUserInterfaceFormIdValid { get; set; }
        bool IsUserInterfaceControlAndValueGoverningControlVisibilityUserInterfaceFormControlGoverningVisibilityIdValid { get; set; }

        public bool IsValid
        {
            get
            {
                return IsUserInterfaceControlAndValueGoverningControlVisibilityNotNull &&
                    IsUserInterfaceControlAndValueGoverningControlVisibilityCreatedByValid &&
                    IsUserInterfaceControlAndValueGoverningControlVisibilityCreatedDateValid &&
                    IsUserInterfaceControlAndValueGoverningControlVisibilityLastModifiedByValid &&
                    IsUserInterfaceControlAndValueGoverningControlVisibilityLastModifiedDateValid &&
                    IsUserInterfaceControlAndValueGoverningControlVisibilityUserInterfaceFormIdValid &&
                    IsUserInterfaceControlAndValueGoverningControlVisibilityUserInterfaceFormControlGoverningVisibilityIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(UserInterfaceControlAndValueGoverningControlVisibility userInterfaceControlAndValueGoverningControlVisibility)
        {
            IsUserInterfaceControlAndValueGoverningControlVisibilityNotNull = userInterfaceControlAndValueGoverningControlVisibility != null;
            IsUserInterfaceControlAndValueGoverningControlVisibilityCreatedByValid = Common.IsValidString(userInterfaceControlAndValueGoverningControlVisibility.CreatedBy);
            IsUserInterfaceControlAndValueGoverningControlVisibilityCreatedDateValid = Common.IsValidDate(userInterfaceControlAndValueGoverningControlVisibility.CreatedDate);
            IsUserInterfaceControlAndValueGoverningControlVisibilityLastModifiedByValid = Common.IsValidString(userInterfaceControlAndValueGoverningControlVisibility.LastModifiedBy);
            IsUserInterfaceControlAndValueGoverningControlVisibilityLastModifiedDateValid = Common.IsValidDate(userInterfaceControlAndValueGoverningControlVisibility.LastModifiedDate);
            IsUserInterfaceControlAndValueGoverningControlVisibilityUserInterfaceFormIdValid = Common.IsValidGuid(userInterfaceControlAndValueGoverningControlVisibility.UserInterfaceFormId);
            IsUserInterfaceControlAndValueGoverningControlVisibilityUserInterfaceFormControlGoverningVisibilityIdValid = Common.IsValidGuid(userInterfaceControlAndValueGoverningControlVisibility.UserInterfaceFormControlGoverningVisibilityId);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsUserInterfaceControlAndValueGoverningControlVisibilityNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsUserInterfaceControlAndValueGoverningControlVisibilityCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsUserInterfaceControlAndValueGoverningControlVisibilityCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsUserInterfaceControlAndValueGoverningControlVisibilityLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsUserInterfaceControlAndValueGoverningControlVisibilityLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsUserInterfaceControlAndValueGoverningControlVisibilityUserInterfaceFormIdValid)
                message.Append("Invalid Value For Form! ");
            if (!IsUserInterfaceControlAndValueGoverningControlVisibilityUserInterfaceFormControlGoverningVisibilityIdValid)
                message.Append("Invalid Value For Control Governing Visibility! ");

            return message.ToString();
        }
        #endregion
    }
}