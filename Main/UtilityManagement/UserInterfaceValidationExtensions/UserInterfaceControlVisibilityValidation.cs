using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class UserInterfaceControlVisibilityValidation
    {
        #region public constructors
        public UserInterfaceControlVisibilityValidation(UserInterfaceControlVisibility userInterfaceControlVisibility)
        {
            PopulateValidationProperties(userInterfaceControlVisibility);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsUserInterfaceControlVisibilityNotNull { get; set; }
        bool IsUserInterfaceControlVisibilityCreatedByValid { get; set; }
        bool IsUserInterfaceControlVisibilityCreatedDateValid { get; set; }
        bool IsUserInterfaceControlVisibilityLastModifiedByValid { get; set; }
        bool IsUserInterfaceControlVisibilityLastModifiedDateValid { get; set; }

        bool IsUserInterfaceControlVisibilityUserInterfaceFormIdValid { get; set; }
        bool IsUserInterfaceControlVisibilityUserInterfaceFormControlIdValid { get; set; }
        bool IsuserInterfaceControlVisibilityUserInterfaceControlAndValueGoverningControlVisibilityIdValid { get; set; }

        public bool IsValid
        {
            get
            {
                return IsUserInterfaceControlVisibilityNotNull &&
                    IsUserInterfaceControlVisibilityCreatedByValid &&
                    IsUserInterfaceControlVisibilityCreatedDateValid &&
                    IsUserInterfaceControlVisibilityLastModifiedByValid &&
                    IsUserInterfaceControlVisibilityLastModifiedDateValid &&
                    IsUserInterfaceControlVisibilityUserInterfaceFormIdValid &&
                    IsUserInterfaceControlVisibilityUserInterfaceFormControlIdValid &&
                    IsuserInterfaceControlVisibilityUserInterfaceControlAndValueGoverningControlVisibilityIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(UserInterfaceControlVisibility userInterfaceControlVisibility)
        {
            IsUserInterfaceControlVisibilityNotNull = userInterfaceControlVisibility != null;
            IsUserInterfaceControlVisibilityCreatedByValid = Common.IsValidString(userInterfaceControlVisibility.CreatedBy);
            IsUserInterfaceControlVisibilityCreatedDateValid = Common.IsValidDate(userInterfaceControlVisibility.CreatedDate);
            IsUserInterfaceControlVisibilityLastModifiedByValid = Common.IsValidString(userInterfaceControlVisibility.LastModifiedBy);
            IsUserInterfaceControlVisibilityLastModifiedDateValid = Common.IsValidDate(userInterfaceControlVisibility.LastModifiedDate);
            IsUserInterfaceControlVisibilityUserInterfaceFormIdValid = Common.IsValidGuid(userInterfaceControlVisibility.UserInterfaceFormId);
            IsUserInterfaceControlVisibilityUserInterfaceFormControlIdValid = Common.IsValidGuid(userInterfaceControlVisibility.UserInterfaceFormControlId);
            IsuserInterfaceControlVisibilityUserInterfaceControlAndValueGoverningControlVisibilityIdValid = Common.IsValidGuid(userInterfaceControlVisibility.UserInterfaceControlAndValueGoverningControlVisibilityId); 
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsUserInterfaceControlVisibilityNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsUserInterfaceControlVisibilityCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsUserInterfaceControlVisibilityCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsUserInterfaceControlVisibilityLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsUserInterfaceControlVisibilityLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsUserInterfaceControlVisibilityUserInterfaceFormIdValid)
                message.Append("Invalid Value For Form! ");
            if (!IsUserInterfaceControlVisibilityUserInterfaceFormControlIdValid)
                message.Append("Invalid Value For Control! ");
            if (!IsuserInterfaceControlVisibilityUserInterfaceControlAndValueGoverningControlVisibilityIdValid)
                message.Append("Invalid Value For Control Visibility! ");

            return message.ToString();
        }
        #endregion
    }
}