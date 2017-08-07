using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class CapacityTresholdValidation
    {
        #region public constructors
        public CapacityTresholdValidation(CapacityThresholdRule capacityThresholdRule)
        {
            PopulateValidationProperties(capacityThresholdRule);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsCapacityTresholdNotNull { get; set; }
        bool IsCapacityTresholdCreatedByValid { get; set; }
        bool IsCapacityTresholdCreatedDateValid { get; set; }
        bool IsCapacityTresholdLastModifiedByValid { get; set; }
        bool IsCapacityTresholdLastModifiedDateValid { get; set; }
        public bool IsCapacityTresholdAccountTypeValid { get; set; }
        public bool IsCapacityTresholdFactorCheckValid { get; set; }
        public bool IsCapacityTresholdFactorMinValid { get; set; }
        bool IsCapacityTresholdFactorMaxValid { get; set; }
        bool IsCapacityTresholdFactorGreaterThenMin { get; set; }

        public bool IsValid
        {
            get
            {
                return IsCapacityTresholdNotNull &&
                    IsCapacityTresholdCreatedByValid &&
                    IsCapacityTresholdCreatedDateValid &&
                    IsCapacityTresholdLastModifiedByValid &&
                    IsCapacityTresholdLastModifiedDateValid &&
                    IsCapacityTresholdAccountTypeValid &&
                    IsCapacityTresholdFactorCheckValid &&
                    IsCapacityTresholdFactorMinValid &&
                    IsCapacityTresholdFactorMaxValid &&
                    IsCapacityTresholdFactorGreaterThenMin && 
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(CapacityThresholdRule capacityThresholdRule)
        {
            IsCapacityTresholdNotNull = capacityThresholdRule != null;
            IsCapacityTresholdCreatedByValid = Common.IsValidString(capacityThresholdRule.CreatedBy);
            IsCapacityTresholdCreatedDateValid = Common.IsValidDate(capacityThresholdRule.CreatedDate);
            IsCapacityTresholdLastModifiedByValid = Common.IsValidString(capacityThresholdRule.LastModifiedBy);
            IsCapacityTresholdLastModifiedDateValid = Common.IsValidDate(capacityThresholdRule.LastModifiedDate);
            IsCapacityTresholdAccountTypeValid = capacityThresholdRule.CustomerAccountTypeId != -1 && capacityThresholdRule.CustomerAccountTypeId != 0;
            IsCapacityTresholdFactorCheckValid = (capacityThresholdRule.IgnoreCapacityFactor || !capacityThresholdRule.IgnoreCapacityFactor);
            IsCapacityTresholdFactorMinValid = (capacityThresholdRule.IgnoreCapacityFactor && capacityThresholdRule.CapacityThreshold==0) ||(!capacityThresholdRule.IgnoreCapacityFactor && capacityThresholdRule.CapacityThreshold >= 0 && capacityThresholdRule.CapacityThreshold <= 999);
            IsCapacityTresholdFactorMaxValid = (capacityThresholdRule.IgnoreCapacityFactor && capacityThresholdRule.CapacityThresholdMax == 999) || (!capacityThresholdRule.IgnoreCapacityFactor && capacityThresholdRule.CapacityThresholdMax >= 0 && capacityThresholdRule.CapacityThresholdMax <= 999);
            IsCapacityTresholdFactorGreaterThenMin = (capacityThresholdRule.IgnoreCapacityFactor)||(!capacityThresholdRule.IgnoreCapacityFactor && capacityThresholdRule.CapacityThresholdMax >capacityThresholdRule.CapacityThreshold);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsCapacityTresholdNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsCapacityTresholdCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsCapacityTresholdCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsCapacityTresholdLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsCapacityTresholdLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsCapacityTresholdAccountTypeValid)
                message.Append("Invalid Value For Account Type! ");
            if (!IsCapacityTresholdFactorCheckValid)
                message.Append("Invalid Value For Use Capacity Threshold Factor! ");
            if (!IsCapacityTresholdFactorMinValid)
                message.Append("Invalid Value For Capacity Threshold Min Value! ");
            if (!IsCapacityTresholdFactorMaxValid)
                message.Append("Invalid Value For Capacity Threshold Max Value! ");
            if (!IsCapacityTresholdFactorGreaterThenMin)
                message.Append("Capacity Threshold Min Should Be Less Than Capacity Threshold Max! ");
            
            return message.ToString();
        }
        #endregion
    }
}