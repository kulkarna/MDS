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
    public class LpBillingTypeTabBusinessLayer : TabBusinessLayer
    {
        #region private variables
        private string CLASS = "LpBillingTypeTabBusinessLayer";

        private bool _lpBillingTypeInsert = false;
        private bool _utilityOfferedBillingTypeInsert = false;
        private bool _utilityOfferedBillingTypeUpdate = false;
        private bool _lpApprovedBillingTypeInsert = false;
        private bool _lpApprovedBillingTypeUpdate = false;
        private bool _inactive = false;
        private string _utilityCode = string.Empty;
        private string _porDriver = string.Empty;
        private string _loadProfile = string.Empty;
        private string _rateClass = string.Empty;
        private string _tariffCode = string.Empty;
        private string _utilityOfferedBillingType = string.Empty;
        private string _lpApprovedBillingType = string.Empty;
        private string _defaultBillingType = string.Empty;
        private string _terms = null;
        private string _lpBillingTypeId = string.Empty;

        protected const string ACCOUNT_TYPE = "AccountType";
        protected const string DEFAULT_BILLING_TYPE = "DefaultBillingType";
        protected const string DRIVER = "Driver";
        protected const string LOAD_PROFILE = "LoadProfileCode";
        protected const string LOAD_PROFILE_ID = "LoadProfileCodeId";
        protected const string LP_APPROVED_BILLING_TYPE = "LpApprovedBillingType";
        protected const string POR_DRIVER = "Driver";
        protected const string POR_DRIVER_ID = "PorDriverId";
        protected const string RATE_CLASS = "RateClassCode";
        protected const string RATE_CLASS_ID = "RateClassCodeId";
        protected const string TAB_NAME = "Lp Billing Type";
        protected const string TARIFF_CODE = "TariffCodeCode";
        protected const string TARIFF_CODE_ID = "TariffCodeCodeId";
        protected const string TERMS = "Terms";
        protected const string UTILITY_OFFERED_BILLING_TYPE = "LpUtilityOfferedBillingType";
        protected const string UTILITY_OFFERED_BILLING_TYPE_ID = "LpUtilityOfferedBillingTypeId";
        protected const string UTILITY_COMPANY_ID = "UtilityCompanyId";
        #endregion

        #region public constructors
        public LpBillingTypeTabBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, DataTable dataTable, List<DataAccessLayerEntityFramework.UtilityCompany> utilityCompanies)
            : base(messageId, dataRepository, excelWorksheetUtility, logger, TAB_NAME, utilityCompanies)
        {
            string method = string.Format("{0}.{1}.LpBillingTypeTabBusinessLayer(messageId,dataRepository,excelWorksheetUtility,logger,dataTable)", NAMESPACE, CLASS);
            try
            {
                _logger = logger;
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                Columns.Add(UTILITY_CODE);
                Columns.Add(LOAD_PROFILE);
                Columns.Add(RATE_CLASS);
                Columns.Add(TARIFF_CODE);
                Columns.Add(DEFAULT_BILLING_TYPE);
                Columns.Add(UTILITY_OFFERED_BILLING_TYPE);
                Columns.Add(LP_APPROVED_BILLING_TYPE);
                Columns.Add(TERMS);
                Columns.Add(ACCOUNT_TYPE);
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

                this.ExcelTabImportSummary.InsertedRecordCount = 0;
                this.ExcelTabImportSummary.UpdatedRecordCount = 0;
                this.ExcelTabImportSummary.InvalidRecordCount = 0;
                this.ExcelTabImportSummary.DuplicateRecordCount = 0;

                if (_dataTable != null && _dataTable.Rows != null && _dataTable.Rows.Count > 0)
                {
                    foreach (DataRow dataRow in _dataTable.Rows)
                    {
                        if (rowCount < _dataTable.Rows.Count)
                        {
                            if(IsValid(messageId, dataRow))
                            {
                                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, "IsValid == TRUE"));
                                _inactive = Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "true";
                                try
                                {
                                    PopulateVariables(messageId, dataRow);
                                    DataSet dataSet = _dataRepository.usp_LpBillingType_Get_BillingTypeExists_UtilityOfferedBillingType_Exists_ByValue(messageId, _utilityCode, _porDriver, _loadProfile, _rateClass, _tariffCode, _utilityOfferedBillingType, _lpApprovedBillingType);
                                    if (Common.IsDataSetRowValid(dataSet))
                                    {
                                        _lpBillingTypeId = Utilities.Common.NullSafeString(dataSet.Tables[0].Rows[0][3]);
                                        DataSet ds = _dataRepository.usp_LpBillingType_IsDuplicate(messageId, _lpBillingTypeId, _utilityCode, _porDriver, _loadProfile, _rateClass, _tariffCode, _defaultBillingType, _utilityOfferedBillingType, _lpApprovedBillingType, _terms, _inactive);
                                        if (Common.IsDataSetRowValid(ds) && Common.NullSafeInteger(ds.Tables[0].Rows[0][0]) > 0 && Common.NullSafeInteger(ds.Tables[0].Rows[0][1]) > 0 && Common.NullSafeInteger(ds.Tables[0].Rows[0][2]) > 0)
                                        {
                                            _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, string.Format("DUPLICATE RECORD: ds.Tables[0].Rows[0][0]:{0};ds.Tables[0].Rows[0][1]:{1};ds.Tables[0].Rows[0][2]:{2}", Common.NullSafeInteger(ds.Tables[0].Rows[0][0]), Common.NullSafeInteger(ds.Tables[0].Rows[0][1]), Common.NullSafeInteger(ds.Tables[0].Rows[0][2]))));
                                            this.ExcelTabImportSummary.DuplicateRecordCount++;
                                        }
                                        else
                                        {
                                            _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, string.Format("NOT A DUPLICATE RECORD -- Calling ProcessBillingType : ds.Tables[0].Rows[0][0]:{0};ds.Tables[0].Rows[0][1]:{1};ds.Tables[0].Rows[0][2]:{2}", Common.NullSafeInteger(ds.Tables[0].Rows[0][0]), Common.NullSafeInteger(ds.Tables[0].Rows[0][1]), Common.NullSafeInteger(ds.Tables[0].Rows[0][2]))));
                                            ProcessLpBillingType(messageId, dataSet, ds, userName);

                                            _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, string.Format("0-0-0-0- Calling ProcessLpUtilityOfferedBillingType : ds.Tables[0].Rows[0][0]:{0};ds.Tables[0].Rows[0][1]:{1};ds.Tables[0].Rows[0][2]:{2}", Common.NullSafeInteger(ds.Tables[0].Rows[0][0]), Common.NullSafeInteger(ds.Tables[0].Rows[0][1]), Common.NullSafeInteger(ds.Tables[0].Rows[0][2]))));
                                            ProcessLpUtilityOfferedBillingType(messageId, dataSet, ds, userName);

                                            _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, string.Format("0-0-0-0- Calling ProcessLpApprovedBillingType : ds.Tables[0].Rows[0][0]:{0};ds.Tables[0].Rows[0][1]:{1};ds.Tables[0].Rows[0][2]:{2}", Common.NullSafeInteger(ds.Tables[0].Rows[0][0]), Common.NullSafeInteger(ds.Tables[0].Rows[0][1]), Common.NullSafeInteger(ds.Tables[0].Rows[0][2]))));
                                            ProcessLpApprovedBillingType(messageId, dataSet, ds, userName);
                                            _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, string.Format("0-0-0-0- Called ProcessLpApprovedBillingType : ds.Tables[0].Rows[0][0]:{0};ds.Tables[0].Rows[0][1]:{1};ds.Tables[0].Rows[0][2]:{2}", Common.NullSafeInteger(ds.Tables[0].Rows[0][0]), Common.NullSafeInteger(ds.Tables[0].Rows[0][1]), Common.NullSafeInteger(ds.Tables[0].Rows[0][2]))));
                                        
                                        }
                                    }
                                    if (_lpBillingTypeInsert || _utilityOfferedBillingTypeInsert || _lpApprovedBillingTypeInsert)
                                    {
                                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, string.Format("0-0-0-0- ExcelTabImportSummary.InsertedRecordCount++:{0}", Common.NullSafeInteger(ExcelTabImportSummary.InsertedRecordCount))));
                                        this.ExcelTabImportSummary.InsertedRecordCount++;
                                    }
                                    else if (_lpApprovedBillingTypeUpdate || _utilityOfferedBillingTypeUpdate || _lpApprovedBillingTypeUpdate)
                                    {
                                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, string.Format("0-0-0-0- ExcelTabImportSummary.UpdatedRecordCount++:{0}", Common.NullSafeInteger(ExcelTabImportSummary.UpdatedRecordCount))));
                                        this.ExcelTabImportSummary.UpdatedRecordCount++;
                                    }
                                }
                                catch (Exception rowException)
                                {
                                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, string.Format("rowException:{0} ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount)", Common.NullSafeString(rowException.Message))));
                                    this.ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount);
                                }
                            }
                            else
                            {
                                this.ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount);
                            }
                        }
                        rowCount++;
                    }
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return true 0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+ {3}", NAMESPACE, CLASS, method, Common.END));
                return true;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion

        #region protected methods
        private void ProcessLpApprovedBillingType(string messageId, DataSet dataSet, DataSet ds, string userName)
        {
            string method = string.Format("ProcessLpApprovedBillingType(messageId,dataSet,ds,userName:{0})",userName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} dataSet.Tables[0].Rows[0][2]={3};dataSet.Tables[0].Rows[0][5]={4}", NAMESPACE, CLASS, method, Common.NullSafeInteger(dataSet.Tables[0].Rows[0][2]), Common.NullSafeString(dataSet.Tables[0].Rows[0][5])));


                if (Common.NullSafeInteger(dataSet.Tables[0].Rows[0][2]) == 0)
                {
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Common.NullSafeInteger(dataSet.Tables[0].Rows[0][2]) == 0  THIS IS AN INSERT FOR LpApprovedBillingType", NAMESPACE, CLASS, method));
                    if (string.IsNullOrWhiteSpace(Common.NullSafeString(dataSet.Tables[0].Rows[0][5])))
                    {
                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} string.IsNullOrWhiteSpace(Common.NullSafeString(dataSet.Tables[0].Rows[0][5])  THIS IS AN INSERT FOR LpApprovedBillingType", NAMESPACE, CLASS, method));
                        _dataRepository.usp_LpApprovedBillingType_INSERT_ByCodes(messageId, Guid.NewGuid().ToString(), _lpBillingTypeId, _lpApprovedBillingType, _terms, _inactive, userName);
                    }
                    else
                    {
                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} !string.IsNullOrWhiteSpace(Common.NullSafeString(dataSet.Tables[0].Rows[0][5])  THIS IS AN INSERT UPDATE *** FOR LpApprovedBillingType", NAMESPACE, CLASS, method));
                        _dataRepository.usp_LpApprovedBillingType_UPDATE_ByCodes(messageId, Common.NullSafeString(dataSet.Tables[0].Rows[0][5]), _lpBillingTypeId, _lpApprovedBillingType, _terms, false, userName);
                    }
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} _lpApprovedBillingTypeInsert = true;", NAMESPACE, CLASS, method));
                    _lpApprovedBillingTypeInsert = true;
                }
                else
                {
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Common.NullSafeInteger(dataSet.Tables[0].Rows[0][2]) != 0 THIS IS AN UPDATE FOR LpApprovedBillingType", NAMESPACE, CLASS, method));
                    if (Common.NullSafeInteger(ds.Tables[0].Rows[0][2]) == 0)
                    {
                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Common.NullSafeInteger(ds.Tables[0].Rows[0][2]) == 0 THIS IS AN UPDATE WHICH DEACTIVATES AN EXISTING RECORD", NAMESPACE, CLASS, method));
                        if (string.IsNullOrWhiteSpace(_lpApprovedBillingType))
                        {
                            _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} string.IsNullOrWhiteSpace(_lpApprovedBillingType)", NAMESPACE, CLASS, method));
                            _inactive = true;
                        }
                        _dataRepository.usp_LpApprovedBillingType_UPDATE_ByCodes(messageId, Common.NullSafeString(dataSet.Tables[0].Rows[0][5]), _lpBillingTypeId, _lpApprovedBillingType, _terms, _inactive, userName);
                    }
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} _lpApprovedBillingTypeUpdate = true;", NAMESPACE, CLASS, method));
                    _lpApprovedBillingTypeUpdate = true;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        private void ProcessLpUtilityOfferedBillingType(string messageId, DataSet dataSet, DataSet ds, string userName)
        {
            string method = string.Format("ProcessLpUtilityOfferedBillingType(messageId,dataSet,ds,userName:{0})",userName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                //utility offered
                if (Common.NullSafeInteger(dataSet.Tables[0].Rows[0][1]) == 0)
                {
                    _dataRepository.usp_LpUtilityOfferedBillingType_INSERT_ByCodes(messageId, Guid.NewGuid().ToString(), _lpBillingTypeId, _utilityOfferedBillingType, _inactive, userName);
                    _utilityOfferedBillingTypeInsert = true;
                }
                else
                {
                    if (Common.NullSafeInteger(ds.Tables[0].Rows[0][1]) == 0)
                    {
                        _dataRepository.usp_LpUtilityOfferedBillingType_UPDATE_ByCodes(messageId, Common.NullSafeString(dataSet.Tables[0].Rows[0][4]), Common.NullSafeString(dataSet.Tables[0].Rows[0][3]), 
                            _utilityOfferedBillingType, _inactive, userName);
                    }
                    _utilityOfferedBillingTypeUpdate = true;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private void PopulateVariables(string messageId, DataRow dataRow)
        {
            string method = "PopulateVariables(messageId,dataRow)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                _utilityCode = Common.NullSafeString(dataRow[UTILITY_CODE]);
                _porDriver = Common.NullSafeString(dataRow[POR_DRIVER]);
                _loadProfile = Common.NullSafeString(dataRow[LOAD_PROFILE]);
                _rateClass = Common.NullSafeString(dataRow[RATE_CLASS]);
                _tariffCode = Common.NullSafeString(dataRow[TARIFF_CODE]);
                _utilityOfferedBillingType = Common.NullSafeString(dataRow[UTILITY_OFFERED_BILLING_TYPE]);
                _lpApprovedBillingType = Common.NullSafeString(dataRow[LP_APPROVED_BILLING_TYPE]);
                _defaultBillingType = Common.NullSafeString(dataRow[DEFAULT_BILLING_TYPE]);
                _terms = null;

                _lpBillingTypeInsert = false;
                _utilityOfferedBillingTypeInsert = false;
                _lpApprovedBillingTypeInsert = false;
                _utilityOfferedBillingTypeUpdate = false;
                _lpApprovedBillingTypeUpdate = false;

                if (!string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[TERMS])))
                    _terms = Common.NullSafeInteger(dataRow[TERMS]).ToString();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} UtilityCode:{4};PorDriver:{5};LoadProfile:{6};RateClass:{7};TariffCode:{8};UtilityOfferedBillingType:{9};LpApprovedBillingType:{10};DefaultBillingType:{11};Terms:{12} {3}", NAMESPACE, CLASS, method, Common.END,
                    Common.NullSafeString(_utilityCode),
                    Common.NullSafeString(_porDriver),
                    Common.NullSafeString(_loadProfile),
                    Common.NullSafeString(_rateClass),
                    Common.NullSafeString(_tariffCode),
                    Common.NullSafeString(_utilityOfferedBillingType),
                    Common.NullSafeString(_lpApprovedBillingType),
                    Common.NullSafeString(_defaultBillingType),
                    Common.NullSafeString(_terms)));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }

        }

        private bool IsValid(string messageId, DataRow dataRow)
        {
            string method = "IsValid(messageId,dataRow)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
                return DoAllDataRowCellHaveNonEmptyValues(dataRow) && (Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "true"
                    || Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "false") && IsUtilityCodeActive(messageId, dataRow);
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private void ProcessLpBillingType(string messageId, DataSet dataSet, DataSet ds, string userName)
        {
            string method = string.Format("ProcessLpBillingType(messageId,dataSet,ds,userName:{0})",userName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                if (Common.NullSafeInteger(dataSet.Tables[0].Rows[0][0]) == 0)
                {
                    _lpBillingTypeId = Guid.NewGuid().ToString();
                    _dataRepository.usp_LpBillingType_INSERT_ByCodes(messageId, _lpBillingTypeId, _utilityCode, _porDriver, _loadProfile, _rateClass, _tariffCode, _defaultBillingType, true, userName);
                    _lpBillingTypeInsert = true;
                }
                else
                {
                    if (Common.NullSafeInteger(ds.Tables[0].Rows[0][0]) == 0)
                    {
                        _dataRepository.usp_LpBillingType_UPDATE_ByCodes(messageId, _lpBillingTypeId, _utilityCode, _porDriver, _loadProfile, _rateClass, _tariffCode, _defaultBillingType, true, userName);
                    }
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        internal override bool DoAllDataRowCellHaveNonEmptyValues(DataRow dataRow)
        {
            foreach (DataColumn dataColumn in _dataTable.Columns)
            {
                if (
                    (dataRow[dataColumn] == null ||
                      string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[dataColumn]))
                    )
                    &&
                    (
                        (Common.NullSafeString(dataRow["Driver"]).ToLower().Trim() == "load profile" && dataColumn.ColumnName.ToLower().Trim() == "loadprofilecode")
                        ||
                        (Common.NullSafeString(dataRow["Driver"]).ToLower().Trim() == "rate class" && dataColumn.ColumnName.ToLower().Trim() == "rateclasscode")
                        ||
                        (Common.NullSafeString(dataRow["Driver"]).ToLower().Trim() == "tariff code" && dataColumn.ColumnName.ToLower().Trim() == "tariffcodecode")
                        ||
                        (dataColumn.ColumnName.ToLower().Trim() == "loadprofilecode" && dataColumn.ColumnName.ToLower().Trim() == "rateclasscode" && dataColumn.ColumnName.ToLower().Trim() == "tariffcodecode")
                    )
                )
                    return false;
            }
            return true;
        }


        protected override bool DoesDataTableHaveAllValidColumns(string messageId)
        {
            string method = string.Format("{0}.{1}.DoesDataTableHaveAllValidColumns(messageId)", NAMESPACE, CLASS);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                bool returnValue = false;
                returnValue = _dataTable != null
                    && DoesDataTableHaveColumn(messageId, UTILITY_CODE)
                    && DoesDataTableHaveColumn(messageId, LOAD_PROFILE)
                    && DoesDataTableHaveColumn(messageId, RATE_CLASS)
                    && DoesDataTableHaveColumn(messageId, TARIFF_CODE)
                    && DoesDataTableHaveColumn(messageId, DEFAULT_BILLING_TYPE)
                    && DoesDataTableHaveColumn(messageId, UTILITY_OFFERED_BILLING_TYPE)
                    && DoesDataTableHaveColumn(messageId, LP_APPROVED_BILLING_TYPE)
                    && DoesDataTableHaveColumn(messageId, TERMS)
                    && DoesDataTableHaveColumn(messageId, ACCOUNT_TYPE)
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
        #endregion
    }
}