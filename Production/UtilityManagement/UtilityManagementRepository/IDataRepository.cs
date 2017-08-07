using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Common;
using System.Data.Entity;
using System.Data.Entity.Design;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Validation;
using System.Data.Objects;
using System.Data.Objects.DataClasses;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UtilityManagementServiceData;

namespace UtilityManagementRepository
{
    public interface IDataRepository : IDisposable, IObjectContextAdapter
    {
        string MessageId { get; set; }
        List<usp_IdrRule_IntegratedWithTariffCode_Result> usp_IdrRule_Integrated(string messageId, string rateClassCode, string loadProfileCode, string tariffCodeCode, bool? eligibility, bool? hia, int? utilityIdInt, int? usage);
        string GetZoneByUtilityCodeAndZipCodeFromDealCapture(string messageId, string utilityCode, string zipCode);
        string GetZoneByAccountNumberFromErcot(string messageId, string accountNumber);
        List<RequestModeEnrollmentType> RequestModeEnrollmentTypes { get; }
        List<RequestModeHistoricalUsage> RequestModeHistoricalUsages { get; }
        List<RequestModeIcap> RequestModeIcaps { get; }
        List<RequestModeIdr> RequestModeIdrs { get; }
        List<RequestModeType> RequestModeTypes { get; }
        List<RequestModeTypeGenre> RequestModeTypeGenres { get; }
        List<RequestModeTypeToRequestModeEnrollmentType> RequestModeTypeToRequestModeEnrollmentTypes { get; }
        List<RequestModeTypeToRequestModeTypeGenre> RequestModeTypeToRequestModeTypeGenres { get; }
        List<UtilityCompany> UtilityCompanies { get; }
        List<CustomerAccountType> CustomerAccountTypes { get; }
        List<UserInterfaceControlAndValueGoverningControlVisibility> UserInterfaceControlAndValueGoverningControlVisibilities { get; }
        List<UserInterfaceControlVisibility> UserInterfaceControlVisibilities { get; }
        List<UserInterfaceForm> UserInterfaceForms { get; }
        List<UserInterfaceFormControl> UserInterfaceFormControls { get; }
        List<zAuditRequestModeHistoricalUsage> zAuditRequestModeHistoricalUsages { get; }
        List<zAuditUtilityCompany> zAuditUtilityCompanies { get; }
        List<UtilityLegacy> UtilityLegacies { get; }
        List<UtilityCompanyToUtilityLegacy> UtilityCompanyToUtilityLegacies { get; }
        ObjectResult<Nullable<int>> usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIds(string requestModeEnrollmentTypeId, string utilityCompanyId);
        ObjectResult<string> usp_RequestModeEnrollmentType_SELECT_NameById(string id);
        ObjectResult<string> usp_RequestModeType_SELECT_NameById(string id);
        ObjectResult<usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId_Result> usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId(string requestModeEnrollmentTypeId);
        ObjectResult<usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName_Result> usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName(string requestModeEnrollmentTypeId, string requestModeTypeGenreName);
        ObjectResult<usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm_Result> usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm(string formName);
        //ObjectResult<usp_PurchaseOfReceivables_SELECT_ByUtilityAndPorDriver1_Result> usp_PurchaseOfReceivables_SELECT_ByUtilityAndPorDriver(string messageId, int utilityIdInt, DateTime porEffectiveDate, Guid porDriverId, string porDriver);
        ObjectResult<usp_PurchaseOfReceivables_SELECT_ByUtilityLoadProfileRateClassTariffCodeEffectiveDate_Result> usp_PurchaseOfReceivables_SELECT_ByUtilityLoadProfileRateClassTariffCodeEffectiveDate(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode, DateTime porEffectiveDate);
        ObjectResult<usp_IdrRuleAndRequestMode_SelectByParams_Result> usp_IdrRuleAndRequestMode_SelectByParams(string messageId, int utilityIdInt, string rateClass, string loadProfile, string annualUsage, string enrollmentType, bool? isHia);
        ObjectResult<usp_IdrRuleAndRequestMode_SelectByParamWithTariffCode_Result> usp_IdrRuleAndRequestMode_SelectByParam(string messageId, int utilityIdInt, string rateClass, string loadProfile, string tariffCode, string annualUsage, int enrollmentType, bool? isHia);
        ObjectResult<usp_AccountInfoFieldRequired_GetByUtility_Result> usp_AccountInfoFieldRequired_GetByUtility(string messageId);
        ObjectResult<int?> usp_BillingType_RetrieveByUtilityRateClassLoadProfileTariffCode(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode);
        DataSet usp_BillingTypeWithDefault_RetrieveByUtilityRateClassLoadProfileTariffCode(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode);
        ObjectResult<Nullable<int>> usp_IdrRule_InsufficientInformation(string messageId, int utilityIdInt, string rateClass, string loadProfile, string annualUsage, bool? isOnEligibilityList, bool? isHia);
        DateTime? usp_MeterReadSchedule_GetNext(string messageId, int utilityIdInt, string tripNumber, DateTime referenceDate, string serviceAccountNumber);
        DbChangeTracker ChangeTracker { get; }
        DbContextConfiguration Configuration { get; }
        Database Database { get; }
        DbEntityEntry Entry(object entity);
        DbEntityEntry<TEntity> Entry<TEntity>(TEntity entity) where TEntity : class;
        [EditorBrowsable(EditorBrowsableState.Never)]
        bool Equals(object obj);
        [EditorBrowsable(EditorBrowsableState.Never)]
        int GetHashCode();
        [EditorBrowsable(EditorBrowsableState.Never)]
        Type GetType();
        IEnumerable<DbEntityValidationResult> GetValidationErrors();
        int SaveChanges();
        [EditorBrowsable(EditorBrowsableState.Never)]
        string ToString();
        bool usp_UtilityCompany_DoesUtilityCodeBelongToIso(string messageId, string Iso, string UtilityCode);
        List<usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequest_Result> usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequest(string messageId, string rateClassCode, string loadProfileCode, string tariffCodeCode, bool? eligibility, bool? hia, int? utilityIdInt, int? usage, EnrollmentType enrollmentType);
        List<usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequestAsSeparateField_Result> usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequestAsSeparateField(string messageId, string rateClassCode, string loadProfileCode, string tariffCodeCode, bool? eligibility, bool? hia, int? utilityIdInt, int? usage, EnrollmentType enrollmentType);

