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
    public class LoadProfileTabBusinessLayer : TabBusinessLayer
    {
        #region private variables
        private string CLASS = "LoadProfileTabBusinessLayer";
        protected const string LOAD_PROFILE_ID = "LoadProfileId";
        protected const string LOAD_PROFILE = "LoadProfile";
        protected const string DESCRIPTION = "Description";
        protected const string ACCOUNT_TYPE = "AccountType";
        protected const string LIBERTY_POWER_STANDARD_LOAD_PROFILE = "LibertyPowerStandardLoadProfile";
        protected const string TAB_NAME = "Load Profile";
        #endregion

        #region public constructors
        public LoadProfileTabBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, DataTable dataTable, List<DataAccessLayerEntityFramework.UtilityCompany> utilityCompanies)
            : base(messageId, dataRepository, excelWorksheetUtility, logger, TAB_NAME, utilityCompanies)
        {
            string method = string.Format("{0}.{1}.LoadProfileTabBusinessLayer(messageId,dataRepository,excelWorksheetUtility,logger,dataTable)", NAMESPACE, CLASS);
            try
            {
                _logger = logger;
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                Columns.Add(UTILITY_CODE);
                Columns.Add(LOAD_PROFILE_ID);
                Columns.Add(LOAD_PROFILE);
                Columns.Add(DESCRIPTION);
                Columns.Add(ACCOUNT_TYPE);
                Columns.Add(LIBERTY_POWER_STANDARD_LOAD_PROFILE);
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
            string method = string.Format("Populate(messageId,userName:{0})",userName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                int rowCount=1;
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
                                    DataSet dataSet = _dataRepository.usp_LoadProfile_UPSERT(messageId, Guid.NewGuid().ToString(),

                                        Common.NullSafeString(dataRow[UTILITY_CODE]),
                                        Common.NullSafeString(dataRow[LIBERTY_POWER_STANDARD_LOAD_PROFILE]),
                                        Common.NullSafeString(dataRow[LOAD_PROFILE]),
                                        Common.NullSafeString(dataRow[DESCRIPTION]),
                                        Common.NullSafeString(dataRow[ACCOUNT_TYPE]),
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
                    && DoesDataTableHaveColumn(messageId, LOAD_PROFILE_ID)
                    && DoesDataTableHaveColumn(messageId, LOAD_PROFILE)
                    && DoesDataTableHaveColumn(messageId, DESCRIPTION)
                    && DoesDataTableHaveColumn(messageId, ACCOUNT_TYPE)
                    && DoesDataTableHaveColumn(messageId, LIBERTY_POWER_STANDARD_LOAD_PROFILE)
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