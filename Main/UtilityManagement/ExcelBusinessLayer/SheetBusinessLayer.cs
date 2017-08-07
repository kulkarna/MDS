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
    public class SheetBusinessLayer : ISheetBusinessLayer
    {
        #region private variables
        protected const string NAMESPACE = "ExcelBusinessLayer";
        private const string CLASS = "SheetBusinessLayer";
        protected IDataRepository _repository = null;
        protected IExcelWorksheetUtility _excelWorksheetUtility = null;
        protected ILogger _logger = null;
        public List<string> TabsSummaryList { get; set; }
        public List<string> TabSummaryWithRowNumbersList { get; set; }

        public TabsBusinessLayer _tabsBusinessLayer = null;
        #endregion


        #region public constructors
        public SheetBusinessLayer(IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger)
        {
            _repository = dataRepository;
            _excelWorksheetUtility = excelWorksheetUtility;

            TabsSummaryList = new List<string>();

            _logger = logger;
        }
        #endregion


        #region public virtual methods
        public virtual bool SaveAllFromDatabaseToExcel(string messageId, string filePathAndName)
        {
            string method = string.Format("SaveAllFromDatabaseToExcel(messageId,filePathAndName:{0})", filePathAndName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = GetTableOneDataSetAll(messageId);
                DataSet dataSetTwo = GetTableTwoDataSetAll(messageId);
                DataSet dataSetThree = GetTableThreeDataSetAll(messageId);
                dataSet.Tables.Add(dataSetTwo.Tables[0].Copy());
                dataSet.Tables.Add(dataSetThree.Tables[0].Copy());
                bool returnValue = SaveWorksheet(messageId, dataSet, filePathAndName);

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

        public virtual bool SaveFromDatabaseToExcel(string messageId, string utilityCode, string filePathAndName)
        {
            string method = string.Format("SaveFromDatabaseToExcel(messageId,utilityCode:{0},filePathAndName:{1})", utilityCode, filePathAndName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = GetTableOneDataSet(messageId, utilityCode);
                DataSet dataSetTwo = GetTableTwoDataSet(messageId, utilityCode);
                DataSet dataSetThree = GetTableThreeDataSet(messageId, utilityCode);
                dataSet.Tables.Add(dataSetTwo.Tables[0].Copy());
                dataSet.Tables.Add(dataSetThree.Tables[0].Copy());                
                bool returnValue = SaveWorksheet(messageId, dataSet, filePathAndName);

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

        public virtual bool UploadFromExcelToDatabase(string messageId, string utilityCode, string filePathAndName, string userName)
        {
            string method = string.Format("UploadFromExcelToDatabase(messageId,utilityCode:{0},filePathAndName:{1},userName:{2})", utilityCode, filePathAndName, userName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = LoadExcelData(messageId, filePathAndName);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} DataSet dataSet = LoadExcelData(messageId, filePathAndName)", NAMESPACE, CLASS, method));


                InsertDataTables(messageId, dataSet, userName);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return true END", NAMESPACE, CLASS, method));
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
        internal virtual void InsertDataTables(string messageId, DataSet dataSet, string userName)
        {
            throw new NotImplementedException();
        }

        protected virtual DataSet GetTableOneDataSetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        protected virtual DataSet GetTableTwoDataSetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        protected virtual DataSet GetTableThreeDataSetAll(string messageId)
        {
            throw new NotImplementedException();
        }

        protected virtual DataSet GetTableOneDataSet(string messageId, string utiltyCode)
        {
            throw new NotImplementedException();
        }

        protected virtual DataSet GetTableTwoDataSet(string messageId, string utiltyCode)
        {
            throw new NotImplementedException();
        }

        protected virtual DataSet GetTableThreeDataSet(string messageId, string utiltyCode)
        {
            throw new NotImplementedException();
        }

        protected bool SaveWorksheet(string messageId, DataSet dataSet, string filePathAndName)
        {
            string method = string.Format("SaveWorksheet(messageId,dataSet:{0}, filePathAndName:{1})", dataSet, filePathAndName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (dataSet != null && dataSet.Tables != null && dataSet.Tables.Count > 0)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _excelWorksheetUtility.GenerateAndSaveExcelWorkbook(messageId, filePathAndName, dataSet) Call", Common.NAMESPACE, CLASS, method));
                    _excelWorksheetUtility.GenerateAndSaveExcelWorkbook(messageId, filePathAndName, dataSet);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return true END", NAMESPACE, CLASS, method));
                    return true;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return false END", NAMESPACE, CLASS, method));
                return false;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        protected System.Data.DataSet LoadExcelData(string messageId, string fileName)
        {
            string method = string.Format("LoadExcelData(messageId,fileName:{0})", fileName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                System.Data.DataSet dataSet = _excelWorksheetUtility.GetDataFromWorksheet(messageId, fileName);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet END", NAMESPACE, CLASS, method));
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
    }
}