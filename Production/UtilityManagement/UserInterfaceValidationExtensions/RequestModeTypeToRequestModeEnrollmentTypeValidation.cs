using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class RequestModeTypeToRequestModeEnrollmentTypeValidation
    {
        #region public constructors
        public RequestModeTypeToRequestModeEnrollmentTypeValidation(RequestModeTypeToRequestModeEnrollmentType requestModeTypeToRequestModeEnrollmentType)
        {
            PopulateValidationProperties(requestModeTypeToRequestModeEnrollmentType);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsRequestModeEnrollmentTypeNotNull { get; set; }
        bool IsRequestModeEnrollmentTypeCreatedByValid { get; set; }
        bool IsRequestModeEnrollmentTypeCreatedDateValid { get; set; }
        bool IsRequestModeEnrollmentTypeLastModifiedByValid { get; set; }
        bool IsRequestModeEnrollmentTypeLastModifiedDateValid { get; set; }
        bool IsRequestModeEnrollmentTypeRequestModeTypeIdValid { get; set; }
        bool IsRequestModeEnrollmentTypeRequestModeEnrollmentTypeIdValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsRequestModeEnrollmentTypeNotNull &&
                    IsRequestModeEnrollmentTypeCreatedByValid &&
                    IsRequestModeEnrollmentTypeCreatedDateValid &&
                    IsRequestModeEnrollmentTypeLastModifiedByValid &&
                    IsRequestModeEnrollmentTypeLastModifiedDateValid &&
                    IsRequestModeEnrollmentTypeRequestModeTypeIdValid &&
                    IsRequestModeEnrollmentTypeRequestModeEnrollmentTypeIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(RequestModeTypeToRequestModeEnrollmentType requestModeTypeToRequestModeEnrollmentType)
        {
            IsRequestModeEnrollmentTypeNotNull = requestModeTypeToRequestModeEnrollmentType != null;
            IsRequestModeEnrollmentTypeCreatedByValid = Common.IsValidString(requestModeTypeToRequestModeEnrollmentType.CreatedBy);
            IsRequestModeEnrollmentTypeCreatedDateValid = Common.IsValidDate(requestModeTypeToRequestModeEnrollmentType.CreatedDate);
            IsRequestModeEnrollmentTypeLastModifiedByValid = Common.IsValidString(requestModeTypeToRequestModeEnrollmentType.LastModifiedBy);
            IsRequestModeEnrollmentTypeLastModifiedDateValid = Common.IsValidDate(requestModeTypeToRequestModeEnrollmentType.LastModifiedDate);
            IsRequestModeEnrollmentTypeRequestModeEnrollmentTypeIdValid = Common.IsValidGuid(requestModeTypeToRequestModeEnrollmentType.RequestModeEnrollmentTypeId);
            IsRequestModeEnrollmentTypeRequestModeTypeIdValid = Common.IsValidGuid(requestModeTypeToRequestModeEnrollmentType.RequestModeTypeId);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsRequestModeEnrollmentTypeNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsRequestModeEnrollmentTypeCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsRequestModeEnrollmentTypeCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsRequestModeEnrollmentTypeLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsRequestModeEnrollmentTypeLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsRequestModeEnrollmentTypeRequestModeTypeIdValid)
                message.Append("Invalid Value For Request Mode Type! ");
            if (!IsRequestModeEnrollmentTypeRequestModeEnrollmentTypeIdValid)
                message.Append("Invalid Value For Request Mode Enrollment Type! ");

            return message.ToString();
        }
        #endregion
    }
}