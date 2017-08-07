﻿using ExcelLibrary;
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
    public class MeterReadCalendarTabBusinessLayer : TabBusinessLayer
    {
        #region private variables
        private string CLASS = "MeterReadCalendarTabBusinessLayer";

        protected const string YEAR = "Year";
        protected const string MONTH = "Month";
        protected const string READ_CYCLE_ID = "ReadCycleId";
        protected const string READ_DATE = "ReadDate";
        protected const string IS_AMR = "IsAmr";
        protected const string TAB_NAME = "Meter Read Calendar";
        #endregion

        #region public constructors
        public MeterReadCalendarTabBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, DataTable dataTable, List<DataAccessLayerEntityFramework.UtilityCompany> utilityCompanies)
            : base(messageId, dataRepository, excelWorksheetUtility, logger, TAB_NAME, utilityCompanies)
        {
            string method = string.Format("{0}.{1}.MeterReadCalendarTabBusinessLayer(messageId,dataRepository,excelWorksheetUtility,logger,dataTable)", NAMESPACE, CLASS);
            try
            {
                _logger = logger;
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                Columns.Add(UTILITY_CODE);
                Columns.Add(YEAR);
                Columns.Add(MONTH);
                Columns.Add(READ_CYCLE_ID);
                Columns.Add(READ_DATE);
                Columns.Add(IS_AMR);
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
                int year = Common.NullSafeInteger(dataRow[YEAR]);
                int month = Common.NullSafeInteger(dataRow[MONTH]);
                string readCycleId = Common.NullSafeString(dataRow[READ_CYCLE_ID]).Trim();
                DateTime readDate = Common.NullSafeDateTime(dataRow[READ_DATE]);
                bool isAmr = (bool)Common.NullableBoolean(dataRow[IS_AMR]);
                bool inactive = (bool)Common.NullableBoolean(dataRow["Inactive"]);
                bool isDuplicate = false;
                bool isAnExactDuplicate = false;

                if (!IsValid(messageId, dataRow, rowCount))
                {
                    return;
                }

                isAnExactDuplicate = IsDataRowAnExactDuplicate(messageId, dataRow);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} isAnExactDuplicate:{3}", NAMESPACE, CLASS, method, isAnExactDuplicate));
                if (isAnExactDuplicate)
                {
                    ExcelTabImportSummary.DuplicateRecordCount++;
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
                    return;
                }

                isDuplicate = IsDataRowADuplicate(messageId, dataRow);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} isDuplicate:{3}", NAMESPACE, CLASS, method, isDuplicate));
                if (isDuplicate)
                {
                    dref.usp_MeterReadCalendar_UPDATE(messageId, Guid.NewGuid(), utilityCode, year, month, readCycleId, readDate, isAmr, inactive, user);
                    ExcelTabImportSummary.UpdatedRecordCount++;
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
                    return;
                }
                _logger.LogInfo(messageId, string.Format("NAMESPACE:{0}",Common.NullSafeString(NAMESPACE)));
                _logger.LogInfo(messageId, string.Format("CLASS:{0}",Common.NullSafeString(CLASS)));
                _logger.LogInfo(messageId, string.Format("method:{0}",Common.NullSafeString(method)));
                _logger.LogInfo(messageId, string.Format("utilityCode:{0}",Common.NullSafeString(utilityCode)));
                _logger.LogInfo(messageId, string.Format("year:{0}",year));
                _logger.LogInfo(messageId, string.Format("month:{0}",month));
                _logger.LogInfo(messageId, string.Format("readCycleId:{0}", Common.NullSafeString(readCycleId).Trim()));
                _logger.LogInfo(messageId, string.Format("readDate:{0}",Common.NullSafeString(readDate)));
                _logger.LogInfo(messageId, string.Format("isAmr:{0}", Common.NullSafeString(isAmr)));
                _logger.LogInfo(messageId, string.Format("inactive:{0}",Common.NullSafeString(inactive)));

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEFORE dref.usp_MeterReadCalendar_INSERT(messageId, Guid.NewGuid(), utilityCode:{3}, year:{4}, month:{5}, readCycleId:{6}, readDate:{7}, isAmr:{8}, inactive:{9}, user:{10})", 
                    Common.NullSafeString(NAMESPACE), Common.NullSafeString(CLASS), Common.NullSafeString(method), Common.NullSafeString(utilityCode), year, month, Common.NullSafeString(readCycleId), Common.NullSafeDateTime(readDate), isAmr, inactive, user));
                dref.usp_MeterReadCalendar_INSERT(messageId, Guid.NewGuid(), utilityCode, year, month, readCycleId, readDate, isAmr, inactive, user);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} AFTER dref.usp_MeterReadCalendar_INSERT(messageId, Guid.NewGuid(), utilityCode:{3}, year:{4}, month:{5}, readCycleId:{6}, readDate:{7}, isAmr:{8}, inactive:{9}, user:{10})",
                    NAMESPACE, CLASS, method, utilityCode, year, month, readCycleId, readDate, isAmr, inactive, user));

                ExcelTabImportSummary.InsertedRecordCount++;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private bool IsValid(string messageId, DataRow dataRow, int rowCount)
        {
            // Calculate if data row is valid
            if (dataRow == null)
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Null Data Row");
                return false;
            }
            if (dataRow["Year"] == null || Common.NullSafeInteger(dataRow["Year"]) < 2011 || Common.NullSafeInteger(dataRow["Year"]) > 2064)
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Year Value");
                return false;
            }
            if (dataRow["Month"] == null || Common.NullSafeInteger(dataRow["Month"]) <= 0 || Common.NullSafeInteger(dataRow["Month"]) > 12)
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Month Value");
                return false;
            }
            if (dataRow["UtilityCode"] == null
                || string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow["UtilityCode"])))
            {

                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Utility Value");
                return false;
            }
            if (dataRow["ReadCycleId"] == null || string.IsNullOrWhiteSpace(dataRow["ReadCycleId"].ToString()) || (Convert.ToString(dataRow["ReadCycleId"]).Any(ch => !Char.IsLetterOrDigit(ch))) || dataRow["ReadCycleId"].ToString().Length < 1)
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Read Cycle Id Value");
                return false;
            }
            if (dataRow["ReadCycleId"].ToString().Length > 255)
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Meter Read Cycle ID Is Too Long. It Cannot Be Greater Than 255 Characers");
                return false;
            }
            if (dataRow["ReadDate"] == null || !Common.IsValidDate(Common.NullSafeDateTime(dataRow["ReadDate"])))
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Read Date Value");
                return false;
            }
            if (dataRow["IsAmr"] == null || !(Common.NullSafeString(dataRow["IsAmr"]).Trim().ToUpper() == "TRUE" || Common.NullSafeString(dataRow["IsAmr"]).Trim().ToUpper() == "FALSE"))
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Is AMR Value");
                return false;
            }


            return true;
        }


        private bool IsDataRowADuplicate(string messageId, DataRow dataRow)
        {
            string method = string.Format("IsDataRowADuplicate(messageId,dataRow:{0})", Common.NullSafeString(dataRow));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                bool returnValue = false;
                UtilityManagementRepository.DataRepositoryEntityFramework dal = new DataRepositoryEntityFramework();

                DataSet dataSet = dal.usp_MeterReadCalendar_IsDuplicate(messageId, Common.NullSafeString(dataRow[UTILITY_CODE]), Common.NullSafeInteger(dataRow[YEAR]),
    Common.NullSafeInteger(dataRow[MONTH]), Common.NullSafeString(dataRow[READ_CYCLE_ID]), (Convert.ToBoolean(dataRow[IS_AMR]??false)));


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

        private bool IsDataRowAnExactDuplicate(string messageId, DataRow dataRow)
        {
            string method = string.Format("IsDataRowAnExactDuplicate(messageId,dataRow:{0})", Common.NullSafeString(dataRow));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

                bool returnValue = false;
                UtilityManagementRepository.DataRepositoryEntityFramework dal = new DataRepositoryEntityFramework();

                DataSet dataSet = dal.usp_MeterReadCalendar_IsExactDuplicate(messageId, Common.NullSafeString(dataRow[UTILITY_CODE]), Common.NullSafeInteger(dataRow[YEAR]),
    Common.NullSafeInteger(dataRow[MONTH]), Common.NullSafeString(dataRow[READ_CYCLE_ID]), Common.NullSafeString(dataRow[READ_DATE]).Replace('/', '-'),(Convert.ToBoolean(dataRow[IS_AMR]??false)), (Convert.ToBoolean(dataRow[INACTIVE]??false)));


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
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                bool returnValue = false;
                returnValue = _dataTable != null
                    && DoesDataTableHaveColumn(messageId, UTILITY_CODE)
                    && DoesDataTableHaveColumn(messageId, YEAR)
                    && DoesDataTableHaveColumn(messageId, MONTH)
                    && DoesDataTableHaveColumn(messageId, READ_CYCLE_ID)
                    && DoesDataTableHaveColumn(messageId, READ_DATE)
                    && DoesDataTableHaveColumn(messageId, IS_AMR)
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
                if ((dataColumn.ColumnName == UTILITY_CODE || dataColumn.ColumnName == YEAR || dataColumn.ColumnName == MONTH ||
                                                dataColumn.ColumnName == READ_CYCLE_ID || dataColumn.ColumnName == READ_DATE || dataColumn.ColumnName == IS_AMR || dataColumn.ColumnName == INACTIVE)
                        && string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[dataColumn])))
                    return false;
            }
            return true;
        }

        #endregion
    }
}