using ExcelLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;
using UtilityLogging;
using UtilityManagementRepository;
using UtilityManagementDataMapper;
using UtilityDto;

namespace ExcelBusinessLayer
{
    public class PurchaseOfReceivableTabBusinessLayer : TabBusinessLayer
    {
        #region private variables
        private string CLASS = "PurchaseOfReceivableTabBusinessLayer";
        protected const string POR_DRIVER = "PorDriver";
        protected const string RATE_CLASS_CODE = "RateClassCode";
        protected const string LOAD_PROFILE_CODE = "LoadProfileCode";
        protected const string TARIFF_CODE_CODE = "TariffCodeCode";
        protected const string IS_OFFERED = "IsPorOffered";
        protected const string IS_PARTICIPATED = "IsPorParticipated";
        protected const string IS_ASSURANCE = "IsPorAssurance";
        protected const string RECOURSE = "PorRecourse";
        protected const string DISCOUNT_RATE = "PorDiscountRate";
        protected const string FLAT_FEE = "PorFlatFee";
        protected const string EFFECTIVE_DATE = "PorDiscountEffectiveDate";
        protected const string EXPIRATION_DATE = "PorDiscountExpirationDate";
        protected const string TAB_NAME = "Purchase Of Receivable";
        #endregion

        #region public constructors
        public PurchaseOfReceivableTabBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, DataTable dataTable, List<DataAccessLayerEntityFramework.UtilityCompany> utilityCompanies)
            : base(messageId, dataRepository, excelWorksheetUtility, logger, TAB_NAME, utilityCompanies)
        {
            string method = string.Format("{0}.{1}.PurchaseOfReceivableTabBusinessLayer(messageId,dataRepository,excelWorksheetUtility,logger,dataTable)", NAMESPACE, CLASS);
            try
            {
                _logger = logger;
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                Columns.Add(UTILITY_CODE);
                Columns.Add(POR_DRIVER);
                Columns.Add(RATE_CLASS_CODE);
                Columns.Add(LOAD_PROFILE_CODE);
                Columns.Add(TARIFF_CODE_CODE);
                Columns.Add(IS_OFFERED);
                Columns.Add(IS_PARTICIPATED);
                Columns.Add(IS_ASSURANCE);
                Columns.Add(RECOURSE);
                Columns.Add(DISCOUNT_RATE);
                Columns.Add(FLAT_FEE);
                Columns.Add(EFFECTIVE_DATE);
                Columns.Add(EXPIRATION_DATE);
                Columns.Add(INACTIVE);
                TabOrder = 1;
                _dataTable = dataTable;

                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.END));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0} ERROR:{1}", method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} END", method));
                throw;
            }
        }
        #endregion


        #region public methods
        public override bool Populate(string messageId, string userName)
        {
            string method = string.Format("Populate(messageId,userName:{0})",userName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                int rowCount = 1;
                if (_dataTable != null && _dataTable.Rows != null && _dataTable.Rows.Count > 0)
                {
                    foreach (DataRow dataRow in _dataTable.Rows)
                    {
                        if (rowCount < _dataTable.Rows.Count)
                        {
                            ProcessUpsert(messageId, dataRow, rowCount, userName);
                            rowCount++;
                        }
                    }
                }
                return true;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0} ERROR:{1}", method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} END", method));
                throw;
            }
        }

        public void ProcessUpsert(string messageId, DataRow dataRow, int rowCount, string user)
        {
            string method = string.Format("ProcessUpsert(messageId,dataRow:{0},rowCount:{1},user:{2})", Common.NullSafeString(dataRow), Common.NullSafeString(rowCount), Common.NullSafeString(user));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                // Get the data subset 
                UtilityManagementRepository.DataRepositoryEntityFramework dref = new DataRepositoryEntityFramework();
                string utilityCode = Common.NullSafeString(dataRow[UTILITY_CODE]);
                string rateClassCode = Common.NullSafeString(dataRow[RATE_CLASS_CODE]);
                string loadProfileCode = Common.NullSafeString(dataRow[LOAD_PROFILE_CODE]);
                string tariffCodeCode = Common.NullSafeString(dataRow[TARIFF_CODE_CODE]);
                string porDriver = Common.NullSafeString(dataRow[POR_DRIVER]);
                bool isOffered = (bool)Common.NullableBoolean(dataRow[IS_OFFERED]);
                bool isParticipated = (bool)Common.NullableBoolean(dataRow[IS_PARTICIPATED]);
                bool isAssurance = (bool)Common.NullableBoolean(dataRow[IS_ASSURANCE]);
                bool inactive = (bool)Common.NullableBoolean(dataRow["Inactive"]);
                string recourse = Common.NullSafeString(dataRow[RECOURSE]);
                decimal discountRate = Common.NullSafeDecimal(dataRow[DISCOUNT_RATE]);
                decimal flatFee = Common.NullSafeDecimal(dataRow[FLAT_FEE]);
                DateTime effectiveDate = Common.NullSafeDateTime(dataRow[EFFECTIVE_DATE]);
                DateTime? expirationDate = Common.NullSafeDateTime(dataRow[EXPIRATION_DATE]);
                bool isAnUpdate = false;
                bool isDuplicate = false;
                if (expirationDate != null && new DateTime(2000, 1, 1).CompareTo(expirationDate) > 0)
                    expirationDate = null;

                System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_PurchaseOfReceivables_SELECT_ByUtilityCodeLoadProfileCodeRateClassCodeTariffCode_Result> results =
                    _dataRepository.usp_PurchaseOfReceivables_SELECT_ByUtilityCompanyLoadProfileRateClassTariffCode(messageId, utilityCode, loadProfileCode, rateClassCode, tariffCodeCode);

                EFToDtoMapping efToDtoMapping = new EFToDtoMapping();
                PurchaseOfReceivableList purchaseOfReceivableList = efToDtoMapping.GeneratePorFromEf(results);

                isDuplicate = IsDataRowADuplicate(messageId, dataRow);
                if (isDuplicate)
                {
                    ExcelTabImportSummary.DuplicateRecordCount++;
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
                    return;
                }

                if (purchaseOfReceivableList != null && purchaseOfReceivableList.Count > 0)
                {
                    foreach (PurchaseOfReceivable purchaseOfReceivable in purchaseOfReceivableList)
                    {
                        // Calculate if data row is valid
                        if (!IsDataRowValid(messageId, dataRow, purchaseOfReceivable))
                        {
                            ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid POR Driver or POR Recourse Value");
                            return;
                        }
                        if (!IsDataRowDateRangeValid(messageId, dataRow, purchaseOfReceivableList))
                        {
                            ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Date Range");
                            return;
                        }
                    }
                    isAnUpdate = AreDataRowDatesEligibleForUpdate(messageId, dataRow, purchaseOfReceivableList);

                    if (isAnUpdate)
                    {

                        dref.usp_PurchaseOfReceivables_UPDATE(messageId, utilityCode, porDriver, loadProfileCode, rateClassCode, tariffCodeCode,
                            isOffered, isParticipated, isAssurance, recourse, discountRate, flatFee, effectiveDate, expirationDate, inactive, user);
                        ExcelTabImportSummary.UpdatedRecordCount++;
                    }
                    else 
                    {
                        dref.usp_PurchaseOfReceivables_INSERT(messageId, Guid.NewGuid().ToString(), //Utilities.Common.NullSafeString(dataRow["Id"]), 
                            utilityCode, porDriver, loadProfileCode, rateClassCode, tariffCodeCode,
                            isOffered, isParticipated, isAssurance, recourse, discountRate, flatFee, effectiveDate, expirationDate, inactive, user);
                        ExcelTabImportSummary.InsertedRecordCount++;
                    }
                }
                else 
                {
                    if (!IsDataRowValid(messageId, utilityCode, porDriver, loadProfileCode, rateClassCode, tariffCodeCode, recourse))
                    {
                        ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid POR Driver or POR Recourse Value");
                        return;
                    }

                    dref.usp_PurchaseOfReceivables_INSERT(messageId, Guid.NewGuid().ToString(), 
                        utilityCode, porDriver, loadProfileCode, rateClassCode, tariffCodeCode,
                        isOffered, isParticipated, isAssurance, recourse, discountRate, flatFee, effectiveDate, expirationDate, inactive, user);
                    ExcelTabImportSummary.InsertedRecordCount++;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private bool IsDataRowDateRangeValid(string messageId, DataRow dataRow, PurchaseOfReceivableList results)
        {
            string method = string.Format("IsDataRowDataRangeValid(messageId,dataRow:{0},results:{1})", Common.NullSafeString(dataRow), Common.NullSafeString(results));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                bool isDataRowDateRangeValid = true;
                DateTime effectiveDateDataRow = new DateTime(2000,1,1);
                DateTime? expirationDateDataRow = null;
                DateTime effectiveDateResult = new DateTime(2000,1,1);
                DateTime? expirationDateResult = new DateTime(2000,1,1);
                DateTime expirationDateDataRowTemp = new DateTime(2000, 1, 1);

                DateTime.TryParse(Utilities.Common.NullSafeDateToString(dataRow[EFFECTIVE_DATE]), out effectiveDateDataRow);
                if (dataRow[EXPIRATION_DATE] == null)
                    expirationDateDataRow = null;
                else
                {
                    if (DateTime.TryParse(Utilities.Common.NullSafeDateToString(dataRow[EXPIRATION_DATE]), out expirationDateDataRowTemp))
                        expirationDateDataRow = expirationDateDataRowTemp;
               }

                foreach (PurchaseOfReceivable item in results)
                {
                    effectiveDateResult = item.PorDiscountEffectiveDate;
                    expirationDateResult = item.PorDiscountExpirationDate;
                    isDataRowDateRangeValid = isDataRowDateRangeValid 
                        && 
                        (
                            !DoTheseTwoDateRangesOverlap(messageId, effectiveDateDataRow, expirationDateDataRow, effectiveDateResult, expirationDateResult)   
                            || 
                            (
                                (
                                    (expirationDateDataRow == null && expirationDateResult == null) ||
                                    !(expirationDateDataRow == null && expirationDateResult != null) ||
                                    !(expirationDateDataRow != null && expirationDateResult == null) ||
                                    ((DateTime)expirationDateDataRow).Date.Equals(((DateTime)expirationDateResult).Date)
                                )
                                && effectiveDateDataRow.Date.Equals(effectiveDateResult.Date)
                            )
                        );
                    if (!isDataRowDateRangeValid)
                        break;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return isDataRowDateRangeValid:{3} {4}", NAMESPACE, CLASS, method, isDataRowDateRangeValid, Common.END));
                return isDataRowDateRangeValid;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private bool AreDataRowDatesEligibleForUpdate(string messageId, DataRow dataRow, PurchaseOfReceivableList purchaseOfReceivableList)
        {
            string method = string.Format("AreDataRowDatesEligibleForUpdate(messageId,dataRow:{0},results:{1})", Common.NullSafeString(dataRow), Common.NullSafeString(purchaseOfReceivableList));
            try
            {
                bool returnValue = false;
                DateTime effectiveDateDataRow = new DateTime(2000,1,1);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                if(DateTime.TryParse(Common.NullSafeDateToString(dataRow[EFFECTIVE_DATE]), out effectiveDateDataRow))
                {
                    foreach (PurchaseOfReceivable purchaseOfReceivable in purchaseOfReceivableList)
                    {
                        if (AreDateRangesEligibleForUpdate(messageId, effectiveDateDataRow, purchaseOfReceivable.PorDiscountEffectiveDate))
                        {
                            returnValue = true;
                        }
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return returnValue:{3} {4}", NAMESPACE, CLASS, method, returnValue, Common.END));

                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private bool AreDateRangesEligibleForUpdate(string messageId, DateTime firstDateRangeBegin, DateTime secondDateRangeBegin)
        { 
            string method = string.Format("AreDateRangesEligibleForUpdate(messageId,firstDateRangeBegin:{0},secondDateRangeBegin:{1})", 
                Common.NullSafeDateToString(firstDateRangeBegin), Common.NullSafeDateToString(secondDateRangeBegin));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                bool returnValue = false;
                if (DateTime.Compare(secondDateRangeBegin.Date, firstDateRangeBegin.Date) == 0)
                {
                    returnValue = true;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} {4}", NAMESPACE, CLASS, method, returnValue, Common.END));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private bool DoTheseTwoDateRangesOverlap(string messageId, DateTime firstDateRangeBegin, DateTime? firstDateRangeEnd, DateTime secondDateRangeBegin, DateTime? secondDateRangeEnd)
        {
            string method = string.Format("DoTheseTwoDateRangesOverlap(messageId,firstDateRangeBegin:{0},firstDateRangeEnd:{1},secondDateRangeBegin:{2},secondDateRangeEnd:{3})", 
                Common.NullSafeDateToString(firstDateRangeBegin),Common.NullSafeDateToString(firstDateRangeEnd),Common.NullSafeDateToString(secondDateRangeBegin),Common.NullSafeDateToString(secondDateRangeEnd));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                DateTime oneEndNotNull = new DateTime(2000, 1, 1);
                DateTime twoEndNotNull = new DateTime(2000, 1, 1);
                if (firstDateRangeEnd == null)
                    oneEndNotNull = new DateTime(3000, 1, 1);
                else
                    oneEndNotNull = (DateTime)firstDateRangeEnd;
                if (secondDateRangeEnd == null)
                    twoEndNotNull = new DateTime(3000, 1, 1);
                else
                    twoEndNotNull = (DateTime)secondDateRangeEnd;
                
                bool returnValue = false;
                if (DateTime.Compare(twoEndNotNull.Date, firstDateRangeBegin.Date) >= 0 && DateTime.Compare(oneEndNotNull.Date, secondDateRangeBegin.Date) >= 0)
                {
                    returnValue = true;
                }
                else
                {
                    returnValue = false;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} {4}", NAMESPACE, CLASS, method, returnValue, Common.END));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private bool IsDataRowADuplicate(string messageId, DataRow dataRow)
        {
            string method = string.Format("IsDataRowADuplicate(messageId,dataRow:{0})", Common.NullSafeString(dataRow));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                bool returnValue = false;
                UtilityManagementRepository.DataRepositoryEntityFramework dal = new DataRepositoryEntityFramework();

                DateTime? expirationDate = null;
                if (dataRow[EXPIRATION_DATE] != null && !string.IsNullOrWhiteSpace(dataRow[EXPIRATION_DATE].ToString()))
                {
                    DateTime dateTimeTemp = new DateTime(2000,1,1);
                    DateTime.TryParse(dataRow[EXPIRATION_DATE].ToString(), out dateTimeTemp);
                    expirationDate = (DateTime)dateTimeTemp;
                }

                DataSet dataSet = dal.usp_PurchaseOfReceivables_IsDuplicate(messageId, Common.NullSafeString(dataRow[UTILITY_CODE]), Common.NullSafeString(dataRow[POR_DRIVER]), 
                    Common.NullSafeString(dataRow[LOAD_PROFILE_CODE]), Common.NullSafeString(dataRow[RATE_CLASS_CODE]), Common.NullSafeString(dataRow[TARIFF_CODE_CODE]),
                    (bool)Common.NullableBoolean(dataRow[IS_OFFERED]), (bool)Common.NullableBoolean(dataRow[IS_PARTICIPATED]), (bool)Common.NullableBoolean(dataRow[IS_ASSURANCE]),
                    Common.NullSafeString(dataRow[RECOURSE]), Common.NullSafeDecimal(dataRow[DISCOUNT_RATE]), Common.NullSafeDecimal(dataRow[FLAT_FEE]),
                    Common.NullSafeDateTime(dataRow[EFFECTIVE_DATE]), expirationDate, (bool)Common.NullableBoolean(dataRow[INACTIVE]));

                if (dataSet != null && dataSet.Tables != null && dataSet.Tables.Count > 0 && dataSet.Tables[0] != null && dataSet.Tables[0].Rows != null && dataSet.Tables[0].Rows.Count > 0 && dataSet.Tables[0].Rows[0] != null && dataSet.Tables[0].Rows[0][0] != null)
                {
                    int count = 0;
                    int.TryParse(dataSet.Tables[0].Rows[0][0].ToString(), out count);

                    returnValue = count > 0;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return returnValue:{3} {4}", NAMESPACE, CLASS, method, returnValue, Common.END));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private bool IsDataRowValid(string messageId, DataRow dataRow, PurchaseOfReceivable purchaseOfReceivable)
        {
            Guid parseGuid = Guid.Empty;
            if (dataRow[POR_DRIVER] != null)
            {
                switch (dataRow[POR_DRIVER].ToString())
                {
                    case "Load Profile":
                        return dataRow["LoadProfileCode"] != null
                            && !String.IsNullOrWhiteSpace(dataRow["LoadProfileCode"].ToString())
                            && dataRow["PorRecourse"] != null
                            && !String.IsNullOrWhiteSpace(dataRow["PorRecourse"].ToString());
                    case "Rate Class":
                        return dataRow["RateClassCode"] != null
                            && !String.IsNullOrWhiteSpace(dataRow["RateClassCode"].ToString())
                            && dataRow["PorRecourse"] != null
                            && !String.IsNullOrWhiteSpace(dataRow["PorRecourse"].ToString());
                    case "Tariff Code":
                        return dataRow["TariffCodeCode"] != null
                            && !String.IsNullOrWhiteSpace(dataRow["TariffCodeCode"].ToString())
                            && dataRow["PorRecourse"] != null
                            && !String.IsNullOrWhiteSpace(dataRow["PorRecourse"].ToString());
                }
            }
            return false;
        }


        private bool IsDataRowValid(string messageId, string utilityCode, string porDriver, string loadProfileCode, string rateClassCode, string tariffCodeCode, string porRecourse)
        {
            Guid parseGuid = Guid.Empty;
            if (porDriver != null)
            {
                switch (porDriver)
                {
                    case "Load Profile":
                        return !String.IsNullOrWhiteSpace(loadProfileCode)
                            && !String.IsNullOrWhiteSpace(porRecourse)
                            && _dataRepository.usp_LoadProfile_IsValid(messageId, utilityCode, loadProfileCode);
                    case "Rate Class":
                        return !String.IsNullOrWhiteSpace(rateClassCode)
                            && !String.IsNullOrWhiteSpace(porRecourse)
                            && _dataRepository.usp_RateClass_IsValid(messageId, utilityCode, rateClassCode);
                    case "Tariff Code":
                        return !String.IsNullOrWhiteSpace(tariffCodeCode)
                            && !String.IsNullOrWhiteSpace(porRecourse)
                            && _dataRepository.usp_TariffCode_IsValid(messageId, utilityCode, tariffCodeCode);
                }
            }
            return false;
        }


        #endregion

        #region protected methods
        protected override bool DoesDataTableHaveAllValidColumns(string messageId)
        {
            string method = string.Format("{0}.{1}.DoesDataTableHaveAllValidColumns(messageId)", NAMESPACE, CLASS);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                bool returnValue = false;
                returnValue = _dataTable != null
                    && DoesDataTableHaveColumn(messageId, UTILITY_CODE)
                    && DoesDataTableHaveColumn(messageId, POR_DRIVER)
                    && DoesDataTableHaveColumn(messageId, RATE_CLASS_CODE)
                    && DoesDataTableHaveColumn(messageId, LOAD_PROFILE_CODE)
                    && DoesDataTableHaveColumn(messageId, TARIFF_CODE_CODE)
                    && DoesDataTableHaveColumn(messageId, IS_OFFERED)
                    && DoesDataTableHaveColumn(messageId, IS_PARTICIPATED)
                    && DoesDataTableHaveColumn(messageId, IS_ASSURANCE)
                    && DoesDataTableHaveColumn(messageId, RECOURSE)
                    && DoesDataTableHaveColumn(messageId, DISCOUNT_RATE)
                    && DoesDataTableHaveColumn(messageId, FLAT_FEE)
                    && DoesDataTableHaveColumn(messageId, EFFECTIVE_DATE)
                    && DoesDataTableHaveColumn(messageId, EXPIRATION_DATE)
                    && DoesDataTableHaveColumn(messageId, INACTIVE);

                _logger.LogInfo(messageId, string.Format("{0} return returnValue:{1} {2}", method, returnValue, Common.END));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0} ERROR:{1}", method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} END", method));
                throw;
            }
        }

        internal override bool DoAllDataRowCellHaveNonEmptyValues(DataRow dataRow)
        {
            foreach (DataColumn dataColumn in _dataTable.Columns)
            {
                if (!(dataColumn.ColumnName == RATE_CLASS_CODE || dataColumn.ColumnName == LOAD_PROFILE_CODE || dataColumn.ColumnName == TARIFF_CODE_CODE || dataColumn.ColumnName == EXPIRATION_DATE))
                {
                    if (dataRow[dataColumn] == null || string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[dataColumn])))
                        return false;
                }
            }
            if (
                Common.NullSafeString(dataRow[POR_DRIVER]) == "Load Profile" && (dataRow[LOAD_PROFILE_CODE] != null && !string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[LOAD_PROFILE_CODE]))) ||
                Common.NullSafeString(dataRow[POR_DRIVER]) == "Tariff Code" && (dataRow[TARIFF_CODE_CODE] != null && !string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[TARIFF_CODE_CODE]))) ||
                Common.NullSafeString(dataRow[POR_DRIVER]) == "Rate Class" && (dataRow[RATE_CLASS_CODE] != null && !string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[RATE_CLASS_CODE])))
               )
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        #endregion
    }
}