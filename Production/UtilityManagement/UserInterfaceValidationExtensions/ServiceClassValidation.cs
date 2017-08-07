using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class ServiceClassValidation
    {
        #region public constructors
        public ServiceClassValidation(ServiceClass ServiceClass)
        {
            PopulateValidationProperties(ServiceClass);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsServiceClassNotNull { get; set; }
        bool IsServiceClassCreatedByValid { get; set; }
        bool IsServiceClassCreatedDateValid { get; set; }
        bool IsServiceClassLastModifiedByValid { get; set; }
        bool IsServiceClassLastModifiedDateValid { get; set; }
        bool IsServiceClassServiceClassCodeValid { get; set; }
        bool IsServiceClassDescriptionValid { get; set; }
        bool IsServiceClassUtilityCompanyIdValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsServiceClassNotNull &&
                    IsServiceClassCreatedByValid &&
                    IsServiceClassCreatedDateValid &&
                    IsServiceClassLastModifiedByValid &&
                    IsServiceClassLastModifiedDateValid &&
                    IsServiceClassServiceClassCodeValid &&
                    IsServiceClassDescriptionValid &&
                    IsServiceClassUtilityCompanyIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(ServiceClass ServiceClass)
        {
            IsServiceClassNotNull = ServiceClass != null;
            IsServiceClassCreatedByValid = Common.IsValidString(ServiceClass.CreatedBy);
            IsServiceClassCreatedDateValid = Common.IsValidDate(ServiceClass.CreatedDate);
            IsServiceClassLastModifiedByValid = Common.IsValidString(ServiceClass.LastModifiedBy);
            IsServiceClassLastModifiedDateValid = Common.IsValidDate(ServiceClass.LastModifiedDate);
            IsServiceClassServiceClassCodeValid = Common.IsValidString(ServiceClass.ServiceClassCode);
            IsServiceClassDescriptionValid = Common.IsValidString(ServiceClass.Description);
            IsServiceClassUtilityCompanyIdValid = ServiceClass.UtilityCompanyId != null && Common.IsValidGuid((Guid)ServiceClass.UtilityCompanyId);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsServiceClassNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsServiceClassCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsServiceClassCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsServiceClassLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsServiceClassLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsServiceClassServiceClassCodeValid)
                message.Append("Invalid Value For Service Class Code! ");
            if (!IsServiceClassDescriptionValid)
                message.Append("Invalid Value For Description! ");
            if (!IsServiceClassUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");

            return message.ToString();
        }
        #endregion
    }
}