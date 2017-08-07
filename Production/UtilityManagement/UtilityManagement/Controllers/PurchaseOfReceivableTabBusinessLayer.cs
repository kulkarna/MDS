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
        public override bool Populate(string messageId)
        {
            string method = "Populate(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                if (_dataTable != null && _dataTable.Rows != null && _dataTable.Rows.Count > 0)
                {
                    foreach (DataRow dataRow in _dataTable.Rows)
                    {
                        string driver = Common.NullSafeString(dataRow[POR_DRIVER]).Trim().ToLower();
                        decimal discountRate = 0;
                        decimal flatFee = 0;
                        if 
                        (
                            DoAllDataRowCellHaveNonEmptyValues(dataRow)
                            && (Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "true" || Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "false")
                            && (Common.NullSafeString(dataRow[IS_OFFERED]).ToLower().Trim() == "true" || Common.NullSafeString(dataRow[IS_OFFERED]).ToLower().Trim() == "false")
                            && (Common.NullSafeString(dataRow[IS_PARTICIPATED]).ToLower().Trim() == "true" || Common.NullSafeString(dataRow[IS_PARTICIPATED]).ToLower().Trim() == "false")
                            && (Common.NullSafeString(dataRow[IS_ASSURANCE]).ToLower().Trim() == "true" || Common.NullSafeString(dataRow[IS_ASSURANCE]).ToLower().Trim() == "false")
                            && (driver == "rate class" || driver == "load profile" || driver == "tariff code")
                            && IsUtilityCodeActive(messageId, dataRow)
                            && decimal.TryParse(dataRow[DISCOUNT_RATE].ToString(), out discountRate)
                            && decimal.TryParse(dataRow[FLAT_FEE].ToString(), out flatFee)
                        )
                        {
                            bool inactive = Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "true";
                            bool isOffered = Common.NullSafeString(dataRow[IS_OFFERED]).ToLower().Trim() == "true";
                            bool isParticipated = Common.NullSafeString(dataRow[IS_PARTICIPATED]).ToLower().Trim() == "true";
                            bool isAssurance = Common.NullSafeString(dataRow[IS_ASSURANCE]).ToLower().Trim() == "true";
                            string loadProfileCode = Common.NullSafeString(dataRow[LOAD_PROFILE_CODE]);
                            string rateClassCode = Common.NullSafeString(dataRow[RATE_CLASS_CODE]);
                            string tariffCodeCode = Common.NullSafeString(dataRow[TARIFF_CODE_CODE]);
                            try
                            {
                                DateTime? expirationDate = Common.NullSafeDateTime(dataRow[EXPIRATION_DATE]);
                                if (expirationDate.Value < new DateTime(1999, 1, 1))
                                {
                                    if (dataRow[EXPIRATION_DATE] == null)
                                        expirationDate = null;
                                    else
                                        throw new InvalidExpressionException("Invalid Expiration Date");
                                }
                                DataSet dataSet = _dataRepository.usp_PurchaseOfReceivables_UPSERT(messageId, 
                                    Guid.NewGuid().ToString(),
                                    Common.NullSafeString(dataRow[UTILITY_CODE]),
                                    Common.NullSafeString(dataRow[POR_DRIVER]),
                                    loadProfileCode,
                                    rateClassCode,
                                    tariffCodeCode,
                                    isOffered,
                                    isParticipated,
                                    isAssurance,
                                    Common.NullSafeString(dataRow[RECOURSE]),
                                    discountRate,
                                    flatFee,
                                    Common.NullSafeDateTime(dataRow[EFFECTIVE_DATE]),
                                    expirationDate,
                                    inactive,
                                    USER);
                                this.ExcelTabImportSummary.ProcessCount(dataSet);
                            }
                            catch (Exception rowException)
                            {
                                this.ExcelTabImportSummary.IncrementInvalidRecordCount();
                            }
                        }
                        else
                        {
                            this.ExcelTabImportSummary.IncrementInvalidRecordCount();
                        }
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0} return true {1}", method, Common.END));
                return true;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0} ERROR:{1}", method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} END", method));
                throw;
            }
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

        public override bool DoAllDataRowCellHaveNonEmptyValues(DataRow dataRow)
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