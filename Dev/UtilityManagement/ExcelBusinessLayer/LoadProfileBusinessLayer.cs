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
    public class LoadProfileBusinessLayer : SheetBusinessLayer
    {
        #region private variables
        private const string CLASS = "LoadProfileBusinessLayer";
        private const string TABLE_ONE_NAME = "Load Profile";
        private const string TABLE_TWO_NAME = "LP Std Load Profile";
        private const string TABLE_THREE_NAME = "Load Profile Alias";
        #endregion

        #region public constructors
        public LoadProfileBusinessLayer(IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger)
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

                DataSet dataSet = _repository.usp_LoadProfile_GetAll(messageId);
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
            string method = "GetTableTwoDataSet(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_LpStandardLoadProfile_GetAll(messageId);
                dataSet.Tables[0].TableName = TABLE_TWO_NAME;

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

        protected override DataSet GetTableThreeDataSetAll(string messageId)
        {
            string method = "GetTableThreeDataSetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_LoadProfileAlias_GetAll(messageId);
                dataSet.Tables[0].TableName = TABLE_THREE_NAME;

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
        
        protected override DataSet GetTableOneDataSet(string messageId, string utilityCode)
        {
            string method = string.Format("GetTableOneDataSet(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_LoadProfile_GetByUtilityCode(messageId, utilityCode);
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
            string method = string.Format("GetTableTwoDataSet(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_LpStandardLoadProfile_GetByUtilityCode(messageId, utilityCode);
                dataSet.Tables[0].TableName = TABLE_TWO_NAME;

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

        protected override DataSet GetTableThreeDataSet(string messageId, string utilityCode)
        {
            string method = string.Format("GetTableThreeDataSet(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_LoadProfileAlias_GetByUtilityCode(messageId, utilityCode);
                dataSet.Tables[0].TableName = TABLE_THREE_NAME;

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
        #endregion

        #region internal method
        internal override void InsertDataTables(string messageId, DataSet dataSet, string userName)
        {
            string method = string.Format("InsertDataTables(messageId, dataSet, userName:{0})", Utilities.Common.NullSafeString(userName));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                _tabsBusinessLayer = new LoadProfileTabsBusinessLayer(messageId, _repository, _excelWorksheetUtility, _logger, dataSet, userName);
                TabsSummaryList = _tabsBusinessLayer.TabSummaryList;
                TabSummaryWithRowNumbersList = _tabsBusinessLayer.TabSummaryWithRowNumbersList;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
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