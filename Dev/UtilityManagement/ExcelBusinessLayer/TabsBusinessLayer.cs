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
    public class TabsBusinessLayer : ITabsBusinessLayer
    {
        #region protected variables
        protected ILogger _logger = null;
        protected IDataRepository _dataRepository = null;
        protected IExcelWorksheetUtility _excelWorksheetUtility = null;
        protected string NAMESPACE = "ExcelBusinessLayer";
        private const string CLASS = "BusinessLayer";
        protected DataSet _dataSet = null;
        #endregion

        #region public properties
        public List<ITabBusinessLayer> TabBusinessLayerList { get; set; }
        public List<string> TabSummaryList { get; set; }
        public List<string> TabSummaryWithRowNumbersList { get; set; }
        public bool IsExcelFileValidFlag { get; set; }
        public List<DataAccessLayerEntityFramework.UtilityCompany> UtilityCompanies { get; set; }
        public List<string> UtilityCodes { get; set; }
        public List<string> ParsedUtilityCodes { get; set; }
        public List<DataAccessLayerEntityFramework.CustomerAccountType> CustomerAccountTypes { get; set; }
        public List<string> CustomerAccountCodes { get; set; }
        public List<string> ParsedCustomerAccountTypes { get; set; }
        #endregion

        #region public constructors
        public TabsBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, DataSet dataSet, string userName)
        {
            _logger = logger;
            string method = string.Format("{0}.{1}.TabsBusinessLayer(messageId,dataRepository,excelWorksheetUtility,logger,dataSet,userName:{2})", NAMESPACE, CLASS, Common.NullSafeString(userName));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                // initialize variables
                TabBusinessLayerList = new List<ITabBusinessLayer>();
                _dataRepository = dataRepository;
                _excelWorksheetUtility = excelWorksheetUtility;
                _dataSet = dataSet;
                TabSummaryList = new List<string>();
                TabSummaryWithRowNumbersList = new List<string>();
                IsExcelFileValidFlag = false;

                ParsedUtilityCodes = new List<string>();
                UtilityCompanies = _dataRepository.UtilityCompanies;
                UtilityCodes = _dataRepository.UtilityCompanies.Where(x => x.Inactive == false).Select(x => x.UtilityCode).ToList<string>();

                foreach (string utilityCode in UtilityCodes)
                {
                    ParsedUtilityCodes.Add(utilityCode.ToLower().Trim());
                }

                ParsedCustomerAccountTypes = new List<string>();
                CustomerAccountTypes = _dataRepository.CustomerAccountTypes;
                CustomerAccountCodes = _dataRepository.CustomerAccountTypes.Where(x => x.Inactive == false).Select(x => x.AccountType).ToList<string>();

                foreach (string AccountCodes in CustomerAccountCodes)
                {
                    ParsedCustomerAccountTypes.Add(AccountCodes.ToLower().Trim());
                }

                if (Initialize(messageId) && IsExcelFileValid(messageId))
                {
                    Populate(messageId, userName);
                }
                else
                {
                    Populate(messageId, userName,false);
                    TabSummaryList.Add("Invalid Excel File--No Records Imported");
                    
                }

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
        public virtual bool Initialize(string messageId)
        {
            throw new NotImplementedException();
        }
        #endregion

        #region private methods
        private bool IsExcelFileValid(string messageId)
        {
            string method = string.Format("{0}.{1}.IsExcelFileValid(messageId)", NAMESPACE, CLASS);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                if (TabBusinessLayerList == null || TabBusinessLayerList.Count == 0)
                {
                    IsExcelFileValidFlag = false;
                    _logger.LogInfo(messageId, string.Format("{0} return false {1}", method, Common.END));
                    return false;
                }

                foreach (TabBusinessLayer tabBusinessLayer in TabBusinessLayerList)
                {
                    if (!tabBusinessLayer.IsExcelTabValid(messageId))
                    {
                        IsExcelFileValidFlag = false;
                        _logger.LogInfo(messageId, string.Format("{0} return false {1}", method, Common.END));
                        return false;
                    }
                }

                IsExcelFileValidFlag = true;
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

        private bool Populate(string messageId, string userName)
        {
            string method = string.Format("{0}.{1}.Populate(messageId,userName:{2})", NAMESPACE, CLASS, userName);
            bool IsPopulate = false;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                userName = string.Format("{0}--Excel Import", userName);

                for (int tabOrder = 1; tabOrder <= 3; tabOrder++)
                {
                    foreach (ITabBusinessLayer tabBusinessLayer in TabBusinessLayerList)
                    {
                        if (tabBusinessLayer != null && tabBusinessLayer.TabOrder == tabOrder)
                        {
                           IsPopulate= tabBusinessLayer.Populate(messageId, userName);
                            if(IsPopulate)
                               TabSummaryList.Add(tabBusinessLayer.ExcelTabImportSummary.ToString());
                            else
                               TabSummaryList.Add("Invalid Excel File--No Records Imported");   
                            TabSummaryWithRowNumbersList.Add(tabBusinessLayer.ExcelTabImportSummary.GetSummaryWithRowNumbers());
                        }
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
        private  bool Populate(string messageId, string userName,bool uploadStatus)
        {
            string method = string.Format("{0}.{1}.Populate(messageId,userName:{2})", NAMESPACE, CLASS, userName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                userName = string.Format("{0}--Excel Import", userName);

                for (int tabOrder = 1; tabOrder <= 3; tabOrder++)
                {
                    foreach (ITabBusinessLayer tabBusinessLayer in TabBusinessLayerList)
                    {
                        if (tabBusinessLayer != null && tabBusinessLayer.TabOrder == tabOrder)
                        {
                            TabSummaryWithRowNumbersList.Add(tabBusinessLayer.ExcelTabImportSummary.GetSummaryWithRowNumbers());
                        }
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
    }
}