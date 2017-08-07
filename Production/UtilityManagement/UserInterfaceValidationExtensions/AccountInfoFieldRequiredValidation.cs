using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class AccountInfoFieldRequiredValidation
    {
        #region public constructors
        public AccountInfoFieldRequiredValidation(AccountInfoFieldRequired accountInfoFieldRequired)
        {
            PopulateValidationProperties(accountInfoFieldRequired);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsAccountInfoFieldRequiredNotNull { get; set; }
        bool IsAccountInfoFieldRequiredCreatedByValid { get; set; }
        bool IsAccountInfoFieldRequiredCreatedDateValid { get; set; }
        bool IsAccountInfoFieldRequiredLastModifiedByValid { get; set; }
        bool IsAccountInfoFieldRequiredLastModifiedDateValid { get; set; }
        bool IsAccountInfoFieldRequiredUtilityCompanyIdValid { get; set; }
        bool IsAccountInfoFieldRequiredAccountInfoFieldIdValid { get; set; }
        bool IsAccountInfoFieldRequiredIsRequiredValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsAccountInfoFieldRequiredNotNull &&
                    IsAccountInfoFieldRequiredUtilityCompanyIdValid &&
                    IsAccountInfoFieldRequiredCreatedByValid &&
                    IsAccountInfoFieldRequiredCreatedDateValid &&
                    IsAccountInfoFieldRequiredLastModifiedByValid &&
                    IsAccountInfoFieldRequiredLastModifiedDateValid &&
                    IsAccountInfoFieldRequiredAccountInfoFieldIdValid &&
                    IsAccountInfoFieldRequiredIsRequiredValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(AccountInfoFieldRequired accountInfoFieldRequired)
        {
            IsAccountInfoFieldRequiredNotNull = accountInfoFieldRequired != null;
            IsAccountInfoFieldRequiredCreatedByValid = Common.IsValidString(accountInfoFieldRequired.CreatedBy);
            IsAccountInfoFieldRequiredCreatedDateValid = Common.IsValidDate(accountInfoFieldRequired.CreatedDate);
            IsAccountInfoFieldRequiredLastModifiedByValid = Common.IsValidString(accountInfoFieldRequired.LastModifiedBy);
            IsAccountInfoFieldRequiredLastModifiedDateValid = Common.IsValidDate(accountInfoFieldRequired.LastModifiedDate);
            IsAccountInfoFieldRequiredUtilityCompanyIdValid = Common.IsValidGuid(accountInfoFieldRequired.UtilityCompanyId);
            IsAccountInfoFieldRequiredAccountInfoFieldIdValid = Common.IsValidGuid(accountInfoFieldRequired.AccountInfoFieldId);
            IsAccountInfoFieldRequiredIsRequiredValid = true;
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsAccountInfoFieldRequiredNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsAccountInfoFieldRequiredCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsAccountInfoFieldRequiredCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsAccountInfoFieldRequiredLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsAccountInfoFieldRequiredLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsAccountInfoFieldRequiredIsRequiredValid)
                message.Append("Invalid Value For Is Required! ");
            if (!IsAccountInfoFieldRequiredAccountInfoFieldIdValid)
                message.Append("Invalid Value For Account Info Field! ");
            if (!IsAccountInfoFieldRequiredUtilityCompanyIdValid)
                message.Append("Invalid Value Utility Company! ");

            return message.ToString();
        }
        #endregion
    }
}