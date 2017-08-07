using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class RequestModeTypeToRequestModeTypeGenreValidation
    {
        #region public constructors
        public RequestModeTypeToRequestModeTypeGenreValidation(RequestModeTypeToRequestModeTypeGenre requestModeTypeToRequestModeTypeGenre)
        {
            PopulateValidationProperties(requestModeTypeToRequestModeTypeGenre);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsRequestModeTypeGenreNotNull { get; set; }
        bool IsRequestModeTypeGenreCreatedByValid { get; set; }
        bool IsRequestModeTypeGenreCreatedDateValid { get; set; }
        bool IsRequestModeTypeGenreLastModifiedByValid { get; set; }
        bool IsRequestModeTypeGenreLastModifiedDateValid { get; set; }
        bool IsRequestModeTypeGenreRequestModeTypeIdValid { get; set; }
        bool IsRequestModeTypeGenreRequestModeTypeGenreIdValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsRequestModeTypeGenreNotNull &&
                    IsRequestModeTypeGenreCreatedByValid &&
                    IsRequestModeTypeGenreCreatedDateValid &&
                    IsRequestModeTypeGenreLastModifiedByValid &&
                    IsRequestModeTypeGenreLastModifiedDateValid &&
                    IsRequestModeTypeGenreRequestModeTypeIdValid &&
                    IsRequestModeTypeGenreRequestModeTypeGenreIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(RequestModeTypeToRequestModeTypeGenre requestModeTypeToRequestModeTypeGenre)
        {
            IsRequestModeTypeGenreNotNull = requestModeTypeToRequestModeTypeGenre != null;
            IsRequestModeTypeGenreCreatedByValid = Common.IsValidString(requestModeTypeToRequestModeTypeGenre.CreatedBy);
            IsRequestModeTypeGenreCreatedDateValid = Common.IsValidDate(requestModeTypeToRequestModeTypeGenre.CreatedDate);
            IsRequestModeTypeGenreLastModifiedByValid = Common.IsValidString(requestModeTypeToRequestModeTypeGenre.LastModifiedBy);
            IsRequestModeTypeGenreLastModifiedDateValid = Common.IsValidDate(requestModeTypeToRequestModeTypeGenre.LastModifiedDate);
            IsRequestModeTypeGenreRequestModeTypeGenreIdValid = Common.IsValidGuid(requestModeTypeToRequestModeTypeGenre.RequestModeTypeGenreId);
            IsRequestModeTypeGenreRequestModeTypeIdValid = Common.IsValidGuid(requestModeTypeToRequestModeTypeGenre.RequestModeTypeId);
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
            if (!IsRequestModeTypeGenreRequestModeTypeIdValid)
                message.Append("Invalid Value For Request Mode Type! ");
            if (!IsRequestModeTypeGenreRequestModeTypeGenreIdValid)
                message.Append("Invalid Value For Request Mode Type Genre! ");

            return message.ToString();
        }
        #endregion
    }
}