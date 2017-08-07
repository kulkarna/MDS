using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class AccountInfoFieldValidation
    {
        #region public constructors
        public AccountInfoFieldValidation(AccountInfoField accountInfoField)
        {
            PopulateValidationProperties(accountInfoField);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsAccountInfoFieldNotNull { get; set; }
        bool IsAccountInfoFieldCreatedByValid { get; set; }
        bool IsAccountInfoFieldCreatedDateValid { get; set; }
        bool IsAccountInfoFieldLastModifiedByValid { get; set; }
        bool IsAccountInfoFieldLastModifiedDateValid { get; set; }
        bool IsAccountInfoFieldNameUserFriendlyValid { get; set; }
        bool IsAccountInfoFieldNameMachineUnfriendlyValid { get; set; }
        bool IsAccountInfoFieldDescriptionValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsAccountInfoFieldNotNull &&
                    IsAccountInfoFieldNameUserFriendlyValid &&
                    IsAccountInfoFieldCreatedByValid &&
                    IsAccountInfoFieldCreatedDateValid &&
                    IsAccountInfoFieldLastModifiedByValid &&
                    IsAccountInfoFieldLastModifiedDateValid &&
                    IsAccountInfoFieldNameMachineUnfriendlyValid &&
                    IsAccountInfoFieldDescriptionValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(AccountInfoField accountInfoField)
        {
            IsAccountInfoFieldNotNull = accountInfoField != null;
            IsAccountInfoFieldCreatedByValid = Common.IsValidString(accountInfoField.CreatedBy);
            IsAccountInfoFieldCreatedDateValid = Common.IsValidDate(accountInfoField.CreatedDate);
            IsAccountInfoFieldLastModifiedByValid = Common.IsValidString(accountInfoField.LastModifiedBy);
            IsAccountInfoFieldLastModifiedDateValid = Common.IsValidDate(accountInfoField.LastModifiedDate);
            IsAccountInfoFieldNameMachineUnfriendlyValid = Common.IsValidString(accountInfoField.NameMachineUnfriendly);
            IsAccountInfoFieldDescriptionValid = Common.IsValidString(accountInfoField.Description);
            IsAccountInfoFieldNameUserFriendlyValid = Common.IsValidString(accountInfoField.NameUserFriendly);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsAccountInfoFieldNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsAccountInfoFieldCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsAccountInfoFieldCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsAccountInfoFieldLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsAccountInfoFieldLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsAccountInfoFieldNameUserFriendlyValid)
                message.Append("Invalid Value For User Friendly Name! ");
            if (!IsAccountInfoFieldDescriptionValid)
                message.Append("Invalid Value For Description! ");
            if (!IsAccountInfoFieldNameMachineUnfriendlyValid)
                message.Append("Invalid Value Unfriendly Machine Name! ");

            return message.ToString();
        }
        #endregion
    }
}