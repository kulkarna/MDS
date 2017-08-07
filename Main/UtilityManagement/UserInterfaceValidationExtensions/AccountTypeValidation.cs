using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class AccountTypeValidation
    {
        #region public constructors
        public AccountTypeValidation(AccountType accountType)
        {
            PopulateValidationProperties(accountType);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsAccountTypeNotNull { get; set; }
        bool IsAccountTypeCreatedByValid { get; set; }
        bool IsAccountTypeCreatedDateValid { get; set; }
        bool IsAccountTypeLastModifiedByValid { get; set; }
        bool IsAccountTypeLastModifiedDateValid { get; set; }
        bool IsAccountTypeNameValid { get; set; }
        bool IsAccountTypeDescriptionValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsAccountTypeNotNull &&
                    IsAccountTypeCreatedByValid &&
                    IsAccountTypeCreatedDateValid &&
                    IsAccountTypeLastModifiedByValid &&
                    IsAccountTypeLastModifiedDateValid &&
                    IsAccountTypeNameValid &&
                    IsAccountTypeDescriptionValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(AccountType AccountType)
        {
            IsAccountTypeNotNull = AccountType != null;
            IsAccountTypeCreatedByValid = Common.IsValidString(AccountType.CreatedBy);
            IsAccountTypeCreatedDateValid = Common.IsValidDate(AccountType.CreatedDate);
            IsAccountTypeLastModifiedByValid = Common.IsValidString(AccountType.LastModifiedBy);
            IsAccountTypeLastModifiedDateValid = Common.IsValidDate(AccountType.LastModifiedDate);
            IsAccountTypeNameValid = Common.IsValidString(AccountType.Name);
            IsAccountTypeDescriptionValid = Common.IsValidString(AccountType.Description);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsAccountTypeNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsAccountTypeCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsAccountTypeCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsAccountTypeLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsAccountTypeLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsAccountTypeNameValid)
                message.Append("Invalid Value For Name! ");
            if (!IsAccountTypeDescriptionValid)
                message.Append("Invalid Value For Description! ");

            return message.ToString();
        }
        #endregion
    }
}