using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class PaymentTermValidation
    {
        #region public constructors
        public PaymentTermValidation(PaymentTerm paymentTerm)
        {
            PopulateValidationProperties(paymentTerm);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsPaymentTermNotNull { get; set; }
        bool IsPaymentTermCreatedByValid { get; set; }
        bool IsPaymentTermCreatedDateValid { get; set; }
        bool IsPaymentTermLastModifiedByValid { get; set; }
        bool IsPaymentTermLastModifiedDateValid { get; set; }
        bool IsPaymentTermUtilityCompanyIdValid { get; set; }
        bool IsPaymentTermMarketIdValid { get; set; }
        bool IsPaymentTermBillingTypeIdValid { get; set; }
        bool IsPaymentTermBusinessAccountTypeIdValid { get; set; }
        bool IsPaymentTermPaymentTermValid { get; set; }

        public bool IsValid
        {
            get
            {
                return IsPaymentTermNotNull &&
                    IsPaymentTermCreatedByValid &&
                    IsPaymentTermCreatedDateValid &&
                    IsPaymentTermLastModifiedByValid &&
                    IsPaymentTermLastModifiedDateValid &&
                    IsPaymentTermUtilityCompanyIdValid &&
                    IsPaymentTermMarketIdValid &&
                    IsPaymentTermBillingTypeIdValid &&
                    IsPaymentTermBusinessAccountTypeIdValid &&
                    IsPaymentTermPaymentTermValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(PaymentTerm paymentTerm)
        {
            IsPaymentTermNotNull = paymentTerm != null;
            if (IsPaymentTermNotNull)
            {
                IsPaymentTermCreatedByValid = Common.IsValidString(paymentTerm.CreatedBy);
                IsPaymentTermCreatedDateValid = Common.IsValidDate(paymentTerm.CreatedDate);
                IsPaymentTermLastModifiedByValid = Common.IsValidString(paymentTerm.LastModifiedBy);
                IsPaymentTermLastModifiedDateValid = Common.IsValidDate(paymentTerm.LastModifiedDate);
                IsPaymentTermUtilityCompanyIdValid = Common.IsValidGuid(paymentTerm.UtilityCompanyId);
                IsPaymentTermMarketIdValid = Common.IsValidGuid(paymentTerm.MarketId);
                IsPaymentTermBillingTypeIdValid = Common.IsValidGuid(paymentTerm.BillingTypeId);
                IsPaymentTermBusinessAccountTypeIdValid = Common.IsValidGuid(paymentTerm.BusinessAccountTypeId);
                IsPaymentTermPaymentTermValid = Common.IsValidString(paymentTerm.PaymentTerm1);
            }
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsPaymentTermNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsPaymentTermCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsPaymentTermCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsPaymentTermLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsPaymentTermLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsPaymentTermUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");
            if (!IsPaymentTermMarketIdValid)
                message.Append("Invalid Value For Market! ");
            if (!IsPaymentTermBillingTypeIdValid)
                message.Append("Invalid Value For Billing Type! ");
            if (!IsPaymentTermBusinessAccountTypeIdValid)
                message.Append("Invalid Value For Account Type! ");
            if (!IsPaymentTermPaymentTermValid)
                message.Append("Invalid Value For Payment Term! ");

            return message.ToString();
        }
        #endregion
    }
}