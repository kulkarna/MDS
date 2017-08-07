using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayerEntityFramework
{
    public class DataAccessLayer
    {
        public DalResult IsRequestModeEnrollmentTypeValid(RequestModeEnrollmentType requestModeEnrollmentType)
        {
            StringBuilder message = new StringBuilder();
            bool isRequestModeEnrollmentTypeNotNull = requestModeEnrollmentType != null;
            bool isRequestModeEnrollmentTypeCreatedByValid = IsValidString(requestModeEnrollmentType.CreatedBy);
            bool isRequestModeEnrollmentTypeCreatedDateValid = IsValidDate(requestModeEnrollmentType.CreatedDate);
            bool isRequestModeEnrollmentTypeLastModifiedByValid = IsValidString(requestModeEnrollmentType.LastModifiedBy);
            bool isRequestModeEnrollmentTypeLastModifiedDateValid = IsValidDate(requestModeEnrollmentType.LastModifiedDate);
            bool isRequestModeEnrollmentTypeNameValid = IsValidString(requestModeEnrollmentType.Name);
            bool isRequestModeEnrollmentTypeDescriptionValid = IsValidString(requestModeEnrollmentType.Description);
            if (!isRequestModeEnrollmentTypeNotNull)
                message.Append("Invalid Data Model! ");
            if (!isRequestModeEnrollmentTypeCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!isRequestModeEnrollmentTypeCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!isRequestModeEnrollmentTypeLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!isRequestModeEnrollmentTypeLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!isRequestModeEnrollmentTypeNameValid)
                message.Append("Invalid Value For Name! ");
            if (!isRequestModeEnrollmentTypeDescriptionValid)
                message.Append("Invalid Value For Description! ");

            DalResult dalResult = new DalResult()
            {
                Result = isRequestModeEnrollmentTypeNotNull && isRequestModeEnrollmentTypeCreatedByValid && isRequestModeEnrollmentTypeCreatedDateValid
                && isRequestModeEnrollmentTypeLastModifiedByValid && isRequestModeEnrollmentTypeLastModifiedDateValid && isRequestModeEnrollmentTypeNameValid
                && isRequestModeEnrollmentTypeDescriptionValid,
                Message = message.ToString()
            };

            return dalResult;
        }

        public DalResult IsRequestModeTypeValid(RequestModeType requestModeType)
        {
            StringBuilder message = new StringBuilder();
            bool isRequestModeTypeNotNull = requestModeType != null;
            bool isRequestModeTypeCreatedByValid = IsValidString(requestModeType.CreatedBy);
            bool isRequestModeTypeCreatedDateValid = IsValidDate(requestModeType.CreatedDate);
            bool isRequestModeTypeLastModifiedByValid = IsValidString(requestModeType.LastModifiedBy);
            bool isRequestModeTypeLastModifiedDateValid = IsValidDate(requestModeType.LastModifiedDate);
            bool isRequestModeTypeNameValid = IsValidString(requestModeType.Name);
            bool isRequestModeTypeDescriptionValid = IsValidString(requestModeType.Description);
            if (!isRequestModeTypeNotNull)
                message.Append("Invalid Data Model! ");
            if (!isRequestModeTypeCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!isRequestModeTypeCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!isRequestModeTypeLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!isRequestModeTypeLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!isRequestModeTypeNameValid)
                message.Append("Invalid Value For Name! ");
            if (!isRequestModeTypeDescriptionValid)
                message.Append("Invalid Value For Description! ");

            DalResult dalResult = new DalResult()
            {
                Result = isRequestModeTypeNotNull && isRequestModeTypeCreatedByValid && isRequestModeTypeCreatedDateValid
                && isRequestModeTypeLastModifiedByValid && isRequestModeTypeLastModifiedDateValid && isRequestModeTypeNameValid
                && isRequestModeTypeDescriptionValid,
                Message = message.ToString()
            };

            return dalResult;
        }



        public bool IsValidString(string value)
        {
            bool returnValue = !string.IsNullOrWhiteSpace(value);
            return returnValue;
        }

        public bool IsValidDate(DateTime dateTime)
        {
            bool returnValue = dateTime != null && dateTime > new DateTime(2001, 1, 1);
            return returnValue;
        }
    }
}
