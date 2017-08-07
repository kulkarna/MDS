using ExcelLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UtilityManagementRepository;
using UtilityLogging;
using Utilities;

namespace ExcelBusinessLayer
{
    public class CapacityTresholdRuleBusinessLayer : SheetBusinessLayer
    {
        #region private variables
        private const string CLASS = "CapacityThresholdRuleBusinessLayer";
        private const string TABLE_ONE_NAME = "CapacityThresholdRule";
        protected const string CAPACITYCHECK = "Use Capacity Threshold";
        protected const string ACCOUNTYPE = "Account Type";
        protected const string CAPACITYTRESHOLDMIN = "CapacityThresholdMin";
        protected const string CAPACITYTRESHOLDMAX = "CapacityThresholdMax";
        protected const string INACTIVE = "Inactive";
        protected const string UTILITY_CODE = "UtilityCode";
        
        #endregion

        #region public constructors
        public CapacityTresholdRuleBusinessLayer(IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger)
            : base(dataRepository, excelWorksheetUtility, logger)
        {
            TabSummaryWithRowNumbersList = new List<string>();
        }
        #endregion


        #region protected methods
  protected override DataSet GetTableOneDataSet(string messageId, string utilityCode)
        {
            string method = string.Format("GetTableOneDataSet(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_CapacityThresholdRuleGetByUtilityCode(messageId, utilityCode);
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

  protected override DataSet GetTableOneDataSetAll(string messageId)
  {
      string method = "GetTableOneDataSetAll(messageId)";
      try
      {
          _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

          DataSet dataSet = _repository.usp_CapacityThresholdRule_GetAll(messageId);
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

  #region internal method
  internal override void InsertDataTables(string messageId, DataSet dataSet, string userName)
  {
      string method = string.Format("InsertDataTables(messageId, dataSet, userName:{0})", userName);
      try
      {
          _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

          _tabsBusinessLayer = new CapacityTresholdTabsBusinessLayer(messageId, _repository, _excelWorksheetUtility, _logger, dataSet, userName);
          _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} _tabsBusinessLayer = new CapacityTresholdTabsBusinessLayer(messageId, _repository, _excelWorksheetUtility, _logger, dataSet)", NAMESPACE, CLASS, method));
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

  public  DataTable CapacityTresholdTable(DataTable dataTable,string messageId)
  {

      string method = string.Format("CapacityTresholdTable(dataTable)");
      DataTable dtCapacityTreshold = new DataTable();
      try
      {
          
          dtCapacityTreshold.Columns.Add(UTILITY_CODE);
          dtCapacityTreshold.Columns.Add(ACCOUNTYPE);
          dtCapacityTreshold.Columns.Add(CAPACITYCHECK);
          dtCapacityTreshold.Columns.Add(CAPACITYTRESHOLDMIN);
          dtCapacityTreshold.Columns.Add(CAPACITYTRESHOLDMAX);
          dtCapacityTreshold.Columns.Add(INACTIVE);

          if (dataTable != null && dataTable.Rows != null && dataTable.Rows.Count > 0)
          {
              
              foreach (DataRow dataRow in dataTable.Rows)
              {
                  bool useCapacityThreshold = (dataRow["IgnoreCapacityFactor"] != null) ? Convert.ToBoolean(dataRow["IgnoreCapacityFactor"]) : false;
                  DataRow drCapacityTreshold = dtCapacityTreshold.NewRow();
                  drCapacityTreshold[UTILITY_CODE] = dataRow["UtilityCode"];
                  drCapacityTreshold[CAPACITYCHECK] = Common.NullSafeString(!Common.NullableBoolean(dataRow["IgnoreCapacityFactor"])).ToUpper();
                  drCapacityTreshold[ACCOUNTYPE] = dataRow["AccountType"];
                  if (useCapacityThreshold)
                  {
                      drCapacityTreshold[CAPACITYTRESHOLDMIN] = null;
                      drCapacityTreshold[CAPACITYTRESHOLDMAX] = null;
                  }
                  else
                  {
                      drCapacityTreshold[CAPACITYTRESHOLDMIN] = dataRow["CapacityThreshold"];
                      drCapacityTreshold[CAPACITYTRESHOLDMAX] = dataRow["CapacityThresholdMax"];
                  }
                  drCapacityTreshold[INACTIVE] = dataRow["Inactive"];
                  dtCapacityTreshold.Rows.Add(drCapacityTreshold);

              }
          }
      }
      catch (Exception exc)
      {
          _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
          _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
          throw;
      }
      return dtCapacityTreshold;
  }

  public override bool SaveFromDatabaseToExcel(string messageId, string utilityCode, string filePathAndName)
  {
      string method = string.Format("SaveFromDatabaseToExcel(messageId,utilityCode:{0},filePathAndName:{1})", utilityCode, filePathAndName);
      try
      {
          _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

          DataSet dataSet = GetTableOneDataSet(messageId, utilityCode);
          DataTable dataTableOne = new DataTable();
          dataTableOne=CapacityTresholdTable(dataSet.Tables[TABLE_ONE_NAME],messageId);
          dataTableOne.TableName = TABLE_ONE_NAME;
          dataSet.Tables.Remove(TABLE_ONE_NAME);
          dataSet.Tables.Add(dataTableOne);
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
  #endregion

    }
}