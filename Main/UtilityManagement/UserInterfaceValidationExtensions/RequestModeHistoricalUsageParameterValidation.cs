using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataAccessLayerEntityFramework;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class RequestModeHistoricalUsageParameterValidation
    {
        #region public constructors
        public RequestModeHistoricalUsageParameterValidation(string message)
        {
            Message += message;
        }

        public RequestModeHistoricalUsageParameterValidation(RequestModeHistoricalUsageParameter requestModeHistoricalUsageParameter, bool isCreateAction)
        {
            PopulateValidationProperties(requestModeHistoricalUsageParameter, isCreateAction);
            Message += GenerateMessage(isCreateAction);
        }
        #endregion


        #region private methods
        private void PopulateValidationProperties(RequestModeHistoricalUsageParameter requestModeHistoricalUsageParameter, bool isCreateAction)
        {
            // declare variables
            Lp_UtilityManagementEntities db = new Lp_UtilityManagementEntities();
            StringBuilder message = new StringBuilder();

            // initialize data
            if (requestModeHistoricalUsageParameter == null)
            {
                return;
            }

            IsRequestModeHistoricalUsageParameterUtilityCompanyIdValid = Common.IsValidGuid(requestModeHistoricalUsageParameter.UtilityCompanyId);
            IsRequestModeHistoricalUsageParameterIsBillingAccountRequiredIdValid = Common.IsValidGuid(requestModeHistoricalUsageParameter.IsBillingAccountNumberRequiredId);
            IsRequestModeHistoricalUsageParameterIsZipCodeRequiredId = Common.IsValidGuid(requestModeHistoricalUsageParameter.IsZipCodeRequiredId);
            IsRequestModeHistoricalUsageParameterIsNameKeyRequiredId = Common.IsValidGuid(requestModeHistoricalUsageParameter.IsNameKeyRequiredId);
            IsRequestModeHistoricalUsageParameterIsMdmaId = Common.IsValidGuid(requestModeHistoricalUsageParameter.IsMdmaId);
            IsRequestModeHistoricalUsageParameterIsServiceProviderId = Common.IsValidGuid(requestModeHistoricalUsageParameter.IsServiceProviderId);
            IsRequestModeHistoricalUsageParameterIsMeterInstallerId = Common.IsValidGuid(requestModeHistoricalUsageParameter.IsMeterInstallerId);
            IsRequestModeHistoricalUsageParameterIsMeterReaderId = Common.IsValidGuid(requestModeHistoricalUsageParameter.IsMeterReaderId);
            IsRequestModeHistoricalUsageParameterIsMeterOwnerId = Common.IsValidGuid(requestModeHistoricalUsageParameter.IsMeterOwnerId);
            IsRequestModeHistoricalUsageParameterIsSchedulingCoordinatorId = Common.IsValidGuid(requestModeHistoricalUsageParameter.IsSchedulingCoordinatorId);
            IsRequestModeHistoricalUsageParameterHasReferenceNumberId = Common.IsValidGuid(requestModeHistoricalUsageParameter.HasReferenceNumberId);
            IsRequestModeHistoricalUsageParameterHasCustomerNumberId = Common.IsValidGuid(requestModeHistoricalUsageParameter.HasCustomerNumberId);
            IsRequestModeHistoricalUsageParameterHasPodIdNumberId = Common.IsValidGuid(requestModeHistoricalUsageParameter.HasPodIdNumberId);
            IsRequestModeHistoricalUsageParameterHasMeterTypeId = Common.IsValidGuid(requestModeHistoricalUsageParameter.HasMeterTypeId);
            IsRequestModeHistoricalUsageParameterIsMeterNumberRequiredId = Common.IsValidGuid(requestModeHistoricalUsageParameter.IsMeterNumberRequiredId);
            IsRequestModeHistoricalUsageParameterCreatedByValid = Common.IsValidString(requestModeHistoricalUsageParameter.CreatedBy);
            IsRequestModeHistoricalUsageParameterCreatedDateValid = Common.IsValidDate(requestModeHistoricalUsageParameter.CreatedDate);
            IsRequestModeHistoricalUsageParameterLastModifiedByValid  = Common.IsValidString(requestModeHistoricalUsageParameter.LastModifiedBy);
            IsRequestModeHistoricalUsageParameterLastModifiedDateValid = Common.IsValidDate(requestModeHistoricalUsageParameter.LastModifiedDate);
        }

        private string GenerateMessage(bool isCreateAction)
        {
            StringBuilder message = new StringBuilder();

            return message.ToString();
        }
        #endregion


        #region public properties
        public bool IsRequestModeHistoricalUsageParameterNotNull { get; set; }
        public bool IsRequestModeHistoricalUsageParameterCreatedByValid { get; set; }
        public bool IsRequestModeHistoricalUsageParameterCreatedDateValid { get; set; }
        public bool IsRequestModeHistoricalUsageParameterLastModifiedByValid { get; set; }
        public bool IsRequestModeHistoricalUsageParameterLastModifiedDateValid { get; set; }
        public bool IsRequestModeHistoricalUsageParameterUtilityCompanyIdValid { get; set; }
        public bool IsRequestModeHistoricalUsageParameterIsBillingAccountRequiredIdValid { get; set; }
        public bool IsRequestModeHistoricalUsageParameterIsZipCodeRequiredId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterIsNameKeyRequiredId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterIsMdmaId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterIsServiceProviderId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterIsMeterInstallerId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterIsMeterReaderId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterIsMeterOwnerId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterIsSchedulingCoordinatorId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterHasReferenceNumberId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterHasCustomerNumberId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterHasPodIdNumberId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterHasMeterTypeId { get; set; }
        public bool IsRequestModeHistoricalUsageParameterIsMeterNumberRequiredId { get; set; }
        public bool IsValid
        {
            get
            {
                return IsRequestModeHistoricalUsageParameterCreatedByValid &&
                    IsRequestModeHistoricalUsageParameterCreatedDateValid &&
                    IsRequestModeHistoricalUsageParameterLastModifiedByValid &&
                    IsRequestModeHistoricalUsageParameterLastModifiedDateValid &&
                    IsRequestModeHistoricalUsageParameterUtilityCompanyIdValid &&
                    IsRequestModeHistoricalUsageParameterIsBillingAccountRequiredIdValid &&
                    IsRequestModeHistoricalUsageParameterIsZipCodeRequiredId &&
                    IsRequestModeHistoricalUsageParameterIsNameKeyRequiredId &&
                    IsRequestModeHistoricalUsageParameterIsMdmaId &&
                    IsRequestModeHistoricalUsageParameterIsServiceProviderId &&
                    IsRequestModeHistoricalUsageParameterIsMeterInstallerId &&
                    IsRequestModeHistoricalUsageParameterIsMeterReaderId &&
                    IsRequestModeHistoricalUsageParameterIsMeterOwnerId &&
                    IsRequestModeHistoricalUsageParameterIsSchedulingCoordinatorId &&
                    IsRequestModeHistoricalUsageParameterHasReferenceNumberId &&
                    IsRequestModeHistoricalUsageParameterHasCustomerNumberId &&
                    IsRequestModeHistoricalUsageParameterHasPodIdNumberId &&
                    IsRequestModeHistoricalUsageParameterHasMeterTypeId &&
                    IsRequestModeHistoricalUsageParameterIsMeterNumberRequiredId &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion
    }
}
