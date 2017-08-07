using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class LpStandardTariffCodeValidation
    {
        #region public constructors
        public LpStandardTariffCodeValidation(LpStandardTariffCode lpStandardTariffCode)
        {
            PopulateValidationProperties(lpStandardTariffCode);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsTariffCodeNotNull { get; set; }
        bool IsTariffCodeCreatedByValid { get; set; }
        bool IsTariffCodeCreatedDateValid { get; set; }
        bool IsTariffCodeLastModifiedByValid { get; set; }
        bool IsTariffCodeLastModifiedDateValid { get; set; }
        bool IsLpStandardTariffCodeTariffCodeCodeValid { get; set; }
        bool IsTariffCodeUtilityCompanyIdValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsTariffCodeNotNull &&
                    IsTariffCodeCreatedByValid &&
                    IsTariffCodeCreatedDateValid &&
                    IsTariffCodeLastModifiedByValid &&
                    IsTariffCodeLastModifiedDateValid &&
                    IsLpStandardTariffCodeTariffCodeCodeValid &&
                    IsTariffCodeUtilityCompanyIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(LpStandardTariffCode lpStandardTariffCode)
        {
            IsTariffCodeNotNull = lpStandardTariffCode != null;
            IsTariffCodeCreatedByValid = Common.IsValidString(lpStandardTariffCode.CreatedBy);
            IsTariffCodeCreatedDateValid = Common.IsValidDate(lpStandardTariffCode.CreatedDate);
            IsTariffCodeLastModifiedByValid = Common.IsValidString(lpStandardTariffCode.LastModifiedBy);
            IsTariffCodeLastModifiedDateValid = Common.IsValidDate(lpStandardTariffCode.LastModifiedDate);
            IsLpStandardTariffCodeTariffCodeCodeValid = Common.IsValidString(lpStandardTariffCode.LpStandardTariffCodeCode);
            IsTariffCodeUtilityCompanyIdValid = Common.IsValidGuid(lpStandardTariffCode.UtilityCompanyId);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsTariffCodeNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsTariffCodeCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsTariffCodeCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsTariffCodeLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsTariffCodeLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsLpStandardTariffCodeTariffCodeCodeValid)
                message.Append("Invalid Value For LP Standard Tariff Code! ");
            if (!IsTariffCodeUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");

            return message.ToString();
        }
        #endregion
    }
}