using ExcelLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;
using UtilityManagementRepository;
using UtilityLogging;

namespace ExcelBusinessLayer
{
    public class LoadProfileAliasTabBusinessLayer : TabBusinessLayer
    {
        #region private variables
        private string CLASS = "LoadProfileAliasTabBusinessLayer";
        const string LOAD_PROFILE_ID = "LoadProfileId";
        const string LOAD_PROFILE_CODE_ALIAS = "LoadProfileCodeAlias";
        protected const string TAB_NAME = "Load Profile Alias";
        #endregion

        #region public constructors
        public LoadProfileAliasTabBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, DataTable dataTable, List<DataAccessLayerEntityFramework.UtilityCompany> utilityCompanies)
            : base(messageId, dataRepository, excelWorksheetUtility, logger, TAB_NAME, utilityCompanies)
        {
            string method = string.Format("{0}.{1}.LoadProfileAliasTabBusinessLayer(messageId,dataRepository,excelWorksheetUtility,logger,dataTable)", NAMESPACE, CLASS);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                Columns.Add(UTILITY_CODE);
                Columns.Add(LOAD_PROFILE_ID);
                Columns.Add(LOAD_PROFILE_CODE_ALIAS);
                Columns.Add(INACTIVE);
                TabOrder = 3;
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


        #region protected methods
        protected override bool DoesDataTableHaveAllValidColumns(string messageId)
        {
            bool returnValue = false;
            returnValue = _dataTable != null
                && DoesDataTableHaveColumn(messageId, UTILITY_CODE)
                && DoesDataTableHaveColumn(messageId, LOAD_PROFILE_ID)
                && DoesDataTableHaveColumn(messageId, LOAD_PROFILE_CODE_ALIAS)
                && DoesDataTableHaveColumn(messageId, INACTIVE);
            return returnValue;
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

                            if
                            (
                                DoAllDataRowCellHaveNonEmptyValues(dataRow)
                                &&
                                (
                                    Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "true"
                                    || Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "false"
                                )
                                && Common.NullSafeString(dataRow[LOAD_PROFILE_CODE_ALIAS]).Length <= 255
                                && IsUtilityCodeActive(messageId, dataRow)
                            )
                            {
                                bool inactive = Common.NullSafeString(dataRow[INACTIVE]).ToLower().Trim() == "true";
                                try
                                {
                                    DataSet dataSet = _dataRepository.usp_LoadProfileAlias_UPSERT(messageId, Guid.NewGuid().ToString(),

                                        Common.NullSafeString(dataRow[UTILITY_CODE]),
                                        Common.NullSafeInteger(dataRow[LOAD_PROFILE_ID]),
                                        Common.NullSafeString(dataRow[LOAD_PROFILE_CODE_ALIAS]),
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
    }
}