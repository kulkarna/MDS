using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class RateClassAliasValidation
    {
        #region public constructors
        public RateClassAliasValidation(RateClassAlia rateClassAlias)
        {
            PopulateValidationProperties(rateClassAlias);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsRateClassAliasNotNull { get; set; }
        bool IsRateClassAliasCreatedByValid { get; set; }
        bool IsRateClassAliasCreatedDateValid { get; set; }
        bool IsRateClassAliasLastModifiedByValid { get; set; }
        bool IsRateClassAliasLastModifiedDateValid { get; set; }
        bool IsRateClassAliasRateClassIdValid { get; set; }
        bool IsRateClassAliasRateClassAliasCode { get; set; }
        public bool IsValid
        {
            get
            {
                return IsRateClassAliasNotNull &&
                    IsRateClassAliasCreatedByValid &&
                    IsRateClassAliasCreatedDateValid &&
                    IsRateClassAliasLastModifiedByValid &&
                    IsRateClassAliasLastModifiedDateValid &&
                    IsRateClassAliasRateClassIdValid &&
                    IsRateClassAliasRateClassAliasCode &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(RateClassAlia rateClassAlias)
        {
            IsRateClassAliasNotNull = rateClassAlias != null;
            IsRateClassAliasCreatedByValid = Common.IsValidString(rateClassAlias.CreatedBy);
            IsRateClassAliasCreatedDateValid = Common.IsValidDate(rateClassAlias.CreatedDate);
            IsRateClassAliasLastModifiedByValid = Common.IsValidString(rateClassAlias.LastModifiedBy);
            IsRateClassAliasLastModifiedDateValid = Common.IsValidDate(rateClassAlias.LastModifiedDate);
            IsRateClassAliasRateClassIdValid = Common.IsValidGuid(rateClassAlias.RateClassId);
            IsRateClassAliasRateClassAliasCode = Common.IsValidString(rateClassAlias.RateClassCodeAlias) && rateClassAlias.RateClassCodeAlias.Length <= 255; ;
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsRateClassAliasNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsRateClassAliasCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsRateClassAliasCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsRateClassAliasLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsRateClassAliasLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsRateClassAliasRateClassIdValid)
                message.Append("Invalid Value For Rate Class! ");
            if (!IsRateClassAliasRateClassAliasCode)
                message.Append("Invalid Value For Rate Class Alias! ");

            return message.ToString();
        }
        #endregion
    }
}