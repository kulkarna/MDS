using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class UserInterfaceFormControlValidation
    {
        #region public constructors
        public UserInterfaceFormControlValidation(UserInterfaceFormControl userInterfaceFormControl)
        {
            PopulateValidationProperties(userInterfaceFormControl);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsUserInterfaceFormControlNotNull { get; set; }
        bool IsUserInterfaceFormControlCreatedByValid { get; set; }
        bool IsUserInterfaceFormControlCreatedDateValid { get; set; }
        bool IsUserInterfaceFormControlLastModifiedByValid { get; set; }
        bool IsUserInterfaceFormControlLastModifiedDateValid { get; set; }
        bool IsUserInterfaceFormControUserInterfaceFormIdValid { get; set; }
        bool IsUserInterfaceFormControlNameValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsUserInterfaceFormControlNotNull &&
                    IsUserInterfaceFormControlCreatedByValid &&
                    IsUserInterfaceFormControlCreatedDateValid &&
                    IsUserInterfaceFormControlLastModifiedByValid &&
                    IsUserInterfaceFormControlLastModifiedDateValid &&
                    IsUserInterfaceFormControUserInterfaceFormIdValid &&
                    IsUserInterfaceFormControlNameValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(UserInterfaceFormControl userInterfaceFormControl)
        {
            IsUserInterfaceFormControlNotNull = userInterfaceFormControl != null;
            IsUserInterfaceFormControlCreatedByValid = Common.IsValidString(userInterfaceFormControl.CreatedBy);
            IsUserInterfaceFormControlCreatedDateValid = Common.IsValidDate(userInterfaceFormControl.CreatedDate);
            IsUserInterfaceFormControlLastModifiedByValid = Common.IsValidString(userInterfaceFormControl.LastModifiedBy);
            IsUserInterfaceFormControlLastModifiedDateValid = Common.IsValidDate(userInterfaceFormControl.LastModifiedDate);
            IsUserInterfaceFormControUserInterfaceFormIdValid = Common.IsValidGuid(userInterfaceFormControl.UserInterfaceFormId);
            IsUserInterfaceFormControlNameValid = Common.IsValidString(userInterfaceFormControl.ControlName);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsUserInterfaceFormControlNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsUserInterfaceFormControlCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsUserInterfaceFormControlCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsUserInterfaceFormControlLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsUserInterfaceFormControlLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsUserInterfaceFormControUserInterfaceFormIdValid)
                message.Append("Invalid Value For Form! ");
            if (!IsUserInterfaceFormControlNameValid)
                message.Append("Invalid Value For Control Name! ");

            return message.ToString();
        }
        #endregion
    }
}