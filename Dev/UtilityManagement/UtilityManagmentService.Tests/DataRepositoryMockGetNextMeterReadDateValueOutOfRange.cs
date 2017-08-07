using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagmentService.Tests
{
    public class DataRepositoryMockGetNextMeterReadDateValueOutOfRange : UtilityManagementRepository.IDataRepository
    {
        public string MessageId
        {
            get;
            set;
        }


        public List<DataAccessLayerEntityFramework.usp_IdrRule_IntegratedWithTariffCode_Result> usp_IdrRule_Integrated(string messageId, string rateClassCode, string loadProfileCode, string tariffCodeCode, bool? eligibility, bool? hia, int? utilityIdInt, int? usage)
        {
            throw new NotImplementedException();
        }

        public string GetZoneByUtilityCodeAndZipCodeFromDealCapture(string messageId, string utilityCode, string zipCode)
        {
            throw new NotImplementedException();
        }

        public string GetZoneByAccountNumberFromErcot(string messageId, string accountNumber)
        {
            throw new NotImplementedException();
        }

        public List<DataAccessLayerEntityFramework.RequestModeEnrollmentType> RequestModeEnrollmentTypes
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.RequestModeHistoricalUsage> RequestModeHistoricalUsages
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.RequestModeIcap> RequestModeIcaps
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.RequestModeIdr> RequestModeIdrs
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.RequestModeType> RequestModeTypes
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.RequestModeTypeGenre> RequestModeTypeGenres
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.RequestModeTypeToRequestModeEnrollmentType> RequestModeTypeToRequestModeEnrollmentTypes
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.RequestModeTypeToRequestModeTypeGenre> RequestModeTypeToRequestModeTypeGenres
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.UtilityCompany> UtilityCompanies
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.UserInterfaceControlAndValueGoverningControlVisibility> UserInterfaceControlAndValueGoverningControlVisibilities
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.UserInterfaceControlVisibility> UserInterfaceControlVisibilities
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.UserInterfaceForm> UserInterfaceForms
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.UserInterfaceFormControl> UserInterfaceFormControls
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.zAuditRequestModeHistoricalUsage> zAuditRequestModeHistoricalUsages
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.zAuditUtilityCompany> zAuditUtilityCompanies
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.UtilityLegacy> UtilityLegacies
        {
            get { throw new NotImplementedException(); }
        }

        public List<DataAccessLayerEntityFramework.UtilityCompanyToUtilityLegacy> UtilityCompanyToUtilityLegacies
        {
            get { throw new NotImplementedException(); }
        }

        public System.Data.Objects.ObjectResult<int?> usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIds(string requestModeEnrollmentTypeId, string utilityCompanyId)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<string> usp_RequestModeEnrollmentType_SELECT_NameById(string id)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<string> usp_RequestModeType_SELECT_NameById(string id)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId_Result> usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId(string requestModeEnrollmentTypeId)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName_Result> usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName(string requestModeEnrollmentTypeId, string requestModeTypeGenreName)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm_Result> usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm(string formName)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_PurchaseOfReceivables_SELECT_ByUtilityLoadProfileRateClassTariffCodeEffectiveDate_Result> usp_PurchaseOfReceivables_SELECT_ByUtilityLoadProfileRateClassTariffCodeEffectiveDate(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode, DateTime porEffectiveDate)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_IdrRuleAndRequestMode_SelectByParams_Result> usp_IdrRuleAndRequestMode_SelectByParams(string messageId, int utilityIdInt, string rateClass, string loadProfile, string annualUsage, string enrollmentType, bool? isHia)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_IdrRuleAndRequestMode_SelectByParamWithTariffCode_Result> usp_IdrRuleAndRequestMode_SelectByParam(string messageId, int utilityIdInt, string rateClass, string loadProfile, string tariffCode, string annualUsage, int enrollmentType, bool? isHia)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_AccountInfoFieldRequired_GetByUtility_Result> usp_AccountInfoFieldRequired_GetByUtility(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<int?> usp_BillingType_RetrieveByUtilityRateClassLoadProfileTariffCode(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<int?> usp_IdrRule_InsufficientInformation(string messageId, int utilityIdInt, string rateClass, string loadProfile, string annualUsage, bool? isOnEligibilityList, bool? isHia)
        {
            throw new NotImplementedException();
        }

        public DateTime? usp_MeterReadSchedule_GetNext(string messageId, int utilityIdInt, string tripNumber, DateTime referenceDate, string serviceAccountNumber)
        {
            throw new NotImplementedException();
        }

        public System.Data.Entity.Infrastructure.DbChangeTracker ChangeTracker
        {
            get { throw new NotImplementedException(); }
        }

        public System.Data.Entity.Infrastructure.DbContextConfiguration Configuration
        {
            get { throw new NotImplementedException(); }
        }

        public System.Data.Entity.Database Database
        {
            get { throw new NotImplementedException(); }
        }

        public System.Data.Entity.Infrastructure.DbEntityEntry Entry(object entity)
        {
            throw new NotImplementedException();
        }

        public System.Data.Entity.Infrastructure.DbEntityEntry<TEntity> Entry<TEntity>(TEntity entity) where TEntity : class
        {
            throw new NotImplementedException();
        }

        public IEnumerable<System.Data.Entity.Validation.DbEntityValidationResult> GetValidationErrors()
        {
            throw new NotImplementedException();
        }

        public int SaveChanges()
        {
            throw new NotImplementedException();
        }

        public bool usp_UtilityCompany_DoesUtilityCodeBelongToIso(string messageId, string Iso, string UtilityCode)
        {
            throw new NotImplementedException();
        }

        public List<DataAccessLayerEntityFramework.usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequest_Result> usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequest(string messageId, string rateClassCode, string loadProfileCode, string tariffCodeCode, bool? eligibility, bool? hia, int? utilityIdInt, int? usage, UtilityManagementServiceData.EnrollmentType enrollmentType)
        {
            throw new NotImplementedException();
        }

        public List<DataAccessLayerEntityFramework.usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequestAsSeparateField_Result> usp_IdrRule_IntegratedWithTariffCodeAndAlwaysRequestAsSeparateField(string messageId, string rateClassCode, string loadProfileCode, string tariffCodeCode, bool? eligibility, bool? hia, int? utilityIdInt, int? usage, UtilityManagementServiceData.EnrollmentType enrollmentType)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists(string messageId, Guid utilityId, Guid porDriverId, Guid loadProfileId, Guid rateClassId, Guid tariffCodeId, Guid utilityOfferedBillingTypeId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists_ByValue(string messageId, string utilityCode, string porDriver, string loadProfileCode, string rateClassCode, string tariffCodeCode, string utilityOfferedBillingType, string lpApprovedBillingType)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpStandardTariffCode_UPSERT(string messageId, string id, string utilityCode, string lpStandardTariffCode, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_TariffCode_UPSERT(string messageId, string id, string utilityCode, string lpStandardTariffCode, string tariffCode, string description, string accountType, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_TariffCodeAlias_UPSERT(string messageId, string id, string utilityCode, int tariffCodeId, string tariffCodeCodeAlias, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpStandardLoadProfile_UPSERT(string messageId, string id, string utilityCode, string lpStandardLoadProfile, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LoadProfile_UPSERT(string messageId, string id, string utilityCode, string lpStandardLoadProfile, string loadProfile, string description, string accountType, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LoadProfileAlias_UPSERT(string messageId, string id, string utilityCode, int loadProfileId, string loadProfileCodeAlias, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpStandardRateClass_UPSERT(string messageId, string id, string utilityCode, string lpStandardRateClass, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_RateClass_UPSERT(string messageId, string id, string utilityCode, string lpStandardRateClass, string rateClass, string description, string accountType, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_RateClassAlias_UPSERT(string messageId, string id, string utilityCode, int rateClassId, string rateClassCodeAlias, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpStandardTariffCode_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_TariffCode_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_TariffCodeAlias_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpStandardTariffCode_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_TariffCode_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_TariffCodeAlias_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpStandardRateClass_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_RateClass_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_RateClassAlias_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpStandardRateClass_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_RateClass_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_RateClassAlias_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpStandardLoadProfile_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LoadProfile_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LoadProfileAlias_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpStandardLoadProfile_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LoadProfile_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LoadProfileAlias_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LibertyPowerBillingType_SELECT_By_UtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LibertyPowerBillingType_SELECT_By_All(string messageId)
        {
            throw new NotImplementedException();
        }

        public void usp_LpBillingType_INSERT_ByCodes(string messageId, string id, string utilityCode, string porDriver, string loadProfile, string rateClass, string tariffCode, string defaultBillingType, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public void usp_LpBillingType_UPDATE_ByCodes(string messageId, string id, string utilityCode, string porDriver, string loadProfile, string rateClass, string tariffCode, string defaultBillingType, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public void usp_LpApprovedBillingType_INSERT_ByCodes(string messageId, string id, string lpBillingTypeId, string approvedBillingType, string terms, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public void usp_LpApprovedBillingType_UPDATE_ByCodes(string messageId, string id, string lpBillingTypeId, string approvedBillingType, string terms, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public void usp_LpUtilityOfferedBillingType_INSERT_ByCodes(string messageId, string id, string lpBillingTypeId, string utilityOfferedBillingType, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public void usp_LpUtilityOfferedBillingType_UPDATE_ByCodes(string messageId, string id, string lpBillingTypeId, string utilityOfferedBillingType, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_PurchaseOfReceivables_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_PurchaseOfReceivables_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_PurchaseOfReceivables_GetUndefined(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_PurchaseOfReceivables_GetUndefinedAndAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public void usp_PurchaseOfReceivables_UPDATE(string messageId, string utilityCode, string porDriver, string loadProfileCode, string rateClassCode, string tariffCodeCode, bool isOffered, bool isParticipated, bool isAssurance, string recourse, decimal discountRate, decimal flatFee, DateTime effectiveDate, DateTime? expirationDate, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public void usp_PurchaseOfReceivables_INSERT(string messageId, string id, string utilityCode, string porDriver, string loadProfileCode, string rateClassCode, string tariffCodeCode, bool isOffered, bool isParticipated, bool isAssurance, string recourse, decimal discountRate, decimal flatFee, DateTime effectiveDate, DateTime? expirationDate, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_PurchaseOfReceivables_SELECT_ByUtilityCodeLoadProfileCodeRateClassCodeTariffCode_Result> usp_PurchaseOfReceivables_SELECT_ByUtilityCompanyLoadProfileRateClassTariffCode(string messageId, string utilityCode, string loadProfile, string rateClass, string tariffCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpBillingType_IsDuplicate(string messageId, string id, string utilityCode, string porDriver, string loadProfileCode, string rateClassCode, string tariffCodeCode, string defaultBillingType, string utilityOfferedBillingType, string lpApprovedBillingType, string terms, bool inactive)
        {
            throw new NotImplementedException();
        }

        public bool usp_LoadProfile_IsValid(string messageId, string utilityCode, string loadProfileCode)
        {
            throw new NotImplementedException();
        }

        public bool usp_RateClass_IsValid(string messageId, string utilityCode, string rateClassCode)
        {
            throw new NotImplementedException();
        }

        public bool usp_TariffCode_IsValid(string messageId, string utilityCode, string tariffCodeCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_MeterReadCalendar_IsExactDuplicate(string messageId, string utilityCode, int year, int month, string readCycleId, string readDate, bool isAmr, bool inactive)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_MeterReadCalendar_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_MeterReadCalendar_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public void usp_MeterReadCalendar_UPDATE(string messageId, Guid id, string utilityCode, int year, int month, string readCycleId, DateTime readDate, bool isAmr, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public void usp_MeterReadCalendar_INSERT(string messageId, Guid id, string utilityCode, int year, int month, string readCycleId, DateTime readDate, bool isAmr, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_PaymentTerm_IsExactDuplicate(string messageId, string utilityCode, string accountType, string billingType, string marketId, string paymentTerm, bool inactive)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_PaymentTerm_GetByUtilityCode(string messageId, string utilityCode)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_PaymentTerm_GetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        public void usp_PaymentTerm_UPDATE(string messageId, Guid id, string utilityCode, string accountType, string billingType, string marketId, string paymentTerm, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public void usp_PaymentTerm_INSERT(string messageId, Guid id, string utilityCode, string accountType, string billingType, string marketId, string paymentTerm, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpBillingType_GetAllDefinedAndEmptyLpBillingTypes(string messageId)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_LpBillingType_GetAllEmptyLpBillingTypes(string messageId)
        {
            throw new NotImplementedException();
        }

        public void usp_IdrRule_INSERT(string messageId, Guid id, Guid utilityCompanyId, Guid? rateClassId, Guid? loadProfileId, Guid? tariffCodeId, int? minUsageMWh, int? maxUsageMWh, bool isOnEligibleCustomerList, bool isHistoricalArchiveAvailable, Guid? requestModeIdrId, Guid? requestModeTypeId, bool alwaysRequest, bool inactive, string user)
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet usp_MeterReadCalender_GetNextReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate)
        {
            System.Data.DataSet dataSet = new System.Data.DataSet();
            System.Data.DataTable dataTable = new System.Data.DataTable();
            dataTable.Columns.Add(new DataColumn("ReadDate", DateTime.Now.GetType()));
            System.Data.DataRow dataRow = dataTable.NewRow();
            dataRow[0] = inquiryDate.AddDays(61);
            dataTable.Rows.Add(dataRow);
            dataSet.Tables.Add(dataTable);
            return dataSet;
        }

        public System.Data.DataSet usp_MeterReadCalender_GetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate)
        {
            System.Data.DataSet dataSet = new System.Data.DataSet();
            System.Data.DataTable dataTable = new System.Data.DataTable();
            dataTable.Columns.Add(new DataColumn("ReadDate", DateTime.Now.GetType()));
            System.Data.DataRow dataRow = dataTable.NewRow();
            dataRow[0] = inquiryDate.AddDays(-61);
            dataTable.Rows.Add(dataRow);
            dataSet.Tables.Add(dataTable);
            return dataSet;
        }

        public void Dispose()
        {
            throw new NotImplementedException();
        }

        public System.Data.Objects.ObjectContext ObjectContext
        {
            get { throw new NotImplementedException(); }
        }


        public DataSet usp_UtilityCompanyGetAllUtilitiesReceiveIdrOnly(string messageId)
        {
            throw new NotImplementedException();
        }

        public DataSet usp_UtilityCompanyGetReceiveIdrOnlyByUtilityId(string messageId, int utilityId)
        {
            throw new NotImplementedException();
        }
    }
}
