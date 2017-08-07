using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataAccessLayerEntityFramework;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class RequestModeHistoricalUsageValidation
    {
        #region public constructors
        public RequestModeHistoricalUsageValidation(string message)
        {
            Message += message;
        }

        public RequestModeHistoricalUsageValidation(RequestModeHistoricalUsage requestModeHistoricalUsage, bool isCreateAction)
        {
            PopulateValidationProperties(requestModeHistoricalUsage, isCreateAction);
            Message += GenerateMessage(isCreateAction);
        }
        #endregion


        #region private methods
        private void PopulateValidationProperties(RequestModeHistoricalUsage requestModeHistoricalUsage, bool isCreateAction)
        {
            // declare variables
            Lp_UtilityManagementEntities db = new Lp_UtilityManagementEntities();
            string requestModeTypeName = string.Empty;
            StringBuilder message = new StringBuilder();

            // initialize data
            if (requestModeHistoricalUsage == null || requestModeHistoricalUsage.RequestModeTypeId == null || string.IsNullOrEmpty(requestModeHistoricalUsage.RequestModeTypeId.ToString()) || requestModeHistoricalUsage.RequestModeTypeId.ToString() == "00000000-0000-0000-0000-000000000000")
            {
                return;
            }
            requestModeTypeName = db.usp_RequestModeType_SELECT_NameById(requestModeHistoricalUsage.RequestModeTypeId.ToString()).First().ToString();

            // calculate validation property values
            IsRequestModeHistoricalUsageNotNull = requestModeHistoricalUsage != null;
            if (!IsRequestModeHistoricalUsageNotNull)
            {
                if (!Message.Contains("Invalid Data Model!"))
                    Message += "Invalid Data Model!";
                return;
            }

            IsRequestModeHistoricalUsageRequestModeEnrollmentTypeIdValid = Common.IsValidGuid(requestModeHistoricalUsage.RequestModeEnrollmentTypeId);
            IsRequestModeHistoricalUsageRequestModeTypeIdValid = false;
            foreach (var requestModeTypeToRequestMode1EnrollmentTypes in db.RequestModeTypeToRequestModeEnrollmentTypes)
            {
                if (Common.IsValidGuid(requestModeHistoricalUsage.RequestModeTypeId) && requestModeTypeToRequestMode1EnrollmentTypes.RequestModeTypeId == requestModeHistoricalUsage.RequestModeTypeId && requestModeTypeToRequestMode1EnrollmentTypes.RequestModeEnrollmentTypeId == requestModeHistoricalUsage.RequestModeEnrollmentTypeId)
                {
                    IsRequestModeHistoricalUsageRequestModeTypeIdValid = true;
                    break;
                }
            }
            IsRequestModeHistoricalUsageUtilityCompanyIdValid = Common.IsValidGuid(requestModeHistoricalUsage.UtilityCompanyId);
            IsRequestModeHistoricalUsageAddressValid =
                !string.IsNullOrEmpty(requestModeTypeName) &&
                (
                    (
                        (
                            requestModeTypeName.ToLower() == "e-mail" ||
                            requestModeTypeName.ToLower() == "website"
                        )
                        &&
                        !string.IsNullOrEmpty(requestModeHistoricalUsage.AddressForPreEnrollment)
                    )
                    ||
                    !(
                        requestModeTypeName.ToLower() == "e-mail" ||
                        requestModeTypeName.ToLower() == "website"
                    )
                );
            IsRequestModeHistoricalUsageEmailTemplateValid =
                !string.IsNullOrEmpty(requestModeTypeName) &&
                (
                    requestModeTypeName.ToLower() != "e-mail"
                    ||
                    (
                        requestModeTypeName.ToLower() == "e-mail"
                        && !string.IsNullOrEmpty(requestModeHistoricalUsage.EmailTemplate)
                    )
                );
            IsRequestModeHistoricalUsageInstructionsValid = !string.IsNullOrEmpty(requestModeHistoricalUsage.Instructions);
            IsRequestModeHistoricalUsageUtilitysSlaHistoricalUsageResponseInDaysValid = requestModeHistoricalUsage.UtilitysSlaHistoricalUsageResponseInDays >= 0;
            IsRequestModeHistoricalUsageLibertyPowersSlaFollowUpHistoricalUsageResponseInDaysValid = requestModeHistoricalUsage.LibertyPowersSlaFollowUpHistoricalUsageResponseInDays >= 0;
            IsRequestModeHistoricalUsageCreatedByValid = Common.IsValidString(requestModeHistoricalUsage.CreatedBy);
            IsRequestModeHistoricalUsageCreatedDateValid = Common.IsValidDate(requestModeHistoricalUsage.CreatedDate);
            IsRequestModeHistoricalUsageLastModifiedByValid = Common.IsValidString(requestModeHistoricalUsage.LastModifiedBy);
            IsRequestModeHistoricalUsageLastModifiedDateValid = Common.IsValidDate(requestModeHistoricalUsage.LastModifiedDate);
            DoesUtilityCompanyIdRequestModeEnrollmentTypeIdPairingAlreadyExist = isCreateAction && db.usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIds(requestModeHistoricalUsage.RequestModeEnrollmentTypeId.ToString(), requestModeHistoricalUsage.UtilityCompanyId.ToString()).First() > 0;
        }

        private string GenerateMessage(bool isCreateAction)
        {
            StringBuilder message = new StringBuilder();

            if (isCreateAction && DoesUtilityCompanyIdRequestModeEnrollmentTypeIdPairingAlreadyExist)
                message.Append("This Request Mode Enrollment Type (Pre or Post Enrollment) Already Exists For This Utility!  ");
            return message.ToString();
        }
        #endregion


        #region public properties
        public bool IsRequestModeHistoricalUsageNotNull { get; set; }
        public bool IsRequestModeHistoricalUsageCreatedByValid { get; set; }
        public bool IsRequestModeHistoricalUsageCreatedDateValid { get; set; }
        public bool IsRequestModeHistoricalUsageLastModifiedByValid { get; set; }
        public bool IsRequestModeHistoricalUsageLastModifiedDateValid { get; set; }
        public bool IsRequestModeHistoricalUsageRequestModeEnrollmentTypeIdValid { get; set; }
        public bool IsRequestModeHistoricalUsageRequestModeTypeIdValid { get; set; }
        public bool IsRequestModeHistoricalUsageUtilityCompanyIdValid { get; set; }
        public bool IsRequestModeHistoricalUsageAddressValid { get; set; }
        public bool IsRequestModeHistoricalUsageEmailTemplateValid { get; set; }
        public bool IsRequestModeHistoricalUsageInstructionsValid { get; set; }
        public bool IsRequestModeHistoricalUsageUtilitysSlaHistoricalUsageResponseInDaysValid { get; set; }
        public bool IsRequestModeHistoricalUsageLibertyPowersSlaFollowUpHistoricalUsageResponseInDaysValid { get; set; }
        public bool DoesUtilityCompanyIdRequestModeEnrollmentTypeIdPairingAlreadyExist { get; set; }
        public bool IsValid
        {
            get
            {
                return IsRequestModeHistoricalUsageAddressValid &&
                    IsRequestModeHistoricalUsageCreatedByValid &&
                    IsRequestModeHistoricalUsageCreatedDateValid &&
                    IsRequestModeHistoricalUsageLastModifiedByValid &&
                    IsRequestModeHistoricalUsageLastModifiedDateValid &&
                    IsRequestModeHistoricalUsageEmailTemplateValid &&
                    IsRequestModeHistoricalUsageInstructionsValid &&
                    IsRequestModeHistoricalUsageLibertyPowersSlaFollowUpHistoricalUsageResponseInDaysValid &&
                    IsRequestModeHistoricalUsageNotNull &&
                    IsRequestModeHistoricalUsageRequestModeEnrollmentTypeIdValid &&
                    IsRequestModeHistoricalUsageRequestModeTypeIdValid &&
                    IsRequestModeHistoricalUsageUtilityCompanyIdValid &&
                    IsRequestModeHistoricalUsageUtilitysSlaHistoricalUsageResponseInDaysValid &&
                    !DoesUtilityCompanyIdRequestModeEnrollmentTypeIdPairingAlreadyExist &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion
    }
}
