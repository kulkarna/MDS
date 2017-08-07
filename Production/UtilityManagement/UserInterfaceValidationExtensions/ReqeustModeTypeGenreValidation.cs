using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class RequestModeTypeGenreValidation
    {
        #region public constructors
        public RequestModeTypeGenreValidation(RequestModeTypeGenre requestModeTypeGenre)
        {
            PopulateValidationProperties(requestModeTypeGenre);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsRequestModeTypeGenreNotNull { get; set; }
        bool IsRequestModeTypeGenreCreatedByValid { get; set; }
        bool IsRequestModeTypeGenreCreatedDateValid { get; set; }
        bool IsRequestModeTypeGenreLastModifiedByValid { get; set; }
        bool IsRequestModeTypeGenreLastModifiedDateValid { get; set; }
        bool IsRequestModeTypeGenreNameValid { get; set; }
        bool IsRequestModeTypeGenreDescriptionValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsRequestModeTypeGenreNotNull &&
                    IsRequestModeTypeGenreCreatedByValid &&
                    IsRequestModeTypeGenreCreatedDateValid &&
                    IsRequestModeTypeGenreLastModifiedByValid &&
                    IsRequestModeTypeGenreLastModifiedDateValid &&
                    IsRequestModeTypeGenreNameValid &&
                    IsRequestModeTypeGenreDescriptionValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(RequestModeTypeGenre requestModeTypeGenre)
        {
            IsRequestModeTypeGenreNotNull = requestModeTypeGenre != null;
            IsRequestModeTypeGenreCreatedByValid = Common.IsValidString(requestModeTypeGenre.CreatedBy);
            IsRequestModeTypeGenreCreatedDateValid = Common.IsValidDate(requestModeTypeGenre.CreatedDate);
            IsRequestModeTypeGenreLastModifiedByValid = Common.IsValidString(requestModeTypeGenre.LastModifiedBy);
            IsRequestModeTypeGenreLastModifiedDateValid = Common.IsValidDate(requestModeTypeGenre.LastModifiedDate);
            IsRequestModeTypeGenreNameValid = Common.IsValidString(requestModeTypeGenre.Name);
            IsRequestModeTypeGenreDescriptionValid = Common.IsValidString(requestModeTypeGenre.Description);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsRequestModeTypeGenreNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsRequestModeTypeGenreCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsRequestModeTypeGenreCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsRequestModeTypeGenreLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsRequestModeTypeGenreLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsRequestModeTypeGenreNameValid)
                message.Append("Invalid Value For Name! ");
            if (!IsRequestModeTypeGenreDescriptionValid)
                message.Append("Invalid Value For Description! ");

            return message.ToString();
        }
        #endregion
    }
}