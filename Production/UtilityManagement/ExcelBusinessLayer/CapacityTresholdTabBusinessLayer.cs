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
    public class CapacityTresholdTabBusinessLayer : TabBusinessLayer
    {
        #region private variables
        private string CLASS = "CapacityTresholdTabBusinessLayer";
        protected const string CAPACITYCHECK = "Use Capacity Threshold";
        protected const string ACCOUNTYPE = "Account Type";
        protected const string CAPACITYTRESHOLDMIN = "CapacityThresholdMin";
        protected const string CAPACITYTRESHOLDMAX = "CapacityThresholdMax";
        protected const string INACTIVE = "Inactive";
        protected const string UTILITY_CODE = "UtilityCode";
        protected const string TAB_NAME = "CapacityThresholdRule";

        protected List<string> ListColumnNames = new List<string> { CAPACITYCHECK, ACCOUNTYPE, CAPACITYTRESHOLDMIN, CAPACITYTRESHOLDMAX, INACTIVE, UTILITY_CODE };
        #endregion

        #region public constructors
        public CapacityTresholdTabBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, DataTable dataTable, List<DataAccessLayerEntityFramework.UtilityCompany> utilityCompanies
            , List<DataAccessLayerEntityFramework.CustomerAccountType> customerAccountType)
            : base(messageId, dataRepository, excelWorksheetUtility, logger, TAB_NAME, utilityCompanies, customerAccountType)
        {
            string method = string.Format("{0}.{1}.CapacityTresholdTabBusinessLayer(messageId,dataRepository,excelWorksheetUtility,logger,dataTable)", NAMESPACE, CLASS);
            try
            {
                _logger = logger;
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                Columns.Add(UTILITY_CODE);
                Columns.Add(ACCOUNTYPE);
                Columns.Add(CAPACITYCHECK);
                Columns.Add(CAPACITYTRESHOLDMIN);
                Columns.Add(CAPACITYTRESHOLDMAX);
                Columns.Add(INACTIVE);
                TabOrder = 1;
                ListColumnNames = Columns;
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
            string method = string.Format("Populate(messageId,userName:{0})", userName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                int rowCount = 1;
                if (_dataTable != null && _dataTable.Rows != null && _dataTable.Rows.Count > 0)
                {
                    if (rowCount < _dataTable.Rows.Count)
                    {
                        if (IsProcessValid(messageId, _dataTable, rowCount, userName))
                        {
                            ProcessUpsert(messageId, _dataTable, rowCount, userName);
                        }
                        else return false;

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



        private void ProcessUpsert(string messageId, DataTable _dataTable, int rowCount, string user)
        {
            string method = string.Format("{0}.{1}.ProcessUpsert(messageId,_dataTable,rowCount,userName)", NAMESPACE, CLASS);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                foreach (DataRow dataRow in _dataTable.Rows)
                {
                    UtilityManagementRepository.DataRepositoryEntityFramework dref = new DataRepositoryEntityFramework();
                    string utilityCode = Common.NullSafeString(dataRow[UTILITY_CODE]).Trim();
                    bool CapcacityCheck = dataRow[CAPACITYCHECK] != null ? !Convert.ToBoolean(Common.NullSafeString(dataRow[CAPACITYCHECK]).Trim()) : false;
                    string AccountType = Common.NullSafeString(dataRow[ACCOUNTYPE]).Trim();
                    int CapacityTresholdmin = string.IsNullOrEmpty(Common.NullSafeString(dataRow[CAPACITYTRESHOLDMIN]).Trim()) ? 0 : Common.NullSafeInteger(Common.NullSafeString(dataRow[CAPACITYTRESHOLDMIN]).Trim());
                    int CapacityTresholdmax = string.IsNullOrEmpty(Common.NullSafeString(dataRow[CAPACITYTRESHOLDMAX]).Trim()) ? 0 : Common.NullSafeInteger(Common.NullSafeString(dataRow[CAPACITYTRESHOLDMAX]).Trim());
                    bool inactive = (bool)Common.NullableBoolean(dataRow["Inactive"]);
                    bool isDuplicate = false;
                    _logger.LogInfo(messageId, string.Format("NAMESPACE:{0}", Common.NullSafeString(NAMESPACE)));
                    _logger.LogInfo(messageId, string.Format("CLASS:{0}", Common.NullSafeString(CLASS)));
                    _logger.LogInfo(messageId, string.Format("method:{0}", Common.NullSafeString(method)));
                    _logger.LogInfo(messageId, string.Format("utilityCode:{0}", Common.NullSafeString(utilityCode)));
                    _logger.LogInfo(messageId, string.Format("CapcacityCheck:{0}", Common.NullableBoolean(CapcacityCheck)));
                    _logger.LogInfo(messageId, string.Format("AccountType:{0}", Common.NullSafeString(AccountType)));
                    _logger.LogInfo(messageId, string.Format("CapacityTresholdmin:{0}", Common.NullSafeString(CapacityTresholdmin)));
                    _logger.LogInfo(messageId, string.Format("CapacityTresholdmax:{0}", Common.NullSafeString(CapacityTresholdmax)));
                    _logger.LogInfo(messageId, string.Format("inactive:{0}", Common.NullSafeString(inactive)));

                    // bool isAnExactDuplicate = false;
                    // isAnExactDuplicate = IsDataRowAnExactDuplicate(messageId, utilityCode,
                    //CapcacityCheck, AccountType, CapacityTresholdmin, CapacityTresholdmax, inactive);
                    // _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} isAnExactDuplicate:{3}", NAMESPACE, CLASS, method, isAnExactDuplicate));
                    //if (isAnExactDuplicate)
                    //{
                    //    ExcelTabImportSummary.DuplicateRecordCount++;
                    //    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
                    //    return;
                    //}

                    isDuplicate = IsDataRowADuplicate(messageId, utilityCode, AccountType);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} isDuplicate:{3}", NAMESPACE, CLASS, method, isDuplicate));
                    if (isDuplicate)
                    {
                        dref.usp_CapacityTresholdRule_UPDATE(messageId, utilityCode, CapcacityCheck, AccountType, CapacityTresholdmin, CapacityTresholdmax, inactive, user);
                        ExcelTabImportSummary.UpdatedRecordCount++;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
                        continue;
                    }


                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEFORE dref.usp_CapacityTresholdRule_Insert(messageId:{0}, utilityCode:{1},CapcacityCheck:{2},AccountType:{3},CapacityTresholdmin:{4},CapacityTresholdmax:{5},inactive:{6},user:{7}",
                        messageId, utilityCode,
                      CapcacityCheck, AccountType, CapacityTresholdmin, CapacityTresholdmax, inactive, user));

                    dref.usp_CapacityTresholdRule_Insert(messageId, utilityCode,
                      CapcacityCheck, AccountType, CapacityTresholdmin, CapacityTresholdmax, inactive, user);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} After dref.usp_CapacityTresholdRule_Insert(messageId:{0}, utilityCode:{1},CapcacityCheck:{2},AccountType:{3},CapacityTresholdmin:{4},CapacityTresholdmax:{5},inactive:{6},user:{7}",
                        messageId, utilityCode,
                       CapcacityCheck, AccountType, CapacityTresholdmin, CapacityTresholdmax, inactive, user));

                    ExcelTabImportSummary.InsertedRecordCount++;
                }




                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0} ERROR:{1}", method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} END", method));
                throw;
            }
        }
        public override bool IsExcelTabValid(string messageId)
        {
            string method = string.Format("{0}.{1}.IsExcelTabValid(messageId)", NAMESPACE, CLASS);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                bool returnValue = false;
                returnValue = DoesDataTableHaveAllValidColumns(messageId);

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
        public bool IsProcessValid(string messageId, DataTable dtTable, int rowCount, string user)
        {
            string method = string.Format("ProcessUpsert(messageId,dtTable:{0},rowCount:{1},user:{2})", Common.NullSafeString(dtTable), Common.NullSafeString(rowCount), Common.NullSafeString(user));
            rowCount = 1;
            bool isProcessValidResult = true;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                isProcessValidResult = DoDataTableRowsHaveAllValidUtilityCodes(messageId) & DoDataTableRowsHaveAllValidAccountCodes(messageId);
                foreach (DataRow dataRow in dtTable.Rows)
                {
                    if (!IsValid(messageId, dataRow, rowCount))
                    {
                        isProcessValidResult = false;
                    }
                    rowCount++;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
                return isProcessValidResult;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        private void InvalidTableName()
        {
        }

        private bool IsValid(string messageId, DataRow dataRow, int rowCount)
        {
            bool isValidResult = true;
            int capacityThresholdValue = 0;
            // Calculate if data row is valid
            if (dataRow == null)
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Null Data Row");
                isValidResult = false;
            }
            if (dataRow["Use Capacity Threshold"] == null
               || string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow["Use Capacity Threshold"]))
                || !(Common.NullSafeString(dataRow["Use Capacity Threshold"]).Trim().ToUpper() == "TRUE" || Common.NullSafeString(dataRow["Use Capacity Threshold"]).Trim().ToUpper() == "FALSE"))
            {

                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Use Capacity Threshold");
                isValidResult = false;
            }
            if (dataRow["UtilityCode"] == null
                || string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow["UtilityCode"])))
            {

                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Utility Code ");
                isValidResult = false;
            }
            if (dataRow["CapacityThresholdMin"] == null
                || (Common.NullSafeString(dataRow["Use Capacity Threshold"]).Trim().ToUpper() == "FALSE" && !string.IsNullOrEmpty(Common.NullSafeString(dataRow["CapacityThresholdMin"]).Trim()))
                || (Common.NullSafeString(dataRow["Use Capacity Threshold"]).Trim().ToUpper() == "TRUE" &&
                   ((string.IsNullOrEmpty(Common.NullSafeString(dataRow["CapacityThresholdMin"]).Trim())) || (!(Common.NullSafeString(dataRow["CapacityThresholdMin"]).Trim().All(char.IsDigit)))))
                )
            {
                
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Capacity Threshold Min");
                isValidResult = false;
            }
            if (Common.NullSafeString(dataRow["Use Capacity Threshold"]).Trim().ToUpper() == "TRUE"
                && (Common.NullSafeInteger(Math.Ceiling(Common.NullSafeDecimal(Common.NullSafeString(dataRow["CapacityThresholdMin"]).Trim()))) < 0 || Common.NullSafeInteger(Math.Ceiling(Common.NullSafeDecimal(Common.NullSafeString(dataRow["CapacityThresholdMin"]).Trim()))) > 999)
                )
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Capacity Threshold Min");
                isValidResult = false;
            }
            if (dataRow["CapacityThresholdMax"] == null
                || (Common.NullSafeString(dataRow["Use Capacity Threshold"]).Trim().ToUpper() == "FALSE" && !string.IsNullOrEmpty(Common.NullSafeString(dataRow["CapacityThresholdMax"]).Trim()))
                || (Common.NullSafeString(dataRow["Use Capacity Threshold"]).Trim().ToUpper() == "TRUE" &&
                 ((string.IsNullOrEmpty(Common.NullSafeString(dataRow["CapacityThresholdMax"]).Trim())) || (!(Common.NullSafeString(dataRow["CapacityThresholdMax"]).Trim().All(char.IsDigit)))))
                )
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Capacity Threshold Max");
                isValidResult = false;
            }
            if (Common.NullSafeString(dataRow["Use Capacity Threshold"]).Trim().ToUpper() == "TRUE"
                && (Common.NullSafeInteger(Math.Ceiling(Common.NullSafeDecimal(Common.NullSafeString(dataRow["CapacityThresholdMax"]).Trim()))) < 0 || Common.NullSafeInteger(Math.Ceiling(Common.NullSafeDecimal(Common.NullSafeString(dataRow["CapacityThresholdMax"]).Trim()))) > 999)
                )
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Capacity Threshold Max");
                isValidResult = false;
            }

            if (Common.NullSafeString(dataRow["Use Capacity Threshold"]).Trim().ToUpper() == "TRUE" &&
                (Common.NullSafeInteger(Math.Ceiling(Common.NullSafeDecimal(Common.NullSafeString(dataRow["CapacityThresholdMin"]).Trim()))) >=
             Common.NullSafeInteger(Math.Ceiling(Common.NullSafeDecimal(Common.NullSafeString(dataRow["CapacityThresholdMax"]).Trim())))
               ))
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Capacity Threshold Min Should Be Less Than Capacity Threshold Max Value");
                isValidResult = false;
            }
            if (dataRow["Inactive"] == null
                 || string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow["Inactive"]))
                 || !(Common.NullSafeString(dataRow["Inactive"]).Trim().ToUpper() == "TRUE" || Common.NullSafeString(dataRow["Inactive"]).Trim().ToUpper() == "FALSE"))
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Inactive");
                isValidResult = false;
            }
            return isValidResult;
        }


        private bool IsDataRowADuplicate(string messageId, string utilityCode, string AccountType)
        {
            string method = string.Format("IsDataRowADuplicate(messageId:{0},utilityCode:{1},AccountType:{2})", messageId, utilityCode, AccountType);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                bool returnValue = false;
                UtilityManagementRepository.DataRepositoryEntityFramework dal = new DataRepositoryEntityFramework();

                DataSet dataSet = dal.usp_CapacityTresholdRule_IsDuplicate(messageId, utilityCode, AccountType);


                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} After DataSet", NAMESPACE, CLASS, method));

                if (dataSet != null && dataSet.Tables != null && dataSet.Tables.Count > 0 && dataSet.Tables[0] != null && dataSet.Tables[0].Rows != null && dataSet.Tables[0].Rows.Count > 0 && dataSet.Tables[0].Rows[0] != null && dataSet.Tables[0].Rows[0][0] != null)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} dataSet Validity Test Passed", NAMESPACE, CLASS, method));
                    int count = 0;
                    int.TryParse(dataSet.Tables[0].Rows[0][0].ToString(), out count);

                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} dataSet Parsed count:{3}", NAMESPACE, CLASS, method, count));

                    returnValue = count > 0;
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} dataSet Parsed returnValue:{3}", NAMESPACE, CLASS, method, returnValue));
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

        private bool IsDataRowAnExactDuplicate(string messageId, string utilityCode, bool
            CapcacityCheck, string AccountType, int CapacityTresholdmin, int CapacityTresholdmax, bool inactive)
        {
            string method = string.Format("IsDataRowAnExactDuplicate(messageId : {0},utilityCode:{1},CapcacityCheck:{2},AccountType:{3})", Common.NullSafeString(messageId), utilityCode,
                                         Common.NullSafeString(CapcacityCheck), Common.NullSafeString(AccountType), CapacityTresholdmin, CapacityTresholdmax, Common.NullSafeString(inactive));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                bool returnValue = false;
                UtilityManagementRepository.DataRepositoryEntityFramework dal = new DataRepositoryEntityFramework();
                DataSet dataSet = dal.usp_CapacityTresholdRule_IsExactDuplicate(messageId, utilityCode,
            CapcacityCheck, AccountType, CapacityTresholdmin, CapacityTresholdmax, inactive);


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
        #endregion

        #region protected methods
        protected override bool DoesDataTableHaveAllValidColumns(string messageId)
        {
            string method = string.Format("{0}.{1}.DoesDataTableHaveAllValidColumns(messageId)", NAMESPACE, CLASS);
            int rowCount = 0;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                bool returnValue = false;
                returnValue = _dataTable != null;
                if (!DoesDataTableHaveColumn(messageId, UTILITY_CODE))
                {
                    ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, string.Format("Missing Column({0})", UTILITY_CODE));
                    return false;
                }
                if (!DoesDataTableHaveColumn(messageId, ACCOUNTYPE))
                {
                    ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, string.Format("Missing Column({0})", ACCOUNTYPE));
                    return false;
                }
                if (!DoesDataTableHaveColumn(messageId, CAPACITYCHECK))
                {
                    ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, string.Format("Missing Column({0})", CAPACITYCHECK));
                    return false;
                }
                if (!DoesDataTableHaveColumn(messageId, CAPACITYTRESHOLDMIN))
                {
                    ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, string.Format("Missing Column({0})", CAPACITYTRESHOLDMIN));
                    return false;
                }
                if (!DoesDataTableHaveColumn(messageId, CAPACITYTRESHOLDMAX))
                {
                    ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, string.Format("Missing Column({0})", CAPACITYTRESHOLDMAX));
                    return false;
                }
                if (!DoesDataTableHaveColumn(messageId, INACTIVE))
                {
                    ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, string.Format("Missing Column({0})", INACTIVE));
                    return false;
                }
                int dataRowCounter = 0;
                if (_dataTable != null && _dataTable.Columns.Count > ListColumnNames.Count)
                {
                    ListColumnNames = ListColumnNames.ConvertAll(x => x.ToLower());
                    for (int i = ListColumnNames.Count; i < _dataTable.Columns.Count; i++)
                    {
                        if (_dataTable.Columns[i].ColumnName.ToLower().Contains("invalid column"))
                            ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, string.Format("Additional Column({0})", ""));
                        else if (_dataTable.Columns[i].ColumnName.ToLower().Contains("duplicate-"))
                            ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, string.Format("Additional Column({0})", _dataTable.Columns[i].ColumnName.ToUpper().Replace("DUPLICATE-", "")));
                        else
                            ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, string.Format("Additional Column({0})", _dataTable.Columns[i].ColumnName.ToUpper()));
                        
                    }
                    returnValue = false;
                }
                if (_dataTable != null)
                {
                    foreach (DataColumn dataColumn in _dataTable.Columns)
                    {

                        if (dataColumn != null && !(ListColumnNames[dataRowCounter].ToLower().Contains(dataColumn.ColumnName.ToLower().Trim())))
                        {
                            ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, string.Format("Invalid Column Order"));
                            returnValue = false;
                            break;
                        }
                        if(dataRowCounter<5)
                        dataRowCounter++;
                    }
                }

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
                if ((dataColumn.ColumnName == UTILITY_CODE || dataColumn.ColumnName == ACCOUNTYPE || dataColumn.ColumnName == CAPACITYCHECK ||
                                                dataColumn.ColumnName == CAPACITYTRESHOLDMIN || dataColumn.ColumnName == CAPACITYTRESHOLDMAX || dataColumn.ColumnName == INACTIVE)
                        && string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[dataColumn])))
                    return false;
            }
            return true;
        }

        #endregion
    }
}