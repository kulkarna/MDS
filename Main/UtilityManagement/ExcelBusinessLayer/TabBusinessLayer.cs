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
    public class TabBusinessLayer : ITabBusinessLayer
    {
        #region private variables
        protected const string NAMESPACE = "ExcelBusinessLayer";
        private const string CLASS = "BusinessLayer";
        protected const string UTILITY_CODE = "UtilityCode";
        protected const string ACCOUNTYPE = "Account Type";
        protected const string INACTIVE = "Inactive";
        protected const string USER = "ExcelImport";
        protected ILogger _logger = null;
        protected IDataRepository _dataRepository = null;
        protected IExcelWorksheetUtility _excelWorksheetUtility = null;
        protected List<string> Columns = new List<string>();
        protected DataTable _dataTable = null;
        #endregion

        #region public constructors
        public TabBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, string tabName, List<DataAccessLayerEntityFramework.UtilityCompany> utilityCompanies)
        {
            _dataRepository = dataRepository;
            _excelWorksheetUtility = excelWorksheetUtility;
            _logger = logger;
            TabOrder = 0;
            this.ExcelTabImportSummary = new ExcelTabImportSummary(tabName);
            UtilityCompanies = utilityCompanies;
        }
       
        public TabBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, string tabName, List<DataAccessLayerEntityFramework.UtilityCompany> utilityCompanies
            , List<DataAccessLayerEntityFramework.CustomerAccountType> customerAccountType)
        {
            _dataRepository = dataRepository;
            _excelWorksheetUtility = excelWorksheetUtility;
            _logger = logger;
            TabOrder = 0;
            this.ExcelTabImportSummary = new ExcelTabImportSummaryCapacityThreshold(tabName);
            UtilityCompanies = utilityCompanies;
            CustomerAccountTypes = customerAccountType;
        }
        #endregion

        #region public properties
        public List<string> UtilityCodes { get; set; }
        public List<string> ParsedUtilityCodes { get; set; }
        public List<string> CustomerAccountCodes { get; set; }
        public List<string> ParsedCustomerAccountTypes { get; set; }
        public int TabOrder { get; set; }
        public ExcelTabImportSummary ExcelTabImportSummary { get; set; }
        public List<DataAccessLayerEntityFramework.UtilityCompany> UtilityCompanies { get; set; }
        public List<DataAccessLayerEntityFramework.CustomerAccountType> CustomerAccountTypes { get; set; }
        #endregion

        #region internal methods
        internal bool IsUtilityCodeActive(string messageId, DataRow dataRow)
        {
            string method = string.Format("{0}.{1}.IsUtilityCodeActive(messageId,dataRow:{2})", NAMESPACE, CLASS, dataRow);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                bool returnValue = false;

                if (dataRow != null
                    && !string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[UTILITY_CODE]))
                    && UtilityCodes.Contains(Common.NullSafeString(dataRow[UTILITY_CODE]).Trim().ToLower()))
                {
                    returnValue = UtilityCompanies.Where(x => x.UtilityCode.Trim().ToLower() == Common.NullSafeString(dataRow[UTILITY_CODE]).Trim().ToLower()).FirstOrDefault().Inactive == false;
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

        internal bool DoesDataTableHaveColumn(string messageId, string columnName)
        {
            string method = string.Format("{0}.{1}.DoesDataTableHaveColumn(messageId,columnName:{2})", NAMESPACE, CLASS, columnName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                bool returnValue = false;
                if (_dataTable != null)
                {
                    foreach (DataColumn dataColumn in _dataTable.Columns)
                    {
                        if (dataColumn != null && dataColumn.ColumnName.ToLower() == columnName.ToLower())
                        {
                            returnValue = true;
                            break;
                        }
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

        internal virtual bool DoAllDataRowCellHaveNonEmptyValues(DataRow dataRow)
        { 
            foreach (DataColumn dataColumn in _dataTable.Columns)
            {
                if (dataRow[dataColumn] == null || string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[dataColumn])))
                    return false;
            }
            return true;
        }

        protected virtual bool DoesDataTableHaveAllValidColumns(string messageId)
        {
            throw new NotImplementedException();
        }
        #endregion

        #region public methods
        public virtual bool IsExcelTabValid(string messageId)
        {
            string method = string.Format("{0}.{1}.IsExcelTabValid(messageId)", NAMESPACE, CLASS);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                bool returnValue = false;
                returnValue = DoesDataTableHaveAllValidColumns(messageId) && DoDataTableRowsHaveAllValidUtilityCodes(messageId);

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

        public virtual bool Populate(string messageId, string userName)
        {
            throw new NotImplementedException();
        }

        public bool DoDataTableRowsHaveAllValidUtilityCodes(string messageId)
        {
            string method = string.Format("{0}.{1}.DoDataTableRowsHaveAllValidUtilityCodes(messageId)", NAMESPACE, CLASS);
            bool isUtilityCodeValid = true;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                if (_dataTable != null && _dataTable.Rows != null)
                {
                    if (_dataTable.Rows.Count > 0)
                    {
                        int dataRowCounter = 1;
                        foreach (DataRow dataRow in _dataTable.Rows)
                        {
                            if (!UtilityCodes.Contains(dataRow[UTILITY_CODE].ToString().ToLower().Trim()) && dataRowCounter < _dataTable.Rows.Count)
                            {
                                _logger.LogInfo(messageId, string.Format("{0} return false {1}", method, Common.END));
                                ExcelTabImportSummary.IncrementInvalidRecordCount(dataRowCounter, string.Format("Invalid Utility Code ({0})", Common.NullSafeString(dataRow[UTILITY_CODE])));
                                if (isUtilityCodeValid)
                                    isUtilityCodeValid = false;
                                
                            }
                            dataRowCounter++;
                        }
                    }
                    _logger.LogInfo(messageId, string.Format("{0} return true {1}", method, Common.END));
                    return isUtilityCodeValid;
                }

                _logger.LogInfo(messageId, string.Format("{0} return false {1}", method, Common.END));
                return false;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0} ERROR:{1}", method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} END", method));
                throw;
            }
        }

        public bool DoDataTableRowsHaveAllValidAccountCodes(string messageId)
        {
            string method = string.Format("{0}.{1}.DoDataTableRowsHaveAllValidAccountCodes(messageId)", NAMESPACE, CLASS);
            bool isValidAccountTypes = true;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                if (_dataTable != null && _dataTable.Rows != null)
                {
                    if (_dataTable.Rows.Count > 0)
                    {
                        int dataRowCounter = 1;
                        foreach (DataRow dataRow in _dataTable.Rows)
                        {
                            if (!CustomerAccountCodes.Contains(dataRow[ACCOUNTYPE].ToString().ToLower().Trim()) && dataRowCounter < _dataTable.Rows.Count)
                            {
                                _logger.LogInfo(messageId, string.Format("{0} return false {1}", method, Common.END));
                                ExcelTabImportSummary.IncrementInvalidRecordCount(dataRowCounter, string.Format("Invalid Account Type ({0})", Common.NullSafeString(dataRow[ACCOUNTYPE].ToString())));
                                if(isValidAccountTypes)
                                isValidAccountTypes= false;
                            }
                            dataRowCounter++;
                        }
                    }
                    _logger.LogInfo(messageId, string.Format("{0} return true {1}", method, Common.END));
                    return isValidAccountTypes;
                }

                _logger.LogInfo(messageId, string.Format("{0} return false {1}", method, Common.END));
                return false;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0} ERROR:{1}", method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} END", method));
                throw;
            }
        }
        #endregion

        #region private methods
       
        #endregion


    }
}