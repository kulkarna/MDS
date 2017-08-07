using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class LpBillingTypeValidation
    {
        #region public constructors
        public LpBillingTypeValidation(LpBillingType lpBillingType)
        {
            PopulateValidationProperties(lpBillingType);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsLpBillingTypeNotNull { get; set; }
        bool IsLpBillingTypeCreatedByValid { get; set; }
        bool IsLpBillingTypeCreatedDateValid { get; set; }
        bool IsLpBillingTypeLastModifiedByValid { get; set; }
        bool IsLpBillingTypeLastModifiedDateValid { get; set; }
        bool IsLpBillingTypePorDriverIdValid { get; set; }
        bool IsLpBillingTypePorDriverValueValid { get; set; }
        bool IsLpBillingTypeDefaultBillingTypeValid { get; set; }
        bool IsLpBillingTypeUtilityCompanyIdValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsLpBillingTypeNotNull &&
                    IsLpBillingTypeCreatedByValid &&
                    IsLpBillingTypeCreatedDateValid &&
                    IsLpBillingTypeLastModifiedByValid &&
                    IsLpBillingTypeLastModifiedDateValid &&
                    IsLpBillingTypePorDriverIdValid &&
                    IsLpBillingTypePorDriverValueValid &&
                    IsLpBillingTypeDefaultBillingTypeValid &&
                    IsLpBillingTypeUtilityCompanyIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(LpBillingType LpBillingType)
        {
            IsLpBillingTypeNotNull = LpBillingType != null;
            IsLpBillingTypeCreatedByValid = Common.IsValidString(LpBillingType.CreatedBy);
            IsLpBillingTypeCreatedDateValid = Common.IsValidDate(LpBillingType.CreatedDate);
            IsLpBillingTypeLastModifiedByValid = Common.IsValidString(LpBillingType.LastModifiedBy);
            IsLpBillingTypeLastModifiedDateValid = Common.IsValidDate(LpBillingType.LastModifiedDate);
            IsLpBillingTypePorDriverIdValid = Common.IsValidGuid(LpBillingType.PorDriverId);
            IsLpBillingTypePorDriverValueValid = (LpBillingType.TariffCodeId != null && Common.IsValidGuid((Guid)LpBillingType.TariffCodeId)) || (LpBillingType.RateClassId != null && Common.IsValidGuid((Guid)LpBillingType.RateClassId)) || (LpBillingType.LoadProfileId != null && Common.IsValidGuid((Guid)LpBillingType.LoadProfileId));
            IsLpBillingTypeDefaultBillingTypeValid = Common.IsValidGuid(LpBillingType.DefaultBillingTypeId);
            IsLpBillingTypeUtilityCompanyIdValid = Common.IsValidGuid(LpBillingType.UtilityCompanyId);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsLpBillingTypeNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsLpBillingTypeCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsLpBillingTypeCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsLpBillingTypeLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsLpBillingTypeLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsLpBillingTypeUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");
            if (!IsLpBillingTypePorDriverIdValid)
                message.Append("Invalid Value For POR Driver! ");
            if (!IsLpBillingTypePorDriverValueValid)
                message.Append("Invalid Value For POR Driver Value! ");
            if (!IsLpBillingTypeDefaultBillingTypeValid)
                message.Append("Invalid Value For Is Default Bililng Type! ");

            return message.ToString();
        }
        #endregion
    }
}