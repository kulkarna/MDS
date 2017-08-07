using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class RequestModeTypeValidation
    {
        #region public constructors
        public RequestModeTypeValidation(RequestModeType requestModeType)
        {
            PopulateValidationProperties(requestModeType);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsRequestModeTypeNotNull { get; set; }
        bool IsRequestModeTypeCreatedByValid { get; set; }
        bool IsRequestModeTypeCreatedDateValid { get; set; }
        bool IsRequestModeTypeLastModifiedByValid { get; set; }
        bool IsRequestModeTypeLastModifiedDateValid { get; set; }
        bool IsRequestModeTypeNameValid { get; set; }
        bool IsRequestModeTypeDescriptionValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsRequestModeTypeNotNull &&
                    IsRequestModeTypeCreatedByValid &&
                    IsRequestModeTypeCreatedDateValid &&
                    IsRequestModeTypeLastModifiedByValid &&
                    IsRequestModeTypeLastModifiedDateValid &&
                    IsRequestModeTypeNameValid &&
                    IsRequestModeTypeDescriptionValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(RequestModeType requestModeType)
        {
            IsRequestModeTypeNotNull = requestModeType != null;
            IsRequestModeTypeCreatedByValid = Common.IsValidString(requestModeType.CreatedBy);
            IsRequestModeTypeCreatedDateValid = Common.IsValidDate(requestModeType.CreatedDate);
            IsRequestModeTypeLastModifiedByValid = Common.IsValidString(requestModeType.LastModifiedBy);
            IsRequestModeTypeLastModifiedDateValid = Common.IsValidDate(requestModeType.LastModifiedDate);
            IsRequestModeTypeNameValid = Common.IsValidString(requestModeType.Name);
            IsRequestModeTypeDescriptionValid = Common.IsValidString(requestModeType.Description);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsRequestModeTypeNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsRequestModeTypeCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsRequestModeTypeCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsRequestModeTypeLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsRequestModeTypeLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsRequestModeTypeNameValid)
                message.Append("Invalid Value For Name! ");
            if (!IsRequestModeTypeDescriptionValid)
                message.Append("Invalid Value For Description! ");

            return message.ToString();
        }
        #endregion
    }
}