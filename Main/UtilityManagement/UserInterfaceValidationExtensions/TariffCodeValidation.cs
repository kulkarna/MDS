using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class TariffCodeValidation
    {
        #region public constructors
        public TariffCodeValidation(TariffCode TariffCode)
        {
            PopulateValidationProperties(TariffCode);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsTariffCodeNotNull { get; set; }
        bool IsTariffCodeCreatedByValid { get; set; }
        bool IsTariffCodeCreatedDateValid { get; set; }
        bool IsTariffCodeLastModifiedByValid { get; set; }
        bool IsTariffCodeLastModifiedDateValid { get; set; }
        bool IsTariffCodeTariffCodeCodeValid { get; set; }
        bool IsTariffCodeDescriptionValid { get; set; }
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
                    IsTariffCodeTariffCodeCodeValid &&
                    IsTariffCodeDescriptionValid &&
                    IsTariffCodeUtilityCompanyIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(TariffCode TariffCode)
        {
            IsTariffCodeNotNull = TariffCode != null;
            IsTariffCodeCreatedByValid = Common.IsValidString(TariffCode.CreatedBy);
            IsTariffCodeCreatedDateValid = Common.IsValidDate(TariffCode.CreatedDate);
            IsTariffCodeLastModifiedByValid = Common.IsValidString(TariffCode.LastModifiedBy);
            IsTariffCodeLastModifiedDateValid = Common.IsValidDate(TariffCode.LastModifiedDate);
            IsTariffCodeTariffCodeCodeValid = Common.IsValidString(TariffCode.TariffCodeCode) && TariffCode.TariffCodeCode.Length <= 255;
            IsTariffCodeDescriptionValid = Common.IsValidString(TariffCode.Description) && TariffCode.Description.Length <= 255;
            IsTariffCodeUtilityCompanyIdValid = Common.IsValidGuid(TariffCode.UtilityCompanyId);
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
            if (!IsTariffCodeTariffCodeCodeValid)
                message.Append("Invalid Value For Tariff Code! ");
            if (!IsTariffCodeDescriptionValid)
                message.Append("Invalid Value For Description! ");
            if (!IsTariffCodeUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");

            return message.ToString();
        }
        #endregion
    }
}