        DataSet usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists(string messageId, Guid utilityId, Guid porDriverId, Guid loadProfileId,
            Guid rateClassId, Guid tariffCodeId, Guid utilityOfferedBillingTypeId);
        DataSet usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists_ByValue(string messageId, string utilityCode, string porDriver, string loadProfileCode,
            string rateClassCode, string tariffCodeCode, string utilityOfferedBillingType, string lpApprovedBillingType);
        DataSet usp_LpStandardTariffCode_UPSERT(string messageId, string id, string utilityCode, string lpStandardTariffCode, bool inactive, string user);
        DataSet usp_TariffCode_UPSERT(string messageId, string id, string utilityCode, string lpStandardTariffCode, string tariffCode, string description, string accountType, bool inactive, string user);
        DataSet usp_TariffCodeAlias_UPSERT(string messageId, string id, string utilityCode, int tariffCodeId, string tariffCodeCodeAlias, bool inactive, string user);

        DataSet usp_LpStandardLoadProfile_UPSERT(string messageId, string id, string utilityCode, string lpStandardLoadProfile, bool inactive, string user);
        DataSet usp_LoadProfile_UPSERT(string messageId, string id, string utilityCode, string lpStandardLoadProfile, string loadProfile, string description, string accountType, bool inactive, string user);
        DataSet usp_LoadProfileAlias_UPSERT(string messageId, string id, string utilityCode, int loadProfileId, string loadProfileCodeAlias, bool inactive, string user);

        DataSet usp_LpStandardRateClass_UPSERT(string messageId, string id, string utilityCode, string lpStandardRateClass, bool inactive, string user);
        DataSet usp_RateClass_UPSERT(string messageId, string id, string utilityCode, string lpStandardRateClass, string rateClass, string description, string accountType, bool inactive, string user);
        DataSet usp_RateClassAlias_UPSERT(string messageId, string id, string utilityCode, int rateClassId, string rateClassCodeAlias, bool inactive, string user);

        DataSet usp_LpStandardTariffCode_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_TariffCode_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_TariffCodeAlias_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_LpStandardTariffCode_GetAll(string messageId);
        DataSet usp_TariffCode_GetAll(string messageId);
        DataSet usp_TariffCodeAlias_GetAll(string messageId);

        DataSet usp_LpStandardRateClass_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_RateClass_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_RateClassAlias_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_LpStandardRateClass_GetAll(string messageId);
        DataSet usp_RateClass_GetAll(string messageId);
        DataSet usp_RateClassAlias_GetAll(string messageId);

        DataSet usp_LpStandardLoadProfile_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_LoadProfile_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_LoadProfileAlias_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_LpStandardLoadProfile_GetAll(string messageId);
        DataSet usp_LoadProfile_GetAll(string messageId);
        DataSet usp_LoadProfileAlias_GetAll(string messageId);

        DataSet usp_LibertyPowerBillingType_SELECT_By_UtilityCode(string messageId, string utilityCode);
        DataSet usp_LibertyPowerBillingType_SELECT_By_All(string messageId);
        
        void usp_LpBillingType_INSERT_ByCodes(string messageId, string id, string utilityCode, string porDriver, string loadProfile, string rateClass, string tariffCode, string defaultBillingType, bool inactive, string user);
        void usp_LpBillingType_UPDATE_ByCodes(string messageId, string id, string utilityCode, string porDriver, string loadProfile, string rateClass, string tariffCode, string defaultBillingType, bool inactive, string user);

        void usp_LpApprovedBillingType_INSERT_ByCodes(string messageId, string id, string lpBillingTypeId, string approvedBillingType, string terms, bool inactive, string user);
        void usp_LpApprovedBillingType_UPDATE_ByCodes(string messageId, string id, string lpBillingTypeId, string approvedBillingType, string terms, bool inactive, string user);

