using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class LoadProfileAliasValidation
    {
        #region public constructors
        public LoadProfileAliasValidation(LoadProfileAlia LoadProfileAlias)
        {
            PopulateValidationProperties(LoadProfileAlias);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsLoadProfileAliasNotNull { get; set; }
        bool IsLoadProfileAliasCreatedByValid { get; set; }
        bool IsLoadProfileAliasCreatedDateValid { get; set; }
        bool IsLoadProfileAliasLastModifiedByValid { get; set; }
        bool IsLoadProfileAliasLastModifiedDateValid { get; set; }
        bool IsLoadProfileAliasLoadProfileIdValid { get; set; }
        bool IsLoadProfileAliasLoadProfileAliasCode { get; set; }
        public bool IsValid
        {
            get
            {
                return IsLoadProfileAliasNotNull &&
                    IsLoadProfileAliasCreatedByValid &&
                    IsLoadProfileAliasCreatedDateValid &&
                    IsLoadProfileAliasLastModifiedByValid &&
                    IsLoadProfileAliasLastModifiedDateValid &&
                    IsLoadProfileAliasLoadProfileIdValid &&
                    IsLoadProfileAliasLoadProfileAliasCode &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(LoadProfileAlia LoadProfileAlias)
        {
            IsLoadProfileAliasNotNull = LoadProfileAlias != null;
            IsLoadProfileAliasCreatedByValid = Common.IsValidString(LoadProfileAlias.CreatedBy);
            IsLoadProfileAliasCreatedDateValid = Common.IsValidDate(LoadProfileAlias.CreatedDate);
            IsLoadProfileAliasLastModifiedByValid = Common.IsValidString(LoadProfileAlias.LastModifiedBy);
            IsLoadProfileAliasLastModifiedDateValid = Common.IsValidDate(LoadProfileAlias.LastModifiedDate);
            IsLoadProfileAliasLoadProfileIdValid = Common.IsValidGuid(LoadProfileAlias.LoadProfileId);
            IsLoadProfileAliasLoadProfileAliasCode = Common.IsValidString(LoadProfileAlias.LoadProfileCodeAlias) && LoadProfileAlias.LoadProfileCodeAlias.Length <= 255;
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsLoadProfileAliasNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsLoadProfileAliasCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsLoadProfileAliasCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsLoadProfileAliasLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsLoadProfileAliasLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsLoadProfileAliasLoadProfileIdValid)
                message.Append("Invalid Value For Load Profile Id! ");
            if (!IsLoadProfileAliasLoadProfileAliasCode)
                message.Append("Invalid Value For Load Profile Alias! ");

            return message.ToString();
        }
        #endregion
    }
}