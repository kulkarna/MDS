using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class PurchaseOfReceivableValidation
    {
        #region public constructors
        public PurchaseOfReceivableValidation(PurchaseOfReceivable purchaseOfReceivable)
        {
            PopulateValidationProperties(purchaseOfReceivable);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsPurchaseOfReceivableNotNull { get; set; }
        bool IsPurchaseOfReceivableCreatedByValid { get; set; }
        bool IsPurchaseOfReceivableCreatedDateValid { get; set; }
        bool IsPurchaseOfReceivableLastModifiedByValid { get; set; }
        bool IsPurchaseOfReceivableLastModifiedDateValid { get; set; }
        bool IsPurchaseOfReceivablePorDriverIdValid { get; set; }
        bool IsPurchaseOfReceivablePorDriverValueValid { get; set; }
        bool IsPurchaseOfReceivableIsPorOfferedValid { get; set; }
        bool IsPurchaseOfReceivableIsPorParticipatedValid { get; set; }
        bool IsPurchaseOfReceivablePorRecourseIdValid { get; set; }
        bool IsPurchaseOfReceivablePorDiscountRateValid { get; set; }
        bool IsPurchaseOfReceivablePorFlatFeeValid { get; set; }
        bool IsPurchaseOfReceivablePorDiscountEffectiveDateValid { get; set; }
        bool IsPurchaseOfReceivableUtilityCompanyIdValid { get; set; }
        public bool IsValid
        {
            get
            {
                return IsPurchaseOfReceivableNotNull &&
                    IsPurchaseOfReceivableCreatedByValid &&
                    IsPurchaseOfReceivableCreatedDateValid &&
                    IsPurchaseOfReceivableLastModifiedByValid &&
                    IsPurchaseOfReceivableLastModifiedDateValid &&
                    IsPurchaseOfReceivablePorDriverIdValid &&
                    IsPurchaseOfReceivablePorDriverValueValid &&
                    IsPurchaseOfReceivableIsPorOfferedValid &&
                    IsPurchaseOfReceivableIsPorParticipatedValid &&
                    IsPurchaseOfReceivablePorRecourseIdValid &&
                    IsPurchaseOfReceivablePorDiscountRateValid &&
                    IsPurchaseOfReceivablePorFlatFeeValid &&
                    IsPurchaseOfReceivablePorDiscountEffectiveDateValid &&
                    IsPurchaseOfReceivableUtilityCompanyIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(PurchaseOfReceivable purchaseOfReceivable)
        {
            IsPurchaseOfReceivableNotNull = purchaseOfReceivable != null;
            IsPurchaseOfReceivableCreatedByValid = Common.IsValidString(purchaseOfReceivable.CreatedBy);
            IsPurchaseOfReceivableCreatedDateValid = Common.IsValidDate(purchaseOfReceivable.CreatedDate);
            IsPurchaseOfReceivableLastModifiedByValid = Common.IsValidString(purchaseOfReceivable.LastModifiedBy);
            IsPurchaseOfReceivableLastModifiedDateValid = Common.IsValidDate(purchaseOfReceivable.LastModifiedDate);
            IsPurchaseOfReceivablePorDriverIdValid = Common.IsValidGuid(purchaseOfReceivable.PorDriverId);
            IsPurchaseOfReceivablePorDriverValueValid = (purchaseOfReceivable.TariffCodeId != null && Common.IsValidGuid((Guid)purchaseOfReceivable.TariffCodeId)) || (purchaseOfReceivable.RateClassId != null && Common.IsValidGuid((Guid)purchaseOfReceivable.RateClassId)) || (purchaseOfReceivable.LoadProfileId != null && Common.IsValidGuid((Guid)purchaseOfReceivable.LoadProfileId));
            IsPurchaseOfReceivableIsPorOfferedValid = true; //purchaseOfReceivable.IsPorOffered != null;
            IsPurchaseOfReceivableIsPorParticipatedValid = true; //purchaseOfReceivable.IsPorParticipated != null;
            IsPurchaseOfReceivablePorRecourseIdValid = Common.IsValidGuid(purchaseOfReceivable.PorRecourseId);
            IsPurchaseOfReceivablePorDiscountRateValid = purchaseOfReceivable.PorDiscountRate >= 0;
            IsPurchaseOfReceivablePorFlatFeeValid = purchaseOfReceivable.PorFlatFee >= 0;
            IsPurchaseOfReceivablePorDiscountEffectiveDateValid = Common.IsValidDate(purchaseOfReceivable.PorDiscountEffectiveDate);
            IsPurchaseOfReceivableUtilityCompanyIdValid = Common.IsValidGuid(purchaseOfReceivable.UtilityCompanyId);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsPurchaseOfReceivableNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsPurchaseOfReceivableCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsPurchaseOfReceivableCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsPurchaseOfReceivableLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsPurchaseOfReceivableLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsPurchaseOfReceivableUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");
            if (!IsPurchaseOfReceivablePorDriverIdValid)
                message.Append("Invalid Value For POR Driver! ");
            if (!IsPurchaseOfReceivablePorDriverValueValid)
                message.Append("Invalid Value For POR Driver Value! ");
            if (!IsPurchaseOfReceivableIsPorOfferedValid)
                message.Append("Invalid Value For Is POR Offered! ");
            if (!IsPurchaseOfReceivableIsPorParticipatedValid)
                message.Append("Invalid Value For Is POR Participated! ");
            if (!IsPurchaseOfReceivablePorRecourseIdValid)
                message.Append("Invalid Value For POR Recourse! ");
            if (!IsPurchaseOfReceivablePorDiscountRateValid)
                message.Append("Invalid Value For POR Discount Rate! ");
            if (!IsPurchaseOfReceivablePorFlatFeeValid)
                message.Append("Invalid Value For POR Flat Fee! ");
            if (!IsPurchaseOfReceivablePorDiscountEffectiveDateValid)
                message.Append("Invalid Value For POR Discount Effective Date! ");

            return message.ToString();
        }
        #endregion
    }
}