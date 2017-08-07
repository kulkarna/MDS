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
    public class TariffCodeBusinessLayer : SheetBusinessLayer
    {
        #region private variables
        private const string CLASS = "TariffCodeBusinessLayer";
        public const string TABLE_ONE_NAME = "Tariff Code";
        public const string TABLE_TWO_NAME = "LP Std Tariff Code";
        public const string TABLE_THREE_NAME = "Tariff Code Alias";
        #endregion

        #region public constructors
        public TariffCodeBusinessLayer(IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger)
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

                DataSet dataSet = _repository.usp_TariffCode_GetAll(messageId);
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
            string method = "GetTableTwoDataSetAll(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_LpStandardTariffCode_GetAll(messageId);
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

                DataSet dataSet = _repository.usp_TariffCodeAlias_GetAll(messageId);
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

                DataSet dataSet = _repository.usp_TariffCode_GetByUtilityCode(messageId, utilityCode);
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

                DataSet dataSet = _repository.usp_LpStandardTariffCode_GetByUtilityCode(messageId, utilityCode);
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

                DataSet dataSet = _repository.usp_TariffCodeAlias_GetByUtilityCode(messageId, utilityCode);
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
            string method = string.Format("InsertDataTables(messageId, dataSet, userName:{0})", userName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                _tabsBusinessLayer = new TariffCodeTabsBusinessLayer(messageId, _repository, _excelWorksheetUtility, _logger, dataSet, userName);
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