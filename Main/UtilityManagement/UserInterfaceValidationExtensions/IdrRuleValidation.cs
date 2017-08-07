using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class IdrRuleValidation
    {
        #region public constructors
        public IdrRuleValidation(IdrRule idrRule)
        {
            PopulateValidationProperties(idrRule);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        public bool IsIdrRuleNotNull { get; set; }
        public bool IsIdrRuleCreatedByValid { get; set; }
        public bool IsIdrRuleCreatedDateValid { get; set; }
        public bool IsIdrRuleLastModifiedByValid { get; set; }
        public bool IsIdrRuleLastModifiedDateValid { get; set; }
        public bool IsIdrRuleLoadProfileIdRuleValid { get; set; }
        public bool IsIdrRuleUtilityCompanyIdValid { get; set; }
        public bool IsIdrRuleRateClassIdValid { get; set; }
        public bool IsIdrRuleMinUsageMwhValid { get; set; }
        public bool IsIdrRuleMaxUsageMwhValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsIdrRuleNotNull &&
                    IsIdrRuleCreatedByValid &&
                    IsIdrRuleCreatedDateValid &&
                    IsIdrRuleLastModifiedByValid &&
                    IsIdrRuleLastModifiedDateValid &&
                    IsIdrRuleLoadProfileIdRuleValid &&
                    IsIdrRuleUtilityCompanyIdValid &&
                    IsIdrRuleRateClassIdValid &&
                    IsIdrRuleMinUsageMwhValid &&
                    IsIdrRuleMaxUsageMwhValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(IdrRule idrRule)
        {
            IsIdrRuleNotNull = idrRule != null;
            IsIdrRuleCreatedByValid = Common.IsValidString(idrRule.CreatedBy);
            IsIdrRuleCreatedDateValid = Common.IsValidDate(idrRule.CreatedDate);
            IsIdrRuleLastModifiedByValid = Common.IsValidString(idrRule.LastModifiedBy);
            IsIdrRuleLastModifiedDateValid = Common.IsValidDate(idrRule.LastModifiedDate);
            IsIdrRuleLoadProfileIdRuleValid = idrRule.LoadProfileId == null || Common.IsValidGuid((Guid)idrRule.LoadProfileId);
            IsIdrRuleUtilityCompanyIdValid = Common.IsValidGuid(idrRule.UtilityCompanyId);
            IsIdrRuleRateClassIdValid = idrRule.RateClassId == null || Common.IsValidGuid((Guid)idrRule.RateClassId);
            IsIdrRuleMinUsageMwhValid = (idrRule.MinUsageMWh == null && idrRule.MaxUsageMWh == null) || (idrRule.MinUsageMWh >= 0 && idrRule.MaxUsageMWh >= idrRule.MinUsageMWh);
            IsIdrRuleMaxUsageMwhValid = (idrRule.MinUsageMWh == null && idrRule.MaxUsageMWh == null) || (idrRule.MaxUsageMWh >= 0 && idrRule.MaxUsageMWh >= idrRule.MinUsageMWh);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsIdrRuleNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsIdrRuleCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsIdrRuleCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsIdrRuleLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsIdrRuleLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsIdrRuleLoadProfileIdRuleValid)
                message.Append("Invalid Value For Load Profile! ");
            if (!IsIdrRuleUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility Company! ");
            if (!IsIdrRuleRateClassIdValid)
                message.Append("Invalid Value For Rate Class! ");
            if (!IsIdrRuleMinUsageMwhValid)
                message.Append("Invalid Value For Min Usage! ");
            if (!IsIdrRuleMaxUsageMwhValid)
                message.Append("Invalid Value For Max Usage! ");

            return message.ToString();
        }
        #endregion
    }
}