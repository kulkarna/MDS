using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataAccessLayerEntityFramework;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public static class ValidationExtensions
    {
        #region Account Type Extension Methods
        public static string GetAccountTypeValidationString(this AccountType accountType)
        {
            AccountTypeValidation accountTypeValidation = new AccountTypeValidation(accountType);
            return accountTypeValidation.Message;
        }

        public static bool IsAccountTypeValid(this AccountType accountType)
        {
            AccountTypeValidation accountTypeValidation = new AccountTypeValidation(accountType);
            return accountTypeValidation.IsValid;
        }
        #endregion



        #region Idr Rule Extension Methods
        public static string GetIdrRuleValidationString(this IdrRule idrRule)
        {
            IdrRuleValidation idrRuleValidation = new IdrRuleValidation(idrRule);
            return idrRuleValidation.Message;
        }

        public static bool IsIdrRuleValid(this IdrRule idrRule)
        {
            IdrRuleValidation idrRuleValidation = new IdrRuleValidation(idrRule);
            return idrRuleValidation.IsValid;
        }

        public static string MaxUsageMWhValidationMessage(this IdrRule idrRule)
        {
            string returnValue = string.Empty;
            if (!((idrRule.MinUsageMWh == null && idrRule.MaxUsageMWh == null) || (idrRule.MaxUsageMWh >= 0 && idrRule.MaxUsageMWh >= idrRule.MinUsageMWh)))
                returnValue = "Invalid Maximum Usage MWh value.";

            return returnValue;
        }

        public static string MinUsageMWhValidationMessage(this IdrRule idrRule)
        {
            string returnValue = string.Empty;
            if (!((idrRule.MinUsageMWh == null && idrRule.MaxUsageMWh == null) || (idrRule.MinUsageMWh >= 0 && idrRule.MaxUsageMWh >= idrRule.MinUsageMWh)))
                returnValue = "Invalid Minimum Usage MWh value.";

            return returnValue;
        }
        #endregion


        // LoadProfile Extention Methods
        #region Load Profile Extension Methods
        public static string DescriptionValidationMessage(this LoadProfile LoadProfile)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(LoadProfile.Description))
                returnValue = "The Description field is required.";
            else if (LoadProfile.Description.Length > 255)
                returnValue = "The Description field is too long.";

            return returnValue;
        }

        public static string GetLoadProfileValidationString(this LoadProfile LoadProfile)
        {
            LoadProfileValidation LoadProfileValidation = new LoadProfileValidation(LoadProfile);
            return LoadProfileValidation.Message;
        }

        public static bool IsLoadProfileValid(this LoadProfile LoadProfile)
        {
            LoadProfileValidation LoadProfileValidation = new LoadProfileValidation(LoadProfile);
            return LoadProfileValidation.IsValid;
        }

        public static string LpStandardLoadProfileValidationMessage(this LoadProfile LoadProfile)
        {
            string returnValue = string.Empty;
            if (Common.IsValidGuid(LoadProfile.LpStandardLoadProfileId))
                returnValue = "The Liberty Power Standard Load Profile field is required.";

            return returnValue;
        }

        public static string LoadProfileCodeValidationMessage(this LoadProfile LoadProfile)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(LoadProfile.LoadProfileCode))
                returnValue = "The Load Profile Code field is required.";
            else if (LoadProfile.LoadProfileCode.Length > 255)
                returnValue = "The Load Profile Code field is too long.";

            return returnValue;
        }

        public static string LoadProfileIdValidationMessage(this LoadProfile LoadProfile)
        {
            string returnValue = string.Empty;
            if (LoadProfile.LoadProfileId <= 0)
                returnValue = "The Load Profile Id field is invalid.";

            return returnValue;
        }
        #endregion



        #region Load Profile Alias Extension Methods
        public static bool IsLoadProfileAliasValid(this LoadProfileAlia LoadProfiles)
        {
            LoadProfileAliasValidation LoadProfileAliasValidation = new LoadProfileAliasValidation(LoadProfiles);
            return LoadProfileAliasValidation.IsValid;
        }

        public static string LoadProfileCodeValidationMessage(this LoadProfileAlia LoadProfileAlias)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(LoadProfileAlias.LoadProfileCodeAlias))
                returnValue = "The Load Profile Alias field is required.";
            else if (LoadProfileAlias.LoadProfileCodeAlias.Length > 255)
                returnValue = "The Load Profile Alias field is too long.";

            return returnValue;
        }

        public static string LoadProfileCodeAliasValidationMessage(this LoadProfileAlia LoadProfileAlias)
        {
            return LoadProfileCodeValidationMessage(LoadProfileAlias);
        }

        #endregion


        #region Lp Standard Load Profile Extension Methods
        public static string GetLpStandardLoadProfileValidationString(this LpStandardLoadProfile lpStandardLoadProfile)
        {
            LpStandardLoadProfileValidation lpStandardLoadProfileValidation = new LpStandardLoadProfileValidation(lpStandardLoadProfile);
            return lpStandardLoadProfileValidation.Message;
        }

        public static bool IsLpStandardLoadProfileValid(this LpStandardLoadProfile lpStandardLoadProfile)
        {
            LpStandardLoadProfileValidation lpStandardLoadProfileValidation = new LpStandardLoadProfileValidation(lpStandardLoadProfile);
            return lpStandardLoadProfileValidation.IsValid;
        }

        public static string LpStandardLoadProfileCodeValidationMessage(this LpStandardLoadProfile lpStandardLoadProfile)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(lpStandardLoadProfile.LpStandardLoadProfileCode))
                returnValue = "The LP Standard Load Profile Code field is required.";
            else if (lpStandardLoadProfile.LpStandardLoadProfileCode.Length > 255)
                returnValue = "The LP Standard Load Profile Code field is too long.";

            return returnValue;
        }
        #endregion




        #region Lp Standard Rate Class Extension Methods
        public static string GetLpStandardRateClassValidationString(this LpStandardRateClass lpStandardRateClass)
        {
            LpStandardRateClassValidation lpStandardRateClassValidation = new LpStandardRateClassValidation(lpStandardRateClass);
            return lpStandardRateClassValidation.Message;
        }

        public static bool IsLpStandardRateClassValid(this LpStandardRateClass lpStandardRateClass)
        {
            LpStandardRateClassValidation lpStandardRateClassValidation = new LpStandardRateClassValidation(lpStandardRateClass);
            return lpStandardRateClassValidation.IsValid;
        }

        public static string LpStandardRateClassCodeValidationMessage(this LpStandardRateClass lpStandardRateClass)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(lpStandardRateClass.LpStandardRateClassCode))
                returnValue = "The LP Standard Rate Class Code field is required.";
            else if (lpStandardRateClass.LpStandardRateClassCode.Length > 255)
                returnValue = "The LP Standard Rate Class Code field is too long.";

            return returnValue;
        }
        #endregion



        #region Lp Standard Tariff Code Extension Methods
        public static string GetLpStandardTariffCodeValidationString(this LpStandardTariffCode lpStandardTariffCode)
        {
            LpStandardTariffCodeValidation lpStandardTariffCodeValidation = new LpStandardTariffCodeValidation(lpStandardTariffCode);
            return lpStandardTariffCodeValidation.Message;
        }

        public static bool IsLpStandardTariffCodeValid(this LpStandardTariffCode lpStandardTariffCode)
        {
            LpStandardTariffCodeValidation lpStandardTariffCodeValidation = new LpStandardTariffCodeValidation(lpStandardTariffCode);
            return lpStandardTariffCodeValidation.IsValid;
        }

        public static string LpStandardTariffCodeCodeValidationMessage(this LpStandardTariffCode lpStandardTariffCode)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(lpStandardTariffCode.LpStandardTariffCodeCode))
                returnValue = "The LP Standard Tariff Code field is required.";
            else if (lpStandardTariffCode.LpStandardTariffCodeCode.Length > 255)
                returnValue = "The LP Standard Tariff Code field is too long.";

            return returnValue;
        }
        #endregion



        #region Meter Type Extension Methods
        public static string DescriptionValidationMessage(this MeterType meterType)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(meterType.Description))
                returnValue = "The Description field is required.";
            else if (meterType.Description.Length > 255)
                returnValue = "The Description field is too long.";

            return returnValue;
        }

        public static string GetMeterTypeValidationString(this MeterType meterType)
        {
            MeterTypeValidation meterTypeValidation = new MeterTypeValidation(meterType);
            return meterTypeValidation.Message;
        }

        public static bool IsMeterTypeValid(this MeterType meterType)
        {
            MeterTypeValidation meterTypeValidation = new MeterTypeValidation(meterType);
            return meterTypeValidation.IsValid;
        }

        public static string LpStandardMeterTypeValidationMessage(this MeterType meterType)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(meterType.LpStandardMeterType))
                returnValue = "The Liberty Power Standard Meter Type field is required.";
            else if (meterType.LpStandardMeterType.Length > 255)
                returnValue = "The Liberty Power Standard Meter Type Profile field is too long.";

            return returnValue;
        }

        public static string MeterTypeCodeValidationMessage(this MeterType meterType)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(meterType.MeterTypeCode))
                returnValue = "The Meter Type Code field is required.";
            else if (meterType.MeterTypeCode.Length > 255)
                returnValue = "The Meter Type Code field is too long.";

            return returnValue;
        }

        public static string SequenceMessage(this MeterType meterType)
        {
            string returnValue = string.Empty;
            if (meterType.Sequence <= 0)
                returnValue = "The Sequence field must be greater than 0.";

            return returnValue;
        }
        #endregion


        #region Account Info Field Extension Methods
        public static bool IsAccountInfoFieldValid(this AccountInfoField accountInfoField)
        {
            AccountInfoFieldValidation accountInfoFieldValidation = new AccountInfoFieldValidation(accountInfoField);
            return accountInfoFieldValidation.IsValid;
        }
        #endregion


        #region Account Info Field Extension Methods
        public static bool IsAccountInfoFieldRequiredValid(this AccountInfoFieldRequired accountInfoFieldRequired)
        {
            AccountInfoFieldRequiredValidation accountInfoFieldRequiredValidation = new AccountInfoFieldRequiredValidation(accountInfoFieldRequired);
            return accountInfoFieldRequiredValidation.IsValid;
        }
        #endregion



        public static bool IsPaymentTermValid(this PaymentTerm paymentTerm)
        {
            PaymentTermValidation paymentTermValidation = new PaymentTermValidation(paymentTerm);
            return paymentTermValidation.IsValid;
        }

        public static bool IsCapacityTresholdValid(this CapacityThresholdRule capacityTresholdRule)
        {
            CapacityTresholdValidation capacityTrsholdRuleValidation = new CapacityTresholdValidation(capacityTresholdRule);
            return capacityTrsholdRuleValidation.IsValid;
        }

        public static string IsCapacityTresholdErrorMessage(this CapacityThresholdRule capacityTresholdRule)
        {
            CapacityTresholdValidation capacityTrsholdRuleValidation = new CapacityTresholdValidation(capacityTresholdRule);
            return capacityTrsholdRuleValidation.Message;
        }
        public static bool IsMeterReadCalendarValid(this MeterReadCalendar meterReadCalendar)
        {
            MeterReadCalendarValidation meterReadCalendarValidation = new MeterReadCalendarValidation(meterReadCalendar);
            return meterReadCalendarValidation.IsValid;
        }

        public static bool IsMeterReadCalendarReadDateValid(this MeterReadCalendar meterReadCalendar)
        {
            MeterReadCalendarValidation meterReadCalendarValidation = new MeterReadCalendarValidation(meterReadCalendar);
            return meterReadCalendarValidation.IsMeterReadCalendarReadDateValid;
        }

        public static bool IsMeterReadCalendarReadCycleIdValid(this MeterReadCalendar meterReadCalendar)
        {
            MeterReadCalendarValidation meterReadCalendarValidation = new MeterReadCalendarValidation(meterReadCalendar);
            return meterReadCalendarValidation.IsMeterReadCalendarReadCycleIdValid;
        }

        public static bool IsMeterReadCalendarReadCycleIdLengthValid(this MeterReadCalendar meterReadCalendar)
        {
            MeterReadCalendarValidation meterReadCalendarValidation = new MeterReadCalendarValidation(meterReadCalendar);
            return meterReadCalendarValidation.IsMeterReadCalendarReadCycleIdLengthValid;
        }

        #region Purchase Of Receivables Extension Methods
        public static bool IsPurchaseOfReceivableValid(this PurchaseOfReceivable purchaseOfReceivable)
        {
            PurchaseOfReceivableValidation purchaseOfReceivableValidation = new PurchaseOfReceivableValidation(purchaseOfReceivable);
            return purchaseOfReceivableValidation.IsValid;
        }

        public static string GetPurchaseOfReceivableValidationString(this PurchaseOfReceivable purchaseOfReceivable)
        {
            PurchaseOfReceivableValidation purchaseOfReceivableValidation = new PurchaseOfReceivableValidation(purchaseOfReceivable);
            return purchaseOfReceivableValidation.Message;
        }

        public static string PurchaseOfReceivableValidationMessage(this PurchaseOfReceivable purchaseOfReceivable)
        {
            string returnValue = string.Empty;
            if (purchaseOfReceivable.PorDiscountEffectiveDate == null)
                returnValue = "The POR Discount Effective Date field is required.";

            return returnValue;
        }

        public static string PorDiscountRateValidationMessage(this PurchaseOfReceivable purchaseOfReceivable)
        {
            string returnValue = string.Empty;
            if (purchaseOfReceivable.PorDiscountRate < 0)
                returnValue = "The value of the POR Discount Rate field is invalid.";

            return returnValue;
        }

        public static string PorFlatFeeValidationMessage(this PurchaseOfReceivable purchaseOfReceivable)
        {
            string returnValue = string.Empty;
            if (purchaseOfReceivable.PorFlatFee < 0)
                returnValue = "The value of the POR Flat Fee field is invalid.";

            return returnValue;
        }

        public static string PorDiscountEffectiveDateValidationMessage(this PurchaseOfReceivable purchaseOfReceivable)
        {
            string returnValue = string.Empty;
            if (purchaseOfReceivable.PorDiscountEffectiveDate == null || purchaseOfReceivable.PorDiscountEffectiveDate < new DateTime(2010,1,1) || purchaseOfReceivable.PorDiscountEffectiveDate > DateTime.Now.AddYears(20))
                returnValue = "The value for the POR Discount Effective Date field not value.";

            return returnValue;
        }

        public static string PorDiscountExpirationDateValidationMessage(this PurchaseOfReceivable purchaseOfReceivable)
        {
            string returnValue = string.Empty;
            if (purchaseOfReceivable.PorDiscountExpirationDate == null || purchaseOfReceivable.PorDiscountExpirationDate < new DateTime(2010,1,1) || purchaseOfReceivable.PorDiscountExpirationDate > DateTime.Now.AddYears(20))
                returnValue = "The value for the POR Discount Expiration Date field not value.";

            return returnValue;
        }
        #endregion



        // RateClass Extention Methods
        #region Rate Class Extension Methods
        public static string DescriptionValidationMessage(this RateClass rateClass)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(rateClass.Description))
                returnValue = "The Description field is required.";
            else if (rateClass.Description.Length > 255)
                returnValue = "The Description field is too long.";

            return returnValue;
        }

        public static string GetRateClassValidationString(this RateClass rateClass)
        {
            RateClassValidation rateClassValidation = new RateClassValidation(rateClass);
            return rateClassValidation.Message;
        }

        public static bool IsRateClassValid(this RateClass rateClass)
        {
            RateClassValidation rateClassValidation = new RateClassValidation(rateClass);
            return rateClassValidation.IsValid;
        }

        public static string LpStandardRateClassValidationMessage(this RateClass rateClass)
        {
            string returnValue = string.Empty;
            if (Common.IsValidGuid(rateClass.LpStandardRateClassId))
                returnValue = "The Liberty Power Standard Rate Class field is required.";

            return returnValue;
        }

        public static string RateClassCodeValidationMessage(this RateClass rateClass)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(rateClass.RateClassCode))
                returnValue = "The Rate Class Code field is required.";
            else if (rateClass.RateClassCode.Length > 255)
                returnValue = "The Rate Class Code field is too long.";

            return returnValue;
        }

        public static string RateClassIdValidationMessage(this RateClass rateClass)
        {
            string returnValue = string.Empty;
            if (rateClass.RateClassId <= 0)
                returnValue = "The Rate Class Id field is invalid.";

            return returnValue;
        }
        #endregion



        #region Rate Class Alias Extension Methods
        public static bool IsRateClassAliasValid(this RateClassAlia rateClasss)
        {
            RateClassAliasValidation rateClassAliasValidation = new RateClassAliasValidation(rateClasss);
            return rateClassAliasValidation.IsValid;
        }

        public static string RateClassCodeAliasValidationMessage(this RateClassAlia RateClassAlias)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(RateClassAlias.RateClassCodeAlias))
                returnValue = "The Rate Class Code Alias field is required.";
            else if (RateClassAlias.RateClassCodeAlias.Length > 255)
                returnValue = "The Rate Class Code Alias field is too long.";

            return returnValue;
        }
        #endregion


        // Request Mode Enrollment Type Extension Methods
        #region Request Mode Enrollment Type Extension Methods
        public static string GetRequestModeEnrollmentTypeValidationString(this RequestModeEnrollmentType requestModeEnrollmentType)
        {
            StringBuilder message = new StringBuilder();
            bool isRequestModeEnrollmentTypeNotNull = requestModeEnrollmentType != null;
            bool isRequestModeEnrollmentTypeCreatedByValid = IsValidString(requestModeEnrollmentType.CreatedBy);
            bool isRequestModeEnrollmentTypeCreatedDateValid = IsValidDate(requestModeEnrollmentType.CreatedDate);
            bool isRequestModeEnrollmentTypeLastModifiedByValid = IsValidString(requestModeEnrollmentType.LastModifiedBy);
            bool isRequestModeEnrollmentTypeLastModifiedDateValid = IsValidDate(requestModeEnrollmentType.LastModifiedDate);
            bool isRequestModeEnrollmentTypeNameValid = IsValidString(requestModeEnrollmentType.Name);
            bool isRequestModeEnrollmentTypeDescriptionValid = IsValidString(requestModeEnrollmentType.Description);

            if (!isRequestModeEnrollmentTypeNotNull)
                message.Append("Invalid Data Model! ");
            if (!isRequestModeEnrollmentTypeCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!isRequestModeEnrollmentTypeCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!isRequestModeEnrollmentTypeLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!isRequestModeEnrollmentTypeLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!isRequestModeEnrollmentTypeNameValid)
                message.Append("Invalid Value For Name! ");
            if (!isRequestModeEnrollmentTypeDescriptionValid)
                message.Append("Invalid Value For Description! ");

            return message.ToString();
        }

        public static bool IsRequestModeEnrollmentTypeValid(this RequestModeEnrollmentType requestModeEnrollmentType)
        {
            bool isRequestModeEnrollmentTypeNotNull = requestModeEnrollmentType != null;
            bool isRequestModeEnrollmentTypeCreatedByValid = IsValidString(requestModeEnrollmentType.CreatedBy);
            bool isRequestModeEnrollmentTypeCreatedDateValid = IsValidDate(requestModeEnrollmentType.CreatedDate);
            bool isRequestModeEnrollmentTypeLastModifiedByValid = IsValidString(requestModeEnrollmentType.LastModifiedBy);
            bool isRequestModeEnrollmentTypeLastModifiedDateValid = IsValidDate(requestModeEnrollmentType.LastModifiedDate);
            bool isRequestModeEnrollmentTypeNameValid = IsValidString(requestModeEnrollmentType.Name);
            bool isRequestModeEnrollmentTypeDescriptionValid = IsValidString(requestModeEnrollmentType.Description);

            return (isRequestModeEnrollmentTypeNotNull && isRequestModeEnrollmentTypeCreatedByValid &&
                isRequestModeEnrollmentTypeCreatedDateValid && isRequestModeEnrollmentTypeLastModifiedByValid &&
                isRequestModeEnrollmentTypeLastModifiedDateValid && isRequestModeEnrollmentTypeNameValid &&
                isRequestModeEnrollmentTypeDescriptionValid);
        }


        public static string ToString(this RequestModeEnrollmentType requestModeEnrollmentType)
        {
            string returnValue = string.Empty;
            if (requestModeEnrollmentType == null)
                returnValue = "requestModeEnrollmentType:[NULL]";
            else
                returnValue = string.Format("requestModeEnrollmentType:[Id:{0};Name:{1};Description:{2};Inactive:{3};CreatedBy:{4};CreatedDate:{5};LastModifiedBy:{6};LastModifiedDate:{7}]",
                Common.NullSafeGuid(requestModeEnrollmentType.Id),
                Common.NullSafeString(requestModeEnrollmentType.Name),
                Common.NullSafeString(requestModeEnrollmentType.Description),
                requestModeEnrollmentType.Inactive,
                Common.NullSafeString(requestModeEnrollmentType.CreatedBy),
                Common.NullSafeDateToString(requestModeEnrollmentType.CreatedDate),
                Common.NullSafeString(requestModeEnrollmentType.LastModifiedBy),
                Common.NullSafeDateToString(requestModeEnrollmentType.LastModifiedDate));
            return returnValue;
        }
        #endregion


        // Request Mode Historical Usage Extension Methods
        #region Request Mode Historical Usage Extension Methods
        public static string AddressForPreEnrollmentValidationMessage(this RequestModeHistoricalUsage requestModeHistoricalUsage)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(requestModeHistoricalUsage.AddressForPreEnrollment))
                returnValue = "The Address For Pre Enrollment field is required.";
            else if (requestModeHistoricalUsage.AddressForPreEnrollment.Length > 200)
                returnValue = "The Address field is too long.";

            return returnValue;
        }

        public static string EmailTemplateValidationMessage(this RequestModeHistoricalUsage requestModeHistoricalUsage)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(requestModeHistoricalUsage.EmailTemplate))
                returnValue = "The Email Template field is required.";
            else if (requestModeHistoricalUsage.EmailTemplate.Length > 200)
                returnValue = "The Email Template field is too long.";

            return returnValue;
        }

        public static List<usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId_Result> GetListOfValidRequestModeTypesByRequestEnrollmentType(this RequestModeHistoricalUsage requestModeHistoricalUsage, string requestModeEnrollmentTypeId)
        {
            Lp_UtilityManagementEntities db = new Lp_UtilityManagementEntities();
            return db.usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId(requestModeEnrollmentTypeId).ToList<usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId_Result>();
        }

        public static string GetRequestModeHistoricalUsageValidationString(this RequestModeHistoricalUsage requestModeHistoricalUsage, bool isCreateAction)
        {
            RequestModeHistoricalUsageValidation requestModeHistoricalUsageValidation = new RequestModeHistoricalUsageValidation(requestModeHistoricalUsage, isCreateAction);
            return requestModeHistoricalUsageValidation.Message;
        }

        public static string InstructionValidationMessage(this RequestModeHistoricalUsage requestModeHistoricalUsage)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(requestModeHistoricalUsage.Instructions))
                returnValue = "The Instructions field is required.";
            else if (requestModeHistoricalUsage.Instructions.Length > 500)
                returnValue = "The Instructions field is too long.";

            return returnValue;
        }

        public static bool IsRequestModeHistoricalUsageValid(this RequestModeHistoricalUsage requestModeHistoricalUsage, bool isCreateAction)
        {
            RequestModeHistoricalUsageValidation requestModeHistoricalUsageValidation = new RequestModeHistoricalUsageValidation(requestModeHistoricalUsage, isCreateAction);
            return requestModeHistoricalUsageValidation.IsValid;
        }

        public static string LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysMessage(this RequestModeHistoricalUsage requestModeHistoricalUsage)
        {
            string returnValue = string.Empty;
            if (requestModeHistoricalUsage.LibertyPowersSlaFollowUpHistoricalUsageResponseInDays < 0)
                returnValue = "The Liberty Power SLA Response field is required.";

            return returnValue;
        }

        public static string ToString(this RequestModeHistoricalUsage requestModeHistoricalUsage)
        {
            string returnValue = string.Empty;
            if (requestModeHistoricalUsage == null)
                returnValue = "requestModeHistoricalUsage:[NULL]";
            else
                returnValue = string.Format("requestModeHistoricalUsage:[Id:{0};UtilityCode:{1};RequestModeEnrollmentType:{2};AddressForPreEnrollment:{3};EmailTemplate:{4};Instructions:{5};UtilitysSlaHistoricalUsageResponseInDays:{6};LibertyPowersSlaFollowUpHistoricalUsageResponseInDays:{7};IsLoaRequired:{8};Inactive:{9};CreatedBy:{10};CreatedDate:{11};LastModifiedBy:{12};LastModifiedDate:{13}]",
                Common.NullSafeGuid(requestModeHistoricalUsage.Id),
                Common.NullSafeString(requestModeHistoricalUsage.UtilityCompany == null ? "NULL" : requestModeHistoricalUsage.UtilityCompany.UtilityCode),
                Common.NullSafeString(requestModeHistoricalUsage.RequestModeEnrollmentType == null ? "NULL" : requestModeHistoricalUsage.RequestModeEnrollmentType.Name),
                Common.NullSafeString(requestModeHistoricalUsage.AddressForPreEnrollment),
                Common.NullSafeString(requestModeHistoricalUsage.EmailTemplate),
                Common.NullSafeString(requestModeHistoricalUsage.Instructions),
                Common.NullSafeString(requestModeHistoricalUsage.UtilitysSlaHistoricalUsageResponseInDays),
                Common.NullSafeString(requestModeHistoricalUsage.LibertyPowersSlaFollowUpHistoricalUsageResponseInDays),
                Common.NullSafeString(requestModeHistoricalUsage.IsLoaRequired),
                requestModeHistoricalUsage.Inactive,
                Common.NullSafeString(requestModeHistoricalUsage.CreatedBy),
                Common.NullSafeDateToString(requestModeHistoricalUsage.CreatedDate),
                Common.NullSafeString(requestModeHistoricalUsage.LastModifiedBy),
                Common.NullSafeDateToString(requestModeHistoricalUsage.LastModifiedDate));
            return returnValue;
        }

        public static string UtilitysSlaHistoricalUsageResponseInDaysValidationMessage(this RequestModeHistoricalUsage requestModeHistoricalUsage)
        {
            string returnValue = string.Empty;
            if (requestModeHistoricalUsage.UtilitysSlaHistoricalUsageResponseInDays < 0)
                returnValue = "The Utility SLA Response field is required.";

            return returnValue;
        }

        public static void SetMessageForError(this RequestModeHistoricalUsage requestModeHistoricalUsage, string errorMessage)
        {
            RequestModeHistoricalUsageValidation requestModeHistoricalUsageValidation = new RequestModeHistoricalUsageValidation(errorMessage);
        }
        #endregion



        #region Request Mode Historical Usage Parameter Extension Methods
        public static string GetRequestModeHistoricalUsageParameterValidationString(this RequestModeHistoricalUsageParameter requestModeHistoricalUsageParameter, bool isCreateAction)
        {
            RequestModeHistoricalUsageParameterValidation requestModeHistoricalUsageParameterValidation = new RequestModeHistoricalUsageParameterValidation(requestModeHistoricalUsageParameter, isCreateAction);
            return requestModeHistoricalUsageParameterValidation.Message;
        }

        public static string GetTriStateValueById(this DataAccessLayerEntityFramework.RequestModeHistoricalUsageParameter requestModeHistoricalUsageParameter, RequestModeHistoricalUsageParameter id)
        {
            var db = new Lp_UtilityManagementEntities();
            var triStateValue = db.TriStateValues.Where(c => c.Id == id.IsBillingAccountNumberRequiredId).FirstOrDefault();
            db.Dispose();
            return triStateValue.Value;
        }

        public static bool IsRequestModeHistoricalUsageParameterValid(this RequestModeHistoricalUsageParameter requestModeHistoricalUsageParameter, bool isCreateAction)
        {
            RequestModeHistoricalUsageParameterValidation requestModeHistoricalUsageParameterValidation = new RequestModeHistoricalUsageParameterValidation(requestModeHistoricalUsageParameter, isCreateAction);
            return requestModeHistoricalUsageParameterValidation.IsValid;
        }

        public static void SetMessageForError(this RequestModeHistoricalUsageParameter requestModeHistoricalUsageParameter, string errorMessage)
        {
            RequestModeHistoricalUsageParameterValidation requestModeHistoricalUsageParameterValidation = new RequestModeHistoricalUsageParameterValidation(errorMessage);
        }
        #endregion



        #region Request Mode Icap Extention Methods
        public static string AddressForPreEnrollmentValidationMessage(this RequestModeIcap requestModeIcap)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(requestModeIcap.AddressForPreEnrollment))
                returnValue = "The Address For Pre Enrollment field is required.";
            else if (requestModeIcap.AddressForPreEnrollment.Length > 200)
                returnValue = "The Address field is too long.";

            return returnValue;
        }

        public static string EmailTemplateValidationMessage(this RequestModeIcap requestModeIcap)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(requestModeIcap.EmailTemplate))
                returnValue = "The Email Template field is required.";
            else if (requestModeIcap.EmailTemplate.Length > 200)
                returnValue = "The Email Template field is too long.";

            return returnValue;
        }

        public static string GetRequestModeIcapValidationString(this RequestModeIcap requestModeIcap, bool isCreateAction)
        {
            RequestModeIcapValidation requestModeIcapValidation = new RequestModeIcapValidation(requestModeIcap, isCreateAction);
            return requestModeIcapValidation.Message;
        }

        public static string InstructionValidationMessage(this RequestModeIcap requestModeIcap)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(requestModeIcap.Instructions))
                returnValue = "The Instructions field is required.";
            else if (requestModeIcap.Instructions.Length > 500)
                returnValue = "The Instructions field is too long.";

            return returnValue;
        }

        public static bool IsRequestModeIcapValid(this RequestModeIcap requestModeIcap, bool isCreateAction)
        {
            RequestModeIcapValidation requestModeIcapValidation = new RequestModeIcapValidation(requestModeIcap, isCreateAction);
            return requestModeIcapValidation.IsValid;
        }

        public static string LibertyPowersSlaFollowUpIcapResponseInDaysMessage(this RequestModeIcap requestModeIcap)
        {
            string returnValue = string.Empty;
            if (requestModeIcap.LibertyPowersSlaFollowUpIcapResponseInDays < 0)
                returnValue = "The Liberty Power SLA Response field is required.";

            return returnValue;
        }

        public static void SetMessageForError(this RequestModeIcap requestModeIcap, string errorMessage)
        {
            RequestModeIcapValidation requestModeIcapValidation = new RequestModeIcapValidation(errorMessage);
        }

        public static string ToString(this RequestModeIcap requestModeIcap)
        {
            string returnValue = string.Empty;
            if (requestModeIcap == null)
                returnValue = "requestModeIcap:[NULL]";
            else
                returnValue = string.Format("requestModeIcap:[Id:{0};UtilityCode:{1};RequestModeEnrollmentType:{2};AddressForPreEnrollment:{3};EmailTemplate:{4};Instructions:{5};UtilitysSlaIcapResponseInDays:{6};LibertyPowersSlaFollowUpIcapResponseInDays:{7};IsLoaRequired:{8};Inactive:{9};CreatedBy:{10};CreatedDate:{11};LastModifiedBy:{12};LastModifiedDate:{13}]",
                Common.NullSafeGuid(requestModeIcap.Id),
                Common.NullSafeString(requestModeIcap.UtilityCompany == null ? "NULL" : requestModeIcap.UtilityCompany.UtilityCode),
                Common.NullSafeString(requestModeIcap.RequestModeEnrollmentType == null ? "NULL" : requestModeIcap.RequestModeEnrollmentType.Name),
                Common.NullSafeString(requestModeIcap.AddressForPreEnrollment),
                Common.NullSafeString(requestModeIcap.EmailTemplate),
                Common.NullSafeString(requestModeIcap.Instructions),
                Common.NullSafeString(requestModeIcap.UtilitysSlaIcapResponseInDays),
                Common.NullSafeString(requestModeIcap.LibertyPowersSlaFollowUpIcapResponseInDays),
                Common.NullSafeString(requestModeIcap.IsLoaRequired),
                requestModeIcap.Inactive,
                Common.NullSafeString(requestModeIcap.CreatedBy),
                Common.NullSafeDateToString(requestModeIcap.CreatedDate),
                Common.NullSafeString(requestModeIcap.LastModifiedBy),
                Common.NullSafeDateToString(requestModeIcap.LastModifiedDate));
            return returnValue;
        }

        public static string UtilitysSlaIcapResponseInDaysValidationMessage(this RequestModeIcap requestModeIcap)
        {
            string returnValue = string.Empty;
            if (requestModeIcap.UtilitysSlaIcapResponseInDays < 0)
                returnValue = "The Utility SLA Response field is required.";

            return returnValue;
        }
        #endregion



        #region Request Mode Idr Extension Methods
        public static string AddressForPreEnrollmentValidationMessage(this RequestModeIdr requestModeIdr)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(requestModeIdr.AddressForPreEnrollment))
                returnValue = "The Address For Pre Enrollment field is required.";
            else if (requestModeIdr.AddressForPreEnrollment.Length > 200)
                returnValue = "The Address field is too long.";

            return returnValue;
        }

        public static string EmailTemplateValidationMessage(this RequestModeIdr requestModeIdr)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(requestModeIdr.EmailTemplate))
                returnValue = "The Email Template field is required.";
            else if (requestModeIdr.EmailTemplate.Length > 200)
                returnValue = "The Email Template field is too long.";

            return returnValue;
        }

        public static string GetRequestModeIdrValidationString(this RequestModeIdr requestModeIdr, bool isCreateAction)
        {
            RequestModeIdrValidation requestModeIdrValidation = new RequestModeIdrValidation(requestModeIdr, isCreateAction);
            return requestModeIdrValidation.Message;
        }

        public static string InstructionValidationMessage(this RequestModeIdr requestModeIdr)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(requestModeIdr.Instructions))
                returnValue = "The Instructions field is required.";
            else if (requestModeIdr.Instructions.Length > 500)
                returnValue = "The Instructions field is too long.";

            return returnValue;
        }

        public static bool IsRequestModeIdrValid(this RequestModeIdr requestModeIdr, bool isCreateAction)
        {
            RequestModeIdrValidation requestModeIdrValidation = new RequestModeIdrValidation(requestModeIdr, isCreateAction);
            return requestModeIdrValidation.IsValid;
        }

        public static string LibertyPowersSlaFollowUpIdrResponseInDaysValidationMessage(this RequestModeIdr requestModeIdr)
        {
            string returnValue = string.Empty;
            if (requestModeIdr.LibertyPowersSlaFollowUpIdrResponseInDays < 0)
                returnValue = "The Liberty Power SLA Response field is required.";

            return returnValue;
        }

        public static string RequestCostAccountValidationMessage(this RequestModeIdr requestModeIdr)
        {
            string returnValue = string.Empty;
            if (requestModeIdr.RequestCostAccount < 0)
                returnValue = "The Request Cost Account field is required.";

            return returnValue;
        }

        public static string UtilitysSlaIdrResponseInDaysValidationMessage(this RequestModeIdr requestModeIdr)
        {
            string returnValue = string.Empty;
            if (requestModeIdr.UtilitysSlaIdrResponseInDays < 0)
                returnValue = "The Utility SLA Response field is required.";

            return returnValue;
        }
        #endregion



        #region Request Mode Type Extension Methods
        public static string GetRequestModeTypeValidationString(this RequestModeType requestModeType)
        {
            RequestModeTypeValidation requestModeTypeValidation = new RequestModeTypeValidation(requestModeType);
            return requestModeTypeValidation.Message;
        }

        public static bool IsRequestModeTypeValid(this RequestModeType requestModeType)
        {
            RequestModeTypeValidation requestModeTypeValidation = new RequestModeTypeValidation(requestModeType);
            return requestModeTypeValidation.IsValid;
        }
        #endregion



        #region Request Mode Type Genre Extension Methods
        public static string GetRequestModeTypeGenreValidationString(this RequestModeTypeGenre requestModeTypeGenre)
        {
            RequestModeTypeGenreValidation requestModeTypeGenreValidation = new RequestModeTypeGenreValidation(requestModeTypeGenre);
            return requestModeTypeGenreValidation.Message;
        }

        public static bool IsRequestModeTypeGenreValid(this RequestModeTypeGenre requestModeTypeGenre)
        {
            RequestModeTypeGenreValidation requestModeTypeGenreValidation = new RequestModeTypeGenreValidation(requestModeTypeGenre);
            return requestModeTypeGenreValidation.IsValid;
        }
        #endregion



        #region Request Mode Type To Request Mode Enrollment Type Extension Methods
        public static string GetRequestModeTypeToRequestModeEnrollmentTypeValidationString(this RequestModeTypeToRequestModeEnrollmentType requestModeTypeToRequestModeEnrollmentType)
        {
            RequestModeTypeToRequestModeEnrollmentTypeValidation requestModeTypeToRequestModeEnrollmentTypeValidation = new RequestModeTypeToRequestModeEnrollmentTypeValidation(requestModeTypeToRequestModeEnrollmentType);
            return requestModeTypeToRequestModeEnrollmentTypeValidation.Message;
        }

        public static bool IsRequestModeTypeToRequestModeEnrollmentTypeValidationValid(this RequestModeTypeToRequestModeEnrollmentType requestModeTypeToRequestModeEnrollmentType)
        {
            RequestModeTypeToRequestModeEnrollmentTypeValidation requestModeTypeToRequestModeEnrollmentTypeValidation = new RequestModeTypeToRequestModeEnrollmentTypeValidation(requestModeTypeToRequestModeEnrollmentType);
            return requestModeTypeToRequestModeEnrollmentTypeValidation.IsValid;
        }
        #endregion



        #region Request Mode Type To Request Mode Type Genre Extension Methods
        public static string GetRequestModeTypeToRequestModeTypeGenreValidationString(this RequestModeTypeToRequestModeTypeGenre requestModeTypeToRequestModeTypeGenre)
        {
            RequestModeTypeToRequestModeTypeGenreValidation requestModeTypeToRequestModeTypeGenreValidation = new RequestModeTypeToRequestModeTypeGenreValidation(requestModeTypeToRequestModeTypeGenre);
            return requestModeTypeToRequestModeTypeGenreValidation.Message;
        }

        public static bool IsRequestModeTypeToRequestModeTypeGenreValidationValid(this RequestModeTypeToRequestModeTypeGenre requestModeTypeToRequestModeTypeGenre)
        {
            RequestModeTypeToRequestModeTypeGenreValidation requestModeTypeToRequestModeTypeGenreValidation = new RequestModeTypeToRequestModeTypeGenreValidation(requestModeTypeToRequestModeTypeGenre);
            return requestModeTypeToRequestModeTypeGenreValidation.IsValid;
        }
        #endregion


        // TariffCode Extention Methods
        #region Tariff Code Extension Methods
        public static string DescriptionValidationMessage(this TariffCode TariffCode)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(TariffCode.Description))
                returnValue = "The Description field is required.";
            else if (TariffCode.Description.Length > 255)
                returnValue = "The Description field is too long.";

            return returnValue;
        }

        public static string GetTariffCodeValidationString(this TariffCode TariffCode)
        {
            TariffCodeValidation TariffCodeValidation = new TariffCodeValidation(TariffCode);
            return TariffCodeValidation.Message;
        }

        public static bool IsTariffCodeValid(this TariffCode TariffCode)
        {
            TariffCodeValidation TariffCodeValidation = new TariffCodeValidation(TariffCode);
            return TariffCodeValidation.IsValid;
        }

        public static string LpStandardTariffCodeValidationMessage(this TariffCode TariffCode)
        {
            string returnValue = string.Empty;
            if (Common.IsValidGuid(TariffCode.LpStandardTariffCodeId))
                returnValue = "The Liberty Power Standard Tariff Code field is required.";

            return returnValue;
        }

        public static string TariffCodeCodeValidationMessage(this TariffCode TariffCode)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(TariffCode.TariffCodeCode))
                returnValue = "The Tariff Code field is required.";
            else if (TariffCode.TariffCodeCode.Length > 255)
                returnValue = "The Tariff Code field is too long.";

            return returnValue;
        }

        public static string TariffCodeIdValidationMessage(this TariffCode TariffCode)
        {
            string returnValue = string.Empty;
            if (TariffCode.TariffCodeId <= 0)
                returnValue = "The Tariff Code Id field is invalid.";

            return returnValue;
        }
        #endregion



        #region Tariff Code Alias Extension Methods
        public static bool IsTariffCodeAliasValid(this TariffCodeAlia TariffCodes)
        {
            TariffCodeAliasValidation TariffCodeAliasValidation = new TariffCodeAliasValidation(TariffCodes);
            return TariffCodeAliasValidation.IsValid;
        }

        public static string TariffCodeCodeValidationMessage(this TariffCodeAlia TariffCodeAlias)
        {
            string returnValue = string.Empty;
            if (string.IsNullOrWhiteSpace(TariffCodeAlias.TariffCodeCodeAlias))
                returnValue = "The Tariff Code Alias field is required.";
            else if (TariffCodeAlias.TariffCodeCodeAlias.Length > 255)
                returnValue = "The Tariff Code Alias field is too long.";

            return returnValue;
        }

        public static string TariffCodeCodeAliasValidationMessage(this TariffCodeAlia TariffCodeAlias)
        {
            return TariffCodeCodeValidationMessage(TariffCodeAlias);
        }
        #endregion


        #region Sevice Account Pattern Extension Methods
        public static bool IsServiceAccountPatternValid(this ServiceAccountPattern serviceAccountPattern)
        {
            bool isServiceAccountPatternNotNull = serviceAccountPattern != null;
            bool isServiceAccountPatternCreatedByValid = IsValidString(serviceAccountPattern.CreatedBy);
            bool isServiceAccountPatternCreatedDateValid = IsValidDate(serviceAccountPattern.CreatedDate);
            bool isServiceAccountPatternLastModifiedByValid = IsValidString(serviceAccountPattern.LastModifiedBy);
            bool isServiceAccountPatternLastModifiedDateValid = IsValidDate(serviceAccountPattern.LastModifiedDate);
            bool isServiceAccountPatternUtilityCodeValid = IsValidGuid(serviceAccountPattern.UtilityCompanyId);

            bool isServiceAccountPatternServiceAccountPatternValid = IsValidString(serviceAccountPattern.ServiceAccountPattern1);
            bool isServiceAccountPatternServiceAccountPatternDescriptionValid = IsValidString(serviceAccountPattern.ServiceAccountPatternDescription);
            bool isServiceAccountPatternServiceAccountAddLeadingZeroValid = serviceAccountPattern.ServiceAccountAddLeadingZero == null || serviceAccountPattern.ServiceAccountAddLeadingZero >= 0;
            bool isServiceAccountPatternServiceAccountTruncateLastValid = serviceAccountPattern.ServiceAccountTruncateLast == null || serviceAccountPattern.ServiceAccountTruncateLast >= 0;

            return (
                isServiceAccountPatternNotNull &&
                isServiceAccountPatternCreatedByValid &&
                isServiceAccountPatternCreatedDateValid &&
                isServiceAccountPatternLastModifiedByValid &&
                isServiceAccountPatternLastModifiedDateValid &&
                isServiceAccountPatternUtilityCodeValid &&
                isServiceAccountPatternServiceAccountPatternValid &&
                isServiceAccountPatternServiceAccountPatternDescriptionValid
                );
        }        
        #endregion


        #region Sevice Address Zip Pattern Extension Methods
        public static bool IsServiceAddressZipPatternValid(this ServiceAddressZipPattern serviceAddressZipPattern)
        {
            bool isServiceAddressZipPatternNotNull = serviceAddressZipPattern != null;
            bool isServiceAddressZipPatternCreatedByValid = IsValidString(serviceAddressZipPattern.CreatedBy);
            bool isServiceAddressZipPatternCreatedDateValid = IsValidDate(serviceAddressZipPattern.CreatedDate);
            bool isServiceAddressZipPatternLastModifiedByValid = IsValidString(serviceAddressZipPattern.LastModifiedBy);
            bool isServiceAddressZipPatternLastModifiedDateValid = IsValidDate(serviceAddressZipPattern.LastModifiedDate);
            bool isServiceAddressZipPatternUtilityCodeValid = IsValidGuid(serviceAddressZipPattern.UtilityCompanyId);

            bool isServiceAddressZipPatternServiceAddressZipPatternValid = IsValidString(serviceAddressZipPattern.ServiceAddressZipPattern1);
            bool isServiceAddressZipPatternServiceAddressZipPatternDescriptionValid = IsValidString(serviceAddressZipPattern.ServiceAddressZipPatternDescription);
            bool isServiceAddressZipPatternServiceAddressZipAddLeadingZeroValid = serviceAddressZipPattern.ServiceAddressZipAddLeadingZero == null || serviceAddressZipPattern.ServiceAddressZipAddLeadingZero >= 0;
            bool isServiceAddressZipPatternServiceAddressZipTruncateLastValid = serviceAddressZipPattern.ServiceAddressZipTruncateLast == null || serviceAddressZipPattern.ServiceAddressZipTruncateLast >= 0;

            return (
                isServiceAddressZipPatternNotNull &&
                isServiceAddressZipPatternCreatedByValid &&
                isServiceAddressZipPatternCreatedDateValid &&
                isServiceAddressZipPatternLastModifiedByValid &&
                isServiceAddressZipPatternLastModifiedDateValid &&
                isServiceAddressZipPatternUtilityCodeValid &&
                isServiceAddressZipPatternServiceAddressZipPatternValid &&
                isServiceAddressZipPatternServiceAddressZipPatternDescriptionValid
                );
        }
        #endregion


        #region Strata Pattern Extension Methods
        public static bool IsStrataPatternValid(this StrataPattern strataPattern)
        {
            bool isStrataPatternNotNull = strataPattern != null;
            bool isStrataPatternCreatedByValid = IsValidString(strataPattern.CreatedBy);
            bool isStrataPatternCreatedDateValid = IsValidDate(strataPattern.CreatedDate);
            bool isStrataPatternLastModifiedByValid = IsValidString(strataPattern.LastModifiedBy);
            bool isStrataPatternLastModifiedDateValid = IsValidDate(strataPattern.LastModifiedDate);
            bool isStrataPatternUtilityCodeValid = IsValidGuid(strataPattern.UtilityCompanyId);

            bool isStrataPatternStrataPatternValid = IsValidString(strataPattern.StrataPattern1);
            bool isStrataPatternStrataPatternDescriptionValid = IsValidString(strataPattern.StrataPatternDescription);
            bool isStrataPatternStrataAddLeadingZeroValid = strataPattern.StrataAddLeadingZero == null || strataPattern.StrataAddLeadingZero >= 0;
            bool isStrataPatternStrataTruncateLastValid = strataPattern.StrataTruncateLast == null || strataPattern.StrataTruncateLast >= 0;

            return (
                isStrataPatternNotNull &&
                isStrataPatternCreatedByValid &&
                isStrataPatternCreatedDateValid &&
                isStrataPatternLastModifiedByValid &&
                isStrataPatternLastModifiedDateValid &&
                isStrataPatternUtilityCodeValid &&
                isStrataPatternStrataPatternValid &&
                isStrataPatternStrataPatternDescriptionValid
                );
        }
        #endregion


        #region ICap TCap Refresh Extension Methods
        public static bool IsICapTCapRefreshValid(this ICapTCapRefresh iCapTCapRefresh)
        {
            bool isICapTCapRefreshNotNull = iCapTCapRefresh != null;
            bool isICapTCapRefreshCreatedByValid = IsValidString(iCapTCapRefresh.CreatedBy);
            bool isICapTCapRefreshCreatedDateValid = IsValidDate(iCapTCapRefresh.CreatedDate);
            bool isICapTCapRefreshLastModifiedByValid = IsValidString(iCapTCapRefresh.LastModifiedBy);
            bool isICapTCapRefreshLastModifiedDateValid = IsValidDate(iCapTCapRefresh.LastModifiedDate);
            bool isICapTCapRefreshUtilityCodeValid = IsValidGuid(iCapTCapRefresh.UtilityCompanyId);
            bool isICapNextRefreshValid = IsICapNextRefreshValid(iCapTCapRefresh); 
            bool isICapEffectiveDateValid = IsICapEffectiveDateValid(iCapTCapRefresh); 
            bool isTCapNextRefreshValid = IsTCapNextRefreshValid(iCapTCapRefresh); 
            bool isTCapEffectiveDateValid = IsTCapEffectiveDateValid(iCapTCapRefresh); 

            return (
                isICapTCapRefreshNotNull &&
                isICapTCapRefreshCreatedByValid &&
                isICapTCapRefreshCreatedDateValid &&
                isICapTCapRefreshLastModifiedByValid &&
                isICapTCapRefreshLastModifiedDateValid &&
                isICapTCapRefreshUtilityCodeValid &&
                isICapNextRefreshValid &&
                isICapEffectiveDateValid &&
                isTCapNextRefreshValid &&
                isTCapEffectiveDateValid 
                );
        }

        public static bool IsICapNextRefreshValid(this ICapTCapRefresh iCapTCapRefresh)
        {
            bool isICapTCapRefreshNotNull = iCapTCapRefresh != null;
            int tempICapNextRefresh = 0;
            bool isICapNextRefreshValid = IsValidString(iCapTCapRefresh.ICapNextRefresh) && iCapTCapRefresh.ICapNextRefresh.Length == 4 && int.TryParse(iCapTCapRefresh.ICapNextRefresh.Substring(0, 2), out tempICapNextRefresh) && tempICapNextRefresh > 0 && tempICapNextRefresh < 13 && int.TryParse(iCapTCapRefresh.ICapNextRefresh.Substring(2, 2), out tempICapNextRefresh) && tempICapNextRefresh > 0 && tempICapNextRefresh <= 31; // && iCapTCapRefresh.ICapNextRefresh.Substring(2, 1) == "/";

            return (
                isICapTCapRefreshNotNull &&
                isICapNextRefreshValid
                );
        }

        public static bool IsICapEffectiveDateValid(this ICapTCapRefresh iCapTCapRefresh)
        {
            bool isICapTCapRefreshNotNull = iCapTCapRefresh != null;
            int tempICapEffectiveDate = 0;
            bool isICapEffectiveDateValid = IsValidString(iCapTCapRefresh.ICapEffectiveDate) && iCapTCapRefresh.ICapEffectiveDate.Length == 4 && int.TryParse(iCapTCapRefresh.ICapEffectiveDate.Substring(0, 2), out tempICapEffectiveDate) && tempICapEffectiveDate > 0 && tempICapEffectiveDate < 13 && int.TryParse(iCapTCapRefresh.ICapEffectiveDate.Substring(2, 2), out tempICapEffectiveDate) && tempICapEffectiveDate > 0 && tempICapEffectiveDate <= 31; // && iCapTCapRefresh.ICapEffectiveDate.Substring(2, 1) == "/";

            return (
                isICapTCapRefreshNotNull &&
                isICapEffectiveDateValid
                );
        }

        public static bool IsTCapNextRefreshValid(this ICapTCapRefresh tCapTCapRefresh)
        {
            bool isTCapTCapRefreshNotNull = tCapTCapRefresh != null;
            int tempTCapNextRefresh = 0;
            bool isTCapNextRefreshValid = IsValidString(tCapTCapRefresh.TCapNextRefresh) && tCapTCapRefresh.TCapNextRefresh.Length == 4 && int.TryParse(tCapTCapRefresh.TCapNextRefresh.Substring(0, 2), out tempTCapNextRefresh) && tempTCapNextRefresh > 0 && tempTCapNextRefresh < 13 && int.TryParse(tCapTCapRefresh.TCapNextRefresh.Substring(2, 2), out tempTCapNextRefresh) && tempTCapNextRefresh > 0 && tempTCapNextRefresh <= 31; // && tCapTCapRefresh.TCapNextRefresh.Substring(2, 1) == "/";

            return (
                isTCapTCapRefreshNotNull &&
                isTCapNextRefreshValid
                );
        }

        public static bool IsTCapEffectiveDateValid(this ICapTCapRefresh iCapTCapRefresh)
        {
            bool isICapTCapRefreshNotNull = iCapTCapRefresh != null;
            int tempTCapEffectiveDate = 0;
            bool isTCapEffectiveDateValid = IsValidString(iCapTCapRefresh.TCapEffectiveDate) && iCapTCapRefresh.TCapEffectiveDate.Length == 4 && int.TryParse(iCapTCapRefresh.TCapEffectiveDate.Substring(0, 2), out tempTCapEffectiveDate) && tempTCapEffectiveDate > 0 && tempTCapEffectiveDate < 13 && int.TryParse(iCapTCapRefresh.TCapEffectiveDate.Substring(2, 2), out tempTCapEffectiveDate) && tempTCapEffectiveDate > 0 && tempTCapEffectiveDate <= 31; // && iCapTCapRefresh.TCapEffectiveDate.Substring(2, 1) == "/";

            return (
                isICapTCapRefreshNotNull &&
                isTCapEffectiveDateValid
                );
        }

        #endregion



        #region Utility Company Extension Methods
        public static string GetUtilityCompanyValidationString(this UtilityCompany utilityCompany)
        {
            StringBuilder message = new StringBuilder();
            bool isUtilityCompanyNotNull = utilityCompany != null;
            bool isUtilityCompanyCreatedByValid = IsValidString(utilityCompany.CreatedBy);
            bool isUtilityCompanyCreatedDateValid = IsValidDate(utilityCompany.CreatedDate);
            bool isUtilityCompanyLastModifiedByValid = IsValidString(utilityCompany.LastModifiedBy);
            bool isUtilityCompanyLastModifiedDateValid = IsValidDate(utilityCompany.LastModifiedDate);
            bool isUtilityCompanyUtilityCodeValid = IsValidString(utilityCompany.UtilityCode);
            bool isUtilityCompanyFullNameValid = IsValidString(utilityCompany.FullName);
            bool isUtilityCompanyIsoValid = IsValidGuid(utilityCompany.IsoId);
            bool isUtilityCompanyMarketIdValid = IsValidGuid(utilityCompany.MarketId);
            bool isUtilityCompanyUtilityStatusIdValid = IsValidGuid(utilityCompany.UtilityStatusId);
            bool isUtilityCompanyPrimaryDunsNumberValid = IsValidString(utilityCompany.PrimaryDunsNumber);
            bool isUtilityCompanyLpEntityId = IsValidString(utilityCompany.LpEntityId);
            bool isUtilityCompanyUtilityStatusValid = IsValidGuid(utilityCompany.UtilityStatusId);
            bool isUtilityCompanyEnrollmentLeadDaysValid = utilityCompany.EnrollmentLeadDays != null && utilityCompany.EnrollmentLeadDays > -1;
            bool isUtilityCompanyBillingTypeIdValid = IsValidGuid(utilityCompany.BillingTypeId);

            if (!isUtilityCompanyNotNull)
                message.Append("Invalid Data Model! ");
            if (!isUtilityCompanyCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!isUtilityCompanyCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!isUtilityCompanyLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!isUtilityCompanyLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!isUtilityCompanyUtilityCodeValid)
                message.Append("Invalid Value For Utility Code! ");

            return message.ToString();
        }

        public static bool IsUtilityCompanyValid(this UtilityCompany utilityCompany)
        {
            bool isUtilityCompanyNotNull = utilityCompany != null;
            bool isUtilityCompanyCreatedByValid = IsValidString(utilityCompany.CreatedBy);
            bool isUtilityCompanyCreatedDateValid = IsValidDate(utilityCompany.CreatedDate);
            bool isUtilityCompanyLastModifiedByValid = IsValidString(utilityCompany.LastModifiedBy);
            bool isUtilityCompanyLastModifiedDateValid = IsValidDate(utilityCompany.LastModifiedDate);
            bool isUtilityCompanyUtilityCodeValid = IsValidString(utilityCompany.UtilityCode);
            bool isUtilityCompanyIsoIdValid = IsValidGuid(utilityCompany.IsoId);
            bool isUtilityCompanyMarketIdValid = IsValidGuid(utilityCompany.MarketId);
            bool isUtilityCompanyUtilityStatusIdValid = IsValidGuid(utilityCompany.UtilityStatusId);
            bool isUtilityCompanyPrimaryDunsNumberValid = IsValidString(utilityCompany.PrimaryDunsNumber);
            bool isUtilityCompanyLpEntityIdValid = IsValidString(utilityCompany.LpEntityId);
            bool isUtilityCompanyUtilityStatusValid = IsValidGuid(utilityCompany.UtilityStatusId);
            bool isUtilityCompanyEnrollmentLeadDaysValid = utilityCompany.EnrollmentLeadDays != null && utilityCompany.EnrollmentLeadDays > -1;
            bool isUtilityCompanyBillingTypeIdValid = IsValidGuid(utilityCompany.BillingTypeId);
            bool isUtilityCompanyAccountLengthValid = utilityCompany.AccountLength != null && utilityCompany.AccountLength > -1;
            bool isUtilityCompanyMeterNumberLengthValid = utilityCompany.MeterNumberLength != null && utilityCompany.MeterNumberLength > -1;
            bool isUtilityCompanyFullName = IsValidString(utilityCompany.FullName);

            return (
                isUtilityCompanyNotNull && 
                isUtilityCompanyCreatedByValid &&
                isUtilityCompanyCreatedDateValid && 
                isUtilityCompanyLastModifiedByValid &&
                isUtilityCompanyLastModifiedDateValid && 
                isUtilityCompanyUtilityCodeValid &&
                isUtilityCompanyIsoIdValid && 
                isUtilityCompanyMarketIdValid && 
                isUtilityCompanyUtilityStatusIdValid &&
                isUtilityCompanyPrimaryDunsNumberValid &&
                isUtilityCompanyLpEntityIdValid &&
                isUtilityCompanyUtilityStatusValid &&
                isUtilityCompanyEnrollmentLeadDaysValid &&
                isUtilityCompanyBillingTypeIdValid &&
                isUtilityCompanyAccountLengthValid &&
                isUtilityCompanyMeterNumberLengthValid &&
                isUtilityCompanyFullName
                );
        }
        #endregion




        #region User Objects Extension Methods
        public static bool IsUserInterfaceFormValid(this UserInterfaceForm userInterfaceForm)
        {
            UserInterfaceFormValidation userInterfaceFormValidation = new UserInterfaceFormValidation(userInterfaceForm);
            return userInterfaceFormValidation.IsValid;
        }

        public static string GetUserInterfaceFormValidationString(this UserInterfaceForm userInterfaceForm)
        {
            UserInterfaceFormValidation userInterfaceFormValidation = new UserInterfaceFormValidation(userInterfaceForm);
            return userInterfaceFormValidation.Message;
        }



        public static bool IsUserInterfaceFormControlValid(this UserInterfaceFormControl userInterfaceFormControl)
        {
            UserInterfaceFormControlValidation userInterfaceFormControlValidation = new UserInterfaceFormControlValidation(userInterfaceFormControl);
            return userInterfaceFormControlValidation.IsValid;
        }

        public static string GetUserInterfaceFormControlValidationString(this UserInterfaceFormControl userInterfaceFormControl)
        {
            UserInterfaceFormControlValidation userInterfaceFormControlValidation = new UserInterfaceFormControlValidation(userInterfaceFormControl);
            return userInterfaceFormControlValidation.Message;
        }



        public static bool IsUserInterfaceControlVisibilityValid(this UserInterfaceControlVisibility userInterfaceControlVisibility)
        {
            UserInterfaceControlVisibilityValidation userInterfaceControlVisibilityValidation = new UserInterfaceControlVisibilityValidation(userInterfaceControlVisibility);
            return userInterfaceControlVisibilityValidation.IsValid;
        }

        public static string GetUserInterfaceControlVisibilityValidationString(this UserInterfaceControlVisibility userInterfaceControlVisibility)
        {
            UserInterfaceControlVisibilityValidation userInterfaceControlVisibilityValidation = new UserInterfaceControlVisibilityValidation(userInterfaceControlVisibility);
            return userInterfaceControlVisibilityValidation.Message;
        }



        public static bool IsUserInterfaceControlAndValueGoverningControlVisibilityValid(this UserInterfaceControlAndValueGoverningControlVisibility userInterfaceControlAndValueGoverningControlVisibility)
        {
            UserInterfaceControlAndValueGoverningControlVisibilityValidation userInterfaceControlAndValueGoverningControlVisibilityValidation = new UserInterfaceControlAndValueGoverningControlVisibilityValidation(userInterfaceControlAndValueGoverningControlVisibility);
            return userInterfaceControlAndValueGoverningControlVisibilityValidation.IsValid;
        }

        public static string GetuserInterfaceControlAndValueGoverningControlVisibilityValidationString(this UserInterfaceControlAndValueGoverningControlVisibility userInterfaceControlAndValueGoverningControlVisibility)
        {
            UserInterfaceControlAndValueGoverningControlVisibilityValidation userInterfaceControlAndValueGoverningControlVisibilityValidation = new UserInterfaceControlAndValueGoverningControlVisibilityValidation(userInterfaceControlAndValueGoverningControlVisibility);
            return userInterfaceControlAndValueGoverningControlVisibilityValidation.Message;
        }
        #endregion



        #region General Methods
        public static bool IsValidString(string value)
        {
            bool returnValue = !string.IsNullOrWhiteSpace(value);
            return returnValue;
        }


        public static bool IsValidDate(DateTime dateTime)
        {
            bool returnValue = dateTime != null && dateTime > new DateTime(2001, 1, 1);
            return returnValue;
        }

        public static bool IsValidGuid(Guid guid)
        {
            bool returnValue = guid != null && guid != Guid.Empty;
            return returnValue;
        }

        public static bool IsValidGuid(Guid? guid)
        {
            bool returnValue = guid != null && guid != Guid.Empty;
            return returnValue;
        }

        #endregion
    }
}