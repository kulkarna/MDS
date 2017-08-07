using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class TariffCodeAliasValidation
    {
        #region public constructors
        public TariffCodeAliasValidation(TariffCodeAlia TariffCodeAlias)
        {
            PopulateValidationProperties(TariffCodeAlias);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsTariffCodeAliasNotNull { get; set; }
        bool IsTariffCodeAliasCreatedByValid { get; set; }
        bool IsTariffCodeAliasCreatedDateValid { get; set; }
        bool IsTariffCodeAliasLastModifiedByValid { get; set; }
        bool IsTariffCodeAliasLastModifiedDateValid { get; set; }
        bool IsTariffCodeAliasTariffCodeIdValid { get; set; }
        bool IsTariffCodeAliasTariffCodeAliasCode { get; set; }
        public bool IsValid
        {
            get
            {
                return IsTariffCodeAliasNotNull &&
                    IsTariffCodeAliasCreatedByValid &&
                    IsTariffCodeAliasCreatedDateValid &&
                    IsTariffCodeAliasLastModifiedByValid &&
                    IsTariffCodeAliasLastModifiedDateValid &&
                    IsTariffCodeAliasTariffCodeIdValid &&
                    IsTariffCodeAliasTariffCodeAliasCode &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(TariffCodeAlia TariffCodeAlias)
        {
            IsTariffCodeAliasNotNull = TariffCodeAlias != null;
            IsTariffCodeAliasCreatedByValid = Common.IsValidString(TariffCodeAlias.CreatedBy);
            IsTariffCodeAliasCreatedDateValid = Common.IsValidDate(TariffCodeAlias.CreatedDate);
            IsTariffCodeAliasLastModifiedByValid = Common.IsValidString(TariffCodeAlias.LastModifiedBy);
            IsTariffCodeAliasLastModifiedDateValid = Common.IsValidDate(TariffCodeAlias.LastModifiedDate);
            IsTariffCodeAliasTariffCodeIdValid = Common.IsValidGuid(TariffCodeAlias.TariffCodeId);
            IsTariffCodeAliasTariffCodeAliasCode = Common.IsValidString(TariffCodeAlias.TariffCodeCodeAlias) && TariffCodeAlias.TariffCodeCodeAlias.Length <= 255;
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsTariffCodeAliasNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsTariffCodeAliasCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsTariffCodeAliasCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsTariffCodeAliasLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsTariffCodeAliasLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsTariffCodeAliasTariffCodeIdValid)
                message.Append("Invalid Value For Tariff Code! ");
            if (!IsTariffCodeAliasTariffCodeAliasCode)
                message.Append("Invalid Value For Tariff Code Alias! ");

            return message.ToString();
        }
        #endregion
    }
}