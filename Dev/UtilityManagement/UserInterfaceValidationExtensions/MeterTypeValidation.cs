using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class MeterTypeValidation
    {
        #region public constructors
        public MeterTypeValidation(MeterType meterType)
        {
            PopulateValidationProperties(meterType);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsMeterTypeNotNull { get; set; }
        bool IsMeterTypeCreatedByValid { get; set; }
        bool IsMeterTypeCreatedDateValid { get; set; }
        bool IsMeterTypeLastModifiedByValid { get; set; }
        bool IsMeterTypeLastModifiedDateValid { get; set; }
        bool IsMeterTypeMeterTypeCodeValid { get; set; }
        bool IsMeterTypeDescriptionValid { get; set; }
        bool IsMeterTypeUtilityCompanyIdValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsMeterTypeNotNull &&
                    IsMeterTypeUtilityCompanyIdValid &&
                    IsMeterTypeCreatedByValid &&
                    IsMeterTypeCreatedDateValid &&
                    IsMeterTypeLastModifiedByValid &&
                    IsMeterTypeLastModifiedDateValid &&
                    IsMeterTypeMeterTypeCodeValid &&
                    IsMeterTypeDescriptionValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(MeterType meterType)
        {
            IsMeterTypeNotNull = meterType != null;
            IsMeterTypeCreatedByValid = Common.IsValidString(meterType.CreatedBy);
            IsMeterTypeCreatedDateValid = Common.IsValidDate(meterType.CreatedDate);
            IsMeterTypeLastModifiedByValid = Common.IsValidString(meterType.LastModifiedBy);
            IsMeterTypeLastModifiedDateValid = Common.IsValidDate(meterType.LastModifiedDate);
            IsMeterTypeMeterTypeCodeValid = Common.IsValidString(meterType.MeterTypeCode);
            IsMeterTypeDescriptionValid = Common.IsValidString(meterType.Description);
            IsMeterTypeUtilityCompanyIdValid = meterType.UtilityCompanyId != null && Common.IsValidGuid((Guid)meterType.UtilityCompanyId);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsMeterTypeNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsMeterTypeCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsMeterTypeCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsMeterTypeLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsMeterTypeLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsMeterTypeMeterTypeCodeValid)
                message.Append("Invalid Value For Meter Type Code! ");
            if (!IsMeterTypeDescriptionValid)
                message.Append("Invalid Value For Description! ");
            if (!IsMeterTypeUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");

            return message.ToString();
        }
        #endregion
    }
}