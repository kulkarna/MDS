using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class UserInterfaceFormValidation
    {
        #region public constructors
        public UserInterfaceFormValidation(UserInterfaceForm userInterfaceForm)
        {
            PopulateValidationProperties(userInterfaceForm);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsUserInterfaceFormNotNull { get; set; }
        bool IsUserInterfaceFormCreatedByValid { get; set; }
        bool IsUserInterfaceFormCreatedDateValid { get; set; }
        bool IsUserInterfaceFormLastModifiedByValid { get; set; }
        bool IsUserInterfaceFormLastModifiedDateValid { get; set; }
        bool IsUserInterfaceFormNameValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsUserInterfaceFormNotNull &&
                    IsUserInterfaceFormCreatedByValid &&
                    IsUserInterfaceFormCreatedDateValid &&
                    IsUserInterfaceFormLastModifiedByValid &&
                    IsUserInterfaceFormLastModifiedDateValid &&
                    IsUserInterfaceFormNameValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(UserInterfaceForm userInterfaceForm)
        {
            IsUserInterfaceFormNotNull = userInterfaceForm != null;
            IsUserInterfaceFormCreatedByValid = Common.IsValidString(userInterfaceForm.CreatedBy);
            IsUserInterfaceFormCreatedDateValid = Common.IsValidDate(userInterfaceForm.CreatedDate);
            IsUserInterfaceFormLastModifiedByValid = Common.IsValidString(userInterfaceForm.LastModifiedBy);
            IsUserInterfaceFormLastModifiedDateValid = Common.IsValidDate(userInterfaceForm.LastModifiedDate);
            IsUserInterfaceFormNameValid = Common.IsValidString(userInterfaceForm.UserInterfaceFormName);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsUserInterfaceFormNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsUserInterfaceFormCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsUserInterfaceFormCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsUserInterfaceFormLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsUserInterfaceFormLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsUserInterfaceFormNameValid)
                message.Append("Invalid Value For Name! ");

            return message.ToString();
        }
        #endregion
    }
}