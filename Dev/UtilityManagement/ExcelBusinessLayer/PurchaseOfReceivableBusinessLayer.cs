using ExcelLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UtilityManagementRepository;
using UtilityLogging;

namespace ExcelBusinessLayer
{
    public class PurchaseOfReceivableBusinessLayer : SheetBusinessLayer
    {
        #region private variables
        private const string CLASS = "PurchaseOfReceivableBusinessLayer";
        private const string TABLE_ONE_NAME = "Purchase Of Receivable";
        #endregion

        #region public constructors
        public PurchaseOfReceivableBusinessLayer(IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger)
            : base(dataRepository, excelWorksheetUtility, logger)
        {
        }
        #endregion


        #region protected methods
        protected override DataSet GetTableOneDataSetAll(string messageId)
        {
            string method = "GetTableOneDataSetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_PurchaseOfReceivables_GetAll(messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} dataSet.Tables[0].TableName = TABLE_ONE_NAME;", NAMESPACE, CLASS, method));
                dataSet.Tables[0].TableName = TABLE_ONE_NAME;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet:{3} END", NAMESPACE, CLASS, method, dataSet));
                return dataSet;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        protected DataSet GetTableOneDataSetUndefined(string messageId)
        {
            string method = "GetTableOneDataSetUndefined(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_PurchaseOfReceivables_GetUndefined(messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} dataSet.Tables[0].TableName = TABLE_ONE_NAME;", NAMESPACE, CLASS, method));
                dataSet.Tables[0].TableName = TABLE_ONE_NAME;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet:{3} END", NAMESPACE, CLASS, method, dataSet));
                return dataSet;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        protected DataSet GetTableOneDataSetUndefinedAndAll(string messageId)
        {
            string method = "GetTableOneDataSetUndefinedAndAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_PurchaseOfReceivables_GetUndefinedAndAll(messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} dataSet.Tables[0].TableName = TABLE_ONE_NAME;", NAMESPACE, CLASS, method));
                dataSet.Tables[0].TableName = TABLE_ONE_NAME;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet:{3} END", NAMESPACE, CLASS, method, dataSet));
                return dataSet;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        protected override DataSet GetTableTwoDataSetAll(string messageId)
        {
            return null;
        }

        protected override DataSet GetTableThreeDataSetAll(string messageId)
        {
            return null;
        }
        
        protected override DataSet GetTableOneDataSet(string messageId, string utilityCode)
        {
            string method = string.Format("GetTableOneDataSet(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_PurchaseOfReceivables_GetByUtilityCode(messageId, utilityCode);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} dataSet.Tables[0].TableName = TABLE_ONE_NAME;", NAMESPACE, CLASS, method));
                dataSet.Tables[0].TableName = TABLE_ONE_NAME;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet:{3} END", NAMESPACE, CLASS, method, dataSet));
                return dataSet;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        protected override DataSet GetTableTwoDataSet(string messageId, string utilityCode)
        {
            return null;
        }

        protected override DataSet GetTableThreeDataSet(string messageId, string utilityCode)
        {
            return null;
        }
        #endregion

        #region internal method
        internal override void InsertDataTables(string messageId, DataSet dataSet, string userName)
        {
            string method = string.Format("InsertDataTables(messageId, dataSet, userName:{0})", userName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                _tabsBusinessLayer = new PurchaseOfReceivableTabsBusinessLayer(messageId, _repository, _excelWorksheetUtility, _logger, dataSet, userName);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _tabsBusinessLayer = new PurchaseOfReceivableTabsBusinessLayer(messageId, _repository, _excelWorksheetUtility, _logger, dataSet)", NAMESPACE, CLASS, method));
                TabsSummaryList = _tabsBusinessLayer.TabSummaryList;
                TabSummaryWithRowNumbersList = _tabsBusinessLayer.TabSummaryWithRowNumbersList;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} TabsSummaryList = _tabsBusinessLayer.TabSummaryList", NAMESPACE, CLASS, method));

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public override bool SaveFromDatabaseToExcel(string messageId, string utilityCode, string filePathAndName)
        {
            string method = string.Format("SaveFromDatabaseToExcel(messageId,utilityCode:{0},filePathAndName:{1})", utilityCode, filePathAndName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = GetTableOneDataSet(messageId, utilityCode);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} DataSet dataSet = GetTableOneDataSet(messageId, utilityCode) Called", NAMESPACE, CLASS, method));
                bool returnValue = SaveWorksheet(messageId, dataSet, filePathAndName);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} bool returnValue = SaveWorksheet(messageId, dataSet, filePathAndName) Called", NAMESPACE, CLASS, method));

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public override bool SaveAllFromDatabaseToExcel(string messageId, string filePathAndName)
        {
            string method = string.Format("SaveAllFromDatabaseToExcel(messageId,filePathAndName:{0})", filePathAndName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = GetTableOneDataSetAll(messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} DataSet dataSet = GetTableOneDataSetAll(messageId) Called", NAMESPACE, CLASS, method));
                bool returnValue = SaveWorksheet(messageId, dataSet, filePathAndName);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} bool returnValue = SaveWorksheet(messageId, dataSet, filePathAndName) Called", NAMESPACE, CLASS, method));

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public bool SaveUndefinedFromDatabaseToExcel(string messageId, string filePathAndName)
        {
            string method = string.Format("SaveUndefinedFromDatabaseToExcel(messageId,filePathAndName:{0})", filePathAndName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = GetTableOneDataSetUndefined(messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} DataSet dataSet = GetTableOneDataSetUndefined(messageId) Called", NAMESPACE, CLASS, method));
                bool returnValue = SaveWorksheet(messageId, dataSet, filePathAndName);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} bool returnValue = SaveWorksheet(messageId, dataSet, filePathAndName) Called", NAMESPACE, CLASS, method));

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public bool SaveUndefinedAndAllFromDatabaseToExcel(string messageId, string filePathAndName)
        {
            string method = string.Format("SaveUndefinedAndAllFromDatabaseToExcel(messageId,filePathAndName:{0})", filePathAndName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = GetTableOneDataSetUndefinedAndAll(messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} DataSet dataSet = GetTableOneDataSetUndefinedAndAll(messageId) Called", NAMESPACE, CLASS, method));
                bool returnValue = SaveWorksheet(messageId, dataSet, filePathAndName);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} bool returnValue = SaveWorksheet(messageId, dataSet, filePathAndName) Called", NAMESPACE, CLASS, method));

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
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