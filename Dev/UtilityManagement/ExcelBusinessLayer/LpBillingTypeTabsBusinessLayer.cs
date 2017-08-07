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
    public class LpBillingTypeTabsBusinessLayer : TabsBusinessLayer
    {
        #region private variables
        private string CLASS = "LpBillingTypeTabsBusinessLayer";
        #endregion

        #region public constructors
        public LpBillingTypeTabsBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, DataSet dataSet, string userName)
            : base(messageId, dataRepository, excelWorksheetUtility, logger, dataSet, userName)
        {
            string method = string.Format("LpBillingTypeTabsBusinessLayer(messageId,dataRepository,excelWorksheetUtility,logger,dataSet,userName:{0})", userName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.BEGIN));

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
        public override bool Initialize(string messageId)
        {
            string method = string.Format("{0}.{1}.Initialize(messageId)", NAMESPACE, CLASS);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}",method, Common.BEGIN));

                if (_dataSet != null && _dataSet.Tables != null && _dataSet.Tables.Count > 0 && _dataSet.Tables[0] != null && _dataSet.Tables[0].Rows != null)
                {
                    foreach (DataTable dataTable in _dataSet.Tables)
                    {
                        if (dataTable != null && !string.IsNullOrWhiteSpace(dataTable.TableName))
                        {
                            switch (dataTable.TableName.ToLower().Trim())
                            {
                                case "lp billing type":
                                    ITabBusinessLayer LpBillingTypeTabBusinessLayer = new LpBillingTypeTabBusinessLayer(messageId, _dataRepository, _excelWorksheetUtility, _logger, dataTable, UtilityCompanies);
                                    TabBusinessLayerList.Add(LpBillingTypeTabBusinessLayer);
                                    break;
                            }
                        }

                    }

                    foreach (ITabBusinessLayer tabBusinessLayer in TabBusinessLayerList)
                    {
                        tabBusinessLayer.UtilityCodes = ParsedUtilityCodes;
                    }

                    _logger.LogInfo(messageId, string.Format("{0} return true {1}", method, Common.END));
                    return true;
                }
                _logger.LogInfo(messageId, string.Format("{0} return false {1}", method, Common.END));
                return false;
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