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
using UtilityManagementDataMapper;
using UtilityDto;

namespace ExcelBusinessLayer
{
    public class PaymentTermTabBusinessLayer : TabBusinessLayer
    {
        #region private variables
        private string CLASS = "PaymentTermTabBusinessLayer";

        protected const string BUSINESS_ACCOUNT_TYPE = "BusinessAccountType";
        protected const string BILLING_TYPE = "BillingType";
        protected const string MARKET = "Market";
        protected const string PAYMENT_TERM = "PaymentTerm";

        protected const string TAB_NAME = "Payment Term";
        #endregion

        #region public constructors
        public PaymentTermTabBusinessLayer(string messageId, IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger, DataTable dataTable, List<DataAccessLayerEntityFramework.UtilityCompany> utilityCompanies)
            : base(messageId, dataRepository, excelWorksheetUtility, logger, TAB_NAME, utilityCompanies)
        {
            string method = string.Format("{0}.{1}.PaymentTermTabBusinessLayer(messageId,dataRepository,excelWorksheetUtility,logger,dataTable)", NAMESPACE, CLASS);
            try
            {
                _logger = logger;
                _logger.LogInfo(messageId, string.Format("{0} {1}", method, Common.BEGIN));

                Columns.Add(UTILITY_CODE);
                Columns.Add(BUSINESS_ACCOUNT_TYPE);
                Columns.Add(BILLING_TYPE);
                Columns.Add(MARKET);
                Columns.Add(PAYMENT_TERM);
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
                string billingAccountType = Common.NullSafeString(dataRow[BUSINESS_ACCOUNT_TYPE]);
                string billingType = Common.NullSafeString(dataRow[BILLING_TYPE]);
                string market = Common.NullSafeString(dataRow[MARKET]);
                string paymentTerm = Common.NullSafeString(dataRow[PAYMENT_TERM]);
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
                    dref.usp_PaymentTerm_UPDATE(messageId, Guid.NewGuid(), utilityCode, billingAccountType, billingType, market, 
                        paymentTerm, inactive, user);
                    ExcelTabImportSummary.UpdatedRecordCount++;
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, Common.END));
                    return;
                }
                _logger.LogInfo(messageId, string.Format("NAMESPACE:{0}",Common.NullSafeString(NAMESPACE)));
                _logger.LogInfo(messageId, string.Format("CLASS:{0}",Common.NullSafeString(CLASS)));
                _logger.LogInfo(messageId, string.Format("method:{0}",Common.NullSafeString(method)));
                _logger.LogInfo(messageId, string.Format("utilityCode:{0}",Common.NullSafeString(utilityCode)));
                _logger.LogInfo(messageId, string.Format("billingAccountType:{0}", Common.NullSafeString(billingAccountType)));
                _logger.LogInfo(messageId, string.Format("billingType:{0}", Common.NullSafeString(billingType)));
                _logger.LogInfo(messageId, string.Format("market:{0}", Common.NullSafeString(market)));
                _logger.LogInfo(messageId, string.Format("paymentTerm:{0}", Common.NullSafeString(paymentTerm)));
                _logger.LogInfo(messageId, string.Format("inactive:{0}",Common.NullSafeString(inactive)));

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEFORE dref.usp_PaymentTerm_INSERT(messageId, Guid.NewGuid(), utilityCode:{3}, billingAccountType:{4}, billingType:{5}, market:{6}, paymentTerm:{7}, inactive:{8}, user:{9})", 
                    Common.NullSafeString(NAMESPACE), Common.NullSafeString(CLASS), Common.NullSafeString(method), Common.NullSafeString(utilityCode), billingAccountType, billingType, Common.NullSafeString(market), Common.NullSafeDateTime(paymentTerm), inactive, user));
                dref.usp_PaymentTerm_INSERT(messageId, Guid.NewGuid(), utilityCode, billingAccountType, billingType, market, paymentTerm, inactive, user);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} AFTER dref.usp_PaymentTerm_INSERT(messageId, Guid.NewGuid(), utilityCode:{3}, billingAccountType:{4}, billingType:{5}, market:{6}, paymentTerm:{7}, inactive:{8}, user:{9})",
                    NAMESPACE, CLASS, method, utilityCode, billingAccountType, billingType, market, paymentTerm, inactive, user));
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
            string businessAccountType = Common.NullSafeString(dataRow[BUSINESS_ACCOUNT_TYPE]);
            if (dataRow[BUSINESS_ACCOUNT_TYPE] == null ||
                string.IsNullOrWhiteSpace(businessAccountType) || 
                !(businessAccountType.ToLower().Trim() == "residential" ||
                  businessAccountType.ToLower().Trim() == "commercial" ||
                  businessAccountType.ToLower().Trim() == "large commercial industrial" ||
                  businessAccountType.ToLower().Trim() == "small office home office"))
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid BusinessAccountType Value");
                return false;
            }
            string billingType = Common.NullSafeString(dataRow[BILLING_TYPE]);
            if (dataRow[BILLING_TYPE] == null ||
                string.IsNullOrWhiteSpace(billingType) ||
                !(billingType.ToLower().Trim() == "dual" ||
                  billingType.ToLower().Trim() == "bill ready" ||
                  billingType.ToLower().Trim() == "rate ready" ||
                  billingType.ToLower().Trim() == "supplier consolidated"))
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid BillingType Value");
                return false;
            }
            if (dataRow[UTILITY_CODE] == null 
                || string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[UTILITY_CODE])))
            {
                
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Utility Value");
                return false;
            }
            if (dataRow[MARKET] == null || string.IsNullOrWhiteSpace(dataRow[MARKET].ToString()) || dataRow[MARKET].ToString().Trim().Length != 2)
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Market Value");
                return false;
            }
            if (dataRow[PAYMENT_TERM] == null || string.IsNullOrWhiteSpace(dataRow[PAYMENT_TERM].ToString()))
            {
                ExcelTabImportSummary.IncrementInvalidRecordCount(rowCount, "Invalid Payment Term Value");
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

                DataSet dataSet = dal.usp_PaymentTerm_IsDuplicate(messageId, Common.NullSafeString(dataRow[UTILITY_CODE]), Common.NullSafeString(dataRow[BUSINESS_ACCOUNT_TYPE]),
                    Common.NullSafeString(dataRow[BILLING_TYPE]), Common.NullSafeString(dataRow[MARKET]));

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

                DataSet dataSet = dal.usp_PaymentTerm_IsExactDuplicate(messageId, Common.NullSafeString(dataRow[UTILITY_CODE]), Common.NullSafeString(dataRow[BUSINESS_ACCOUNT_TYPE]),
                    Common.NullSafeString(dataRow[BILLING_TYPE]), Common.NullSafeString(dataRow[MARKET]), Common.NullSafeString(dataRow[PAYMENT_TERM]).Replace('/','-'), Common.NullSafeInteger(dataRow[INACTIVE])==1);

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
                    && DoesDataTableHaveColumn(messageId, BUSINESS_ACCOUNT_TYPE)
                    && DoesDataTableHaveColumn(messageId, BILLING_TYPE)
                    && DoesDataTableHaveColumn(messageId, MARKET)
                    && DoesDataTableHaveColumn(messageId, PAYMENT_TERM)
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
                if ((dataColumn.ColumnName == UTILITY_CODE || dataColumn.ColumnName == BUSINESS_ACCOUNT_TYPE || dataColumn.ColumnName == BILLING_TYPE || 
                        dataColumn.ColumnName == MARKET || dataColumn.ColumnName == PAYMENT_TERM || dataColumn.ColumnName == INACTIVE) 
                        && string.IsNullOrWhiteSpace(Common.NullSafeString(dataRow[dataColumn])))
                    return false;
            }
            return true;
        }

        #endregion
    }
}