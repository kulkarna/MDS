using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataAccessLayerEntityFramework;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class RequestModeIcapValidation
    {
        #region public constructors
        public RequestModeIcapValidation(string message)
        {
            Message += message;
        }

        public RequestModeIcapValidation(RequestModeIcap requestModeIcap, bool isCreateAction)
        {
            PopulateValidationProperties(requestModeIcap, isCreateAction);
            Message += GenerateMessage(isCreateAction);
        }
        #endregion


        #region private methods
        private void PopulateValidationProperties(RequestModeIcap requestModeIcap, bool isCreateAction)
        {
            // declare variables
            Lp_UtilityManagementEntities db = new Lp_UtilityManagementEntities();
            string requestModeTypeName = string.Empty;
            StringBuilder message = new StringBuilder();

            // initialize data
            if (requestModeIcap == null || requestModeIcap.RequestModeTypeId == null || string.IsNullOrEmpty(requestModeIcap.RequestModeTypeId.ToString()) || requestModeIcap.RequestModeTypeId.ToString() == "00000000-0000-0000-0000-000000000000")
            {
                return;
            }
            requestModeTypeName = db.usp_RequestModeType_SELECT_NameById(requestModeIcap.RequestModeTypeId.ToString()).First().ToString();

            // calculate validation property values
            IsRequestModeIcapNotNull = requestModeIcap != null;
            if (!IsRequestModeIcapNotNull)
            {
                if (!Message.Contains("Invalid Data Model!"))
                    Message += "Invalid Data Model!";
                return;
            }

            IsRequestModeIcapCreatedByValid = Common.IsValidString(requestModeIcap.CreatedBy);
            IsRequestModeIcapCreatedDateValid = Common.IsValidDate(requestModeIcap.CreatedDate);
            IsRequestModeIcapLastModifiedByValid = Common.IsValidString(requestModeIcap.LastModifiedBy);
            IsRequestModeIcapLastModifiedDateValid = Common.IsValidDate(requestModeIcap.LastModifiedDate);
            IsRequestModeIcapRequestModeEnrollmentTypeIdValid = Common.IsValidGuid(requestModeIcap.RequestModeEnrollmentTypeId);
            IsRequestModeIcapRequestModeTypeIdValid = false;
            foreach (var requestModeTypeToRequestMode1EnrollmentTypes in db.RequestModeTypeToRequestModeEnrollmentTypes)
            {
                if (Common.IsValidGuid(requestModeIcap.RequestModeTypeId) && requestModeTypeToRequestMode1EnrollmentTypes.RequestModeTypeId == requestModeIcap.RequestModeTypeId && requestModeTypeToRequestMode1EnrollmentTypes.RequestModeEnrollmentTypeId == requestModeIcap.RequestModeEnrollmentTypeId)
                {
                    IsRequestModeIcapRequestModeTypeIdValid = true;
                    break;
                }
            }
            IsRequestModeIcapUtilityCompanyIdValid = Common.IsValidGuid(requestModeIcap.UtilityCompanyId);
            IsRequestModeIcapAddressValid =
                !string.IsNullOrEmpty(requestModeTypeName) &&
                (
                    (
                        (
                            requestModeTypeName.ToLower() == "e-mail" ||
                            requestModeTypeName.ToLower() == "website"
                        )
                        &&
                        !string.IsNullOrEmpty(requestModeIcap.AddressForPreEnrollment)
                    )
                    ||
                    !(
                        requestModeTypeName.ToLower() == "e-mail" ||
                        requestModeTypeName.ToLower() == "website"
                    )
                );
            IsRequestModeIcapEmailTemplateValid =
                !string.IsNullOrEmpty(requestModeTypeName) &&
                (
                    requestModeTypeName.ToLower() != "e-mail"
                    ||
                    (
                        requestModeTypeName.ToLower() == "e-mail"
                        && !string.IsNullOrEmpty(requestModeIcap.EmailTemplate)
                    )
                );
            IsRequestModeIcapInstructionsValid = !string.IsNullOrEmpty(requestModeIcap.Instructions);
            IsRequestModeIcapUtilitysSlaIcapResponseInDaysValid = requestModeIcap.UtilitysSlaIcapResponseInDays >= 0;
            IsRequestModeIcapLibertyPowersSlaFollowUpIcapResponseInDaysValid = requestModeIcap.LibertyPowersSlaFollowUpIcapResponseInDays >= 0;
            DoesUtilityCompanyIdRequestModeEnrollmentTypeIdPairingAlreadyExist = isCreateAction && db.usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIdsRequestModeIcap(requestModeIcap.RequestModeEnrollmentTypeId.ToString(), requestModeIcap.UtilityCompanyId.ToString()).First() > 0;
        }

        private string GenerateMessage(bool isCreateAction)
        {
            StringBuilder message = new StringBuilder();

            if (isCreateAction && DoesUtilityCompanyIdRequestModeEnrollmentTypeIdPairingAlreadyExist)
                message.AppendLine("This Request Mode Enrollment Type (Pre or Post Enrollment) Already Exists For This Utility!");
            return message.ToString();
        }
        #endregion


        #region public properties
        public bool IsRequestModeIcapNotNull { get; set; }
        public bool IsRequestModeIcapCreatedByValid { get; set; }
        public bool IsRequestModeIcapCreatedDateValid { get; set; }
        public bool IsRequestModeIcapLastModifiedByValid { get; set; }
        public bool IsRequestModeIcapLastModifiedDateValid { get; set; }
        public bool IsRequestModeIcapRequestModeEnrollmentTypeIdValid { get; set; }
        public bool IsRequestModeIcapRequestModeTypeIdValid { get; set; }
        public bool IsRequestModeIcapUtilityCompanyIdValid { get; set; }
        public bool IsRequestModeIcapAddressValid { get; set; }
        public bool IsRequestModeIcapEmailTemplateValid { get; set; }
        public bool IsRequestModeIcapInstructionsValid { get; set; }
        public bool IsRequestModeIcapUtilitysSlaIcapResponseInDaysValid { get; set; }
        public bool IsRequestModeIcapLibertyPowersSlaFollowUpIcapResponseInDaysValid { get; set; }
        public bool DoesUtilityCompanyIdRequestModeEnrollmentTypeIdPairingAlreadyExist { get; set; }
        public bool IsValid
        {
            get
            {
                return IsRequestModeIcapAddressValid &&
                    IsRequestModeIcapCreatedByValid &&
                    IsRequestModeIcapCreatedDateValid &&
                    IsRequestModeIcapLastModifiedByValid &&
                    IsRequestModeIcapLastModifiedDateValid &&
                    IsRequestModeIcapEmailTemplateValid &&
                    IsRequestModeIcapInstructionsValid &&
                    IsRequestModeIcapLibertyPowersSlaFollowUpIcapResponseInDaysValid &&
                    IsRequestModeIcapNotNull &&
                    IsRequestModeIcapRequestModeEnrollmentTypeIdValid &&
                    IsRequestModeIcapRequestModeTypeIdValid &&
                    IsRequestModeIcapUtilityCompanyIdValid &&
                    IsRequestModeIcapUtilitysSlaIcapResponseInDaysValid &&
                    !DoesUtilityCompanyIdRequestModeEnrollmentTypeIdPairingAlreadyExist &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion
    }
}
