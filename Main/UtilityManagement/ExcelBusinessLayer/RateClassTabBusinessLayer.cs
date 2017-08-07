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
    public class RateClassTabBusinessLayer : TabBusinessLayer
    {
        #region private variables
        private string CLASS = "RateClassTabBusinessLayer";
        protected const string RATE_CLASS_ID = "RateClassId";
        protected const string RATE_CLASS = "RateClass";
        protected const string DESCRIPTION = "Description";
        protected const string ACCOUNT_TYPE = "AccountType";
        protected const string LIBERTY_POWER_STANDARD_RATE_CLASS = "LibertyPowerStandardRateClass";
        protected const string TAB_NAME = "Rate Class";
        #endregion

        #region public constructors
        public RateClassTabBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, DataTable dataTable, List<DataAccessLayerEntityFramework.UtilityCompany> utilityCompanies)
            : base(messageId, dataRepository, excelWorksheetUtility, logger, TAB_NAME, utilityCompanies)
        {
            string method = string.Format("{0}.{1}.RateClassTabBusinessLayer(messageId,dataRepository,excelWorksheetUtility,logger,dataTable)", NAMESPACE, CLASS);
            try
            {
                _logger = logger;
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                Columns.Add(UTILITY_CODE);
                Columns.Add(RATE_CLASS_ID);
                Columns.Add(RATE_CLASS);
                Columns.Add(DESCRIPTION);
                Columns.Add(ACCOUNT_TYPE);
                Columns.Add(LIBERTY_POWER_STANDARD_RATE_CLASS);
                Columns.Add(INACTIVE);
                TabOrder = 2;
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
            string method = string.Format("Populate(messageId, userName:{0})", Common.NullSafeString(userName));
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

                            if
                            (
                                DoAllDataRowCellHaveNonEmptyValues(dataRow)
                                &&
                                (
                                    Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "true"
                                    || Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "false"
                                )
                                && IsUtilityCodeActive(messageId, dataRow)
                            )
                            {
                                bool inactive = Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "true";
                                try
                                {
                                    DataSet dataSet = _dataRepository.usp_RateClass_UPSERT(messageId, Guid.NewGuid().ToString(),

                                        Common.NullSafeString(dataRow[UTILITY_CODE]),
                                        Common.NullSafeString(dataRow[LIBERTY_POWER_STANDARD_RATE_CLASS]),
                                        Common.NullSafeString(dataRow[RATE_CLASS]),
                                        Common.NullSafeString(dataRow[DESCRIPTION]),
                                        Common.NullSafeString(dataRow[ACCOUNT_TYPE]),
                                        inactive,
                                        Common.NullSafeString(userName));
                                    this.ExcelTabImportSummary.ProcessCount(dataSet, rowCount);
                                }
                                catch (Exception)
                                {
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
                    && DoesDataTableHaveColumn(messageId, RATE_CLASS_ID)
                    && DoesDataTableHaveColumn(messageId, RATE_CLASS)
                    && DoesDataTableHaveColumn(messageId, DESCRIPTION)
                    && DoesDataTableHaveColumn(messageId, ACCOUNT_TYPE)
                    && DoesDataTableHaveColumn(messageId, LIBERTY_POWER_STANDARD_RATE_CLASS)
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