        void usp_LpUtilityOfferedBillingType_INSERT_ByCodes(string messageId, string id, string lpBillingTypeId, string utilityOfferedBillingType, bool inactive, string user);
        void usp_LpUtilityOfferedBillingType_UPDATE_ByCodes(string messageId, string id, string lpBillingTypeId, string utilityOfferedBillingType, bool inactive, string user);

        DataSet usp_PurchaseOfReceivables_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_PurchaseOfReceivables_GetAll(string messageId);
        DataSet usp_PurchaseOfReceivables_GetUndefined(string messageId);
        DataSet usp_PurchaseOfReceivables_GetUndefinedAndAll(string messageId);
        void usp_PurchaseOfReceivables_UPDATE(string messageId, string utilityCode, string porDriver, string loadProfileCode, string rateClassCode, string tariffCodeCode, bool isOffered, bool isParticipated, bool isAssurance, string recourse, decimal discountRate, decimal flatFee, DateTime effectiveDate, DateTime? expirationDate, bool inactive, string user);
        void usp_PurchaseOfReceivables_INSERT(string messageId, string id, string utilityCode, string porDriver, string loadProfileCode, string rateClassCode, string tariffCodeCode, bool isOffered, bool isParticipated, bool isAssurance, string recourse, decimal discountRate, decimal flatFee, DateTime effectiveDate, DateTime? expirationDate, bool inactive, string user);

        System.Data.Objects.ObjectResult<usp_PurchaseOfReceivables_SELECT_ByUtilityCodeLoadProfileCodeRateClassCodeTariffCode_Result> usp_PurchaseOfReceivables_SELECT_ByUtilityCompanyLoadProfileRateClassTariffCode(string messageId, string utilityCode, string loadProfile, string rateClass, string tariffCode);
        DataSet usp_LpBillingType_IsDuplicate(string messageId, string id, string utilityCode, string porDriver, string loadProfileCode, string rateClassCode, string tariffCodeCode, string defaultBillingType, string utilityOfferedBillingType, string lpApprovedBillingType, string terms, bool inactive);

        bool usp_LoadProfile_IsValid(string messageId, string utilityCode, string loadProfileCode);
        bool usp_RateClass_IsValid(string messageId, string utilityCode, string rateClassCode);
        bool usp_TariffCode_IsValid(string messageId, string utilityCode, string tariffCodeCode);

        DataSet usp_CapacityThresholdRuleGetByUtilityCode(string messageId, string utilityCode);

        DataSet usp_MeterReadCalendar_IsExactDuplicate(string messageId, string utilityCode, int year, int month, string readCycleId, string readDate, bool isAmr,bool inactive);
        DataSet usp_MeterReadCalendar_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_MeterReadCalendar_GetAll(string messageId);
        void usp_MeterReadCalendar_UPDATE(string messageId, Guid id, string utilityCode, int year, int month, string readCycleId, DateTime readDate, bool isAmr,bool inactive, string user);
        void usp_MeterReadCalendar_INSERT(string messageId, Guid id, string utilityCode, int year, int month, string readCycleId, DateTime readDate,bool isAmr ,bool inactive, string user);

        DataSet usp_PaymentTerm_IsExactDuplicate(string messageId, string utilityCode, string accountType, string billingType, string marketId, string paymentTerm, bool inactive);
        DataSet usp_PaymentTerm_GetByUtilityCode(string messageId, string utilityCode);
        DataSet usp_PaymentTerm_GetAll(string messageId);
        void usp_PaymentTerm_UPDATE(string messageId, Guid id, string utilityCode, string accountType, string billingType, string marketId, string paymentTerm, bool inactive, string user);
        void usp_PaymentTerm_INSERT(string messageId, Guid id, string utilityCode, string accountType, string billingType, string marketId, string paymentTerm, bool inactive, string user);

        DataSet usp_LpBillingType_GetAllDefinedAndEmptyLpBillingTypes(string messageId);
        DataSet usp_LpBillingType_GetAllEmptyLpBillingTypes(string messageId);

        void usp_IdrRule_INSERT(string messageId, Guid id, Guid utilityCompanyId, Guid? rateClassId, Guid? loadProfileId, Guid? tariffCodeId, int? minUsageMWh, int? maxUsageMWh, bool isOnEligibleCustomerList, bool isHistoricalArchiveAvailable, Guid? requestModeIdrId, Guid? requestModeTypeId, bool alwaysRequest, bool inactive, string user);

        DataSet usp_MeterReadCalender_GetNextReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate);
        DataSet usp_MeterReadCalender_GetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate);

        DataSet usp_UtilityCompanyGetAllUtilitiesReceiveIdrOnly(string messageId);
        DataSet usp_UtilityCompanyGetReceiveIdrOnlyByUtilityId(string messageId, int utilityId);

        DataSet usp_CapacityThresholdRuleGetByUtilityCodeCustomerAccountType(string messageId, string utilityCode, string accountType);
        DataSet usp_CapacityThresholdRule_GetAll(string messageId);
        DataSet usp_UtilityGetAllUtilitiesData(string messageId);
        DataSet usp_UtilityGetAllActiveUtilitiesDumpData(string messageId);
    }
}
