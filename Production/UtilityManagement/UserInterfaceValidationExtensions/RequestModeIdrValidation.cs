using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;


namespace UserInterfaceValidationExtensions
{
    public class RequestModeIdrValidation
    {
        #region public constructors
        public RequestModeIdrValidation(string message)
        {
            Message += message;
        }

        public RequestModeIdrValidation(RequestModeIdr requestModeIdr, bool isCreateAction)
        {
            PopulateValidationProperties(requestModeIdr, isCreateAction);
            Message += GenerateMessage(isCreateAction);
        }
        #endregion


        #region private methods
        private void PopulateValidationProperties(RequestModeIdr requestModeIdr, bool isCreateAction)
        {
            // declare variables
            Lp_UtilityManagementEntities db = new Lp_UtilityManagementEntities();
            string requestModeTypeName = string.Empty;
            StringBuilder message = new StringBuilder();

            // initialize data
            if (requestModeIdr == null || requestModeIdr.RequestModeTypeId == null || string.IsNullOrEmpty(requestModeIdr.RequestModeTypeId.ToString()) || requestModeIdr.RequestModeTypeId.ToString() == "00000000-0000-0000-0000-000000000000")
            {
                return;
            }
            requestModeTypeName = db.usp_RequestModeType_SELECT_NameById(requestModeIdr.RequestModeTypeId.ToString()).First().ToString();

            // calculate validation property values
            IsRequestModeIdrNotNull = requestModeIdr != null;
            if (!IsRequestModeIdrNotNull)
            {
                if (!Message.Contains("Invalid Data Model!"))
                    Message += "Invalid Data Model!";
                return;
            }

            IsRequestModeIdrCreatedByValid = Common.IsValidString(requestModeIdr.CreatedBy);
            IsRequestModeIdrCreatedDateValid = Common.IsValidDate(requestModeIdr.CreatedDate);
            IsRequestModeIdrLastModifiedByValid = Common.IsValidString(requestModeIdr.LastModifiedBy);
            IsRequestModeIdrLastModifiedDateValid = Common.IsValidDate(requestModeIdr.LastModifiedDate);
            IsRequestModeIdrRequestModeEnrollmentTypeIdValid = Common.IsValidGuid(requestModeIdr.RequestModeEnrollmentTypeId);
            IsRequestModeIdrRequestModeTypeIdValid = false;
            foreach (var requestModeTypeToRequestMode1EnrollmentTypes in db.RequestModeTypeToRequestModeEnrollmentTypes)
            {
                if (Common.IsValidGuid(requestModeIdr.RequestModeTypeId) && requestModeTypeToRequestMode1EnrollmentTypes.RequestModeTypeId == requestModeIdr.RequestModeTypeId && requestModeTypeToRequestMode1EnrollmentTypes.RequestModeEnrollmentTypeId == requestModeIdr.RequestModeEnrollmentTypeId)
                {
                    IsRequestModeIdrRequestModeTypeIdValid = true;
                    break;
                }
            }
            IsRequestModeIdrUtilityCompanyIdValid = Common.IsValidGuid(requestModeIdr.UtilityCompanyId);
            IsRequestModeIdrAddressValid =
                !string.IsNullOrEmpty(requestModeTypeName) &&
                (
                    (
                        (
                            requestModeTypeName.ToLower() == "e-mail" ||
                            requestModeTypeName.ToLower() == "website"
                        )
                        &&
                        !string.IsNullOrEmpty(requestModeIdr.AddressForPreEnrollment)
                    )
                    ||
                    !(
                        requestModeTypeName.ToLower() == "e-mail" ||
                        requestModeTypeName.ToLower() == "website"
                    )
                );
            IsRequestModeIdrEmailTemplateValid =
                !string.IsNullOrEmpty(requestModeTypeName) &&
                (
                    requestModeTypeName.ToLower() != "e-mail"
                    ||
                    (
                        requestModeTypeName.ToLower() == "e-mail"
                        && !string.IsNullOrEmpty(requestModeIdr.EmailTemplate)
                    )
                );
            IsRequestModeIdrInstructionsValid = !string.IsNullOrEmpty(requestModeIdr.Instructions);
            IsRequestModeIdrUtilitysSlaIcapResponseInDaysValid = requestModeIdr.UtilitysSlaIdrResponseInDays >= 0;
            IsRequestModeIdrLibertyPowersSlaFollowUpIcapResponseInDaysValid = requestModeIdr.LibertyPowersSlaFollowUpIdrResponseInDays >= 0;
            IsRequestModeIdrRequestCostAccountValid = requestModeIdr.RequestCostAccount >= 0;
            DoesUtilityCompanyIdRequestModeEnrollmentTypeIdPairingAlreadyExist = isCreateAction && db.usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIdsRequestModeIdr(requestModeIdr.RequestModeEnrollmentTypeId.ToString(), requestModeIdr.UtilityCompanyId.ToString()).First() > 0;
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
        public bool IsRequestModeIdrNotNull { get; set; }
        public bool IsRequestModeIdrCreatedByValid { get; set; }
        public bool IsRequestModeIdrCreatedDateValid { get; set; }
        public bool IsRequestModeIdrLastModifiedByValid { get; set; }
        public bool IsRequestModeIdrLastModifiedDateValid { get; set; }
        public bool IsRequestModeIdrRequestModeEnrollmentTypeIdValid { get; set; }
        public bool IsRequestModeIdrRequestModeTypeIdValid { get; set; }
        public bool IsRequestModeIdrUtilityCompanyIdValid { get; set; }
        public bool IsRequestModeIdrAddressValid { get; set; }
        public bool IsRequestModeIdrEmailTemplateValid { get; set; }
        public bool IsRequestModeIdrInstructionsValid { get; set; }
        public bool IsRequestModeIdrUtilitysSlaIcapResponseInDaysValid { get; set; }
        public bool IsRequestModeIdrLibertyPowersSlaFollowUpIcapResponseInDaysValid { get; set; }
        public bool IsRequestModeIdrRequestCostAccountValid { get; set; }
        public bool DoesUtilityCompanyIdRequestModeEnrollmentTypeIdPairingAlreadyExist { get; set; }
        public bool IsValid
        {
            get
            {
                return IsRequestModeIdrAddressValid &&
                    IsRequestModeIdrCreatedByValid &&
                    IsRequestModeIdrCreatedDateValid &&
                    IsRequestModeIdrLastModifiedByValid &&
                    IsRequestModeIdrLastModifiedDateValid &&
                    IsRequestModeIdrEmailTemplateValid &&
                    IsRequestModeIdrInstructionsValid &&
                    IsRequestModeIdrLibertyPowersSlaFollowUpIcapResponseInDaysValid &&
                    IsRequestModeIdrRequestCostAccountValid &&
                    IsRequestModeIdrNotNull &&
                    IsRequestModeIdrRequestModeEnrollmentTypeIdValid &&
                    IsRequestModeIdrRequestModeTypeIdValid &&
                    IsRequestModeIdrUtilityCompanyIdValid &&
                    IsRequestModeIdrUtilitysSlaIcapResponseInDaysValid &&
                    !DoesUtilityCompanyIdRequestModeEnrollmentTypeIdPairingAlreadyExist &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion
    }
}
