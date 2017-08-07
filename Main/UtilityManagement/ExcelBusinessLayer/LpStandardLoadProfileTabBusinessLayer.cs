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
    public class LpStandardLoadProfileTabBusinessLayer : TabBusinessLayer
    {
        #region private variables
        private string CLASS = "LpStandardLoadProfileTabBusinessLayer";
        const string LP_STANDARD_LOAD_PROFILE_CODE = "LpStandardLoadProfileCode";
        protected const string TAB_NAME = "LP Std Load Profile";
        #endregion

        #region public constructors
        public LpStandardLoadProfileTabBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, DataTable dataTable, List<DataAccessLayerEntityFramework.UtilityCompany> utilityCompanies)
            : base(messageId, dataRepository, excelWorksheetUtility, logger, TAB_NAME, utilityCompanies)
        {
            string method = string.Format("{0}.{1}.LpStandardLoadProfileTabBusinessLayer(messageId,dataRepository,excelWorksheetUtility,logger,dataTable)", NAMESPACE, CLASS);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                Columns.Add(UTILITY_CODE);
                Columns.Add(LP_STANDARD_LOAD_PROFILE_CODE);
                Columns.Add(INACTIVE);
                TabOrder = 1;
                _dataTable = dataTable;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
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
                                && Common.NullSafeString(dataRow[LP_STANDARD_LOAD_PROFILE_CODE]).Length <= 255
                                && IsUtilityCodeActive(messageId, dataRow)
                            )
                            {
                                bool inactive = Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "true";
                                try
                                {
                                    DataSet dataSet = _dataRepository.usp_LpStandardLoadProfile_UPSERT(messageId, Guid.NewGuid().ToString(),
                                        Common.NullSafeString(dataRow[UTILITY_CODE]),
                                        Common.NullSafeString(dataRow[LP_STANDARD_LOAD_PROFILE_CODE]),
                                        inactive,
                                        userName);
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

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return true {3}", NAMESPACE, CLASS, method, Common.END));
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
        protected override bool DoesDataTableHaveAllValidColumns(string messageId)
        {
            string method = string.Format("{0}.{1}.DoesDataTableHaveAllValidColumns(messageId)", NAMESPACE, CLASS);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                bool returnValue = false;
                returnValue = _dataTable != null
                    && DoesDataTableHaveColumn(messageId, UTILITY_CODE)
                    && DoesDataTableHaveColumn(messageId, LP_STANDARD_LOAD_PROFILE_CODE)
                    && DoesDataTableHaveColumn(messageId, INACTIVE);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return returnValue:{3} {4}", NAMESPACE, CLASS, method, returnValue, Common.END));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion
    }
}