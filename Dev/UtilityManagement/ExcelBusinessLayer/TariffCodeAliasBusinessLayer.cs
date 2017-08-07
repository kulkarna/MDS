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
    public class TariffCodeAliasBusinessLayer : BusinessLayer
    {
        #region private variables
        private const string CLASS = "TariffCodeAliasBusinessLayer";
        #endregion

        #region public constructors
        public TariffCodeAliasBusinessLayer(IDataRepository dataRepository, IExcelWorksheetUtility excelWorksheetUtility, ILogger logger)
            : base(dataRepository, excelWorksheetUtility, logger)
        {
        }
        #endregion

        #region public method
        public override bool SaveFromDatabaseToExcel(string messageId, string utilityCode, string filePathAndName)
        {
            string method = string.Format("SaveFromDatabaseToExcel(messageId,utilityCode:{0},filePathAndName:{1})", utilityCode, filePathAndName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = _repository.usp_TariffCodeAlias_GetByUtilityCode(messageId, utilityCode);
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

        internal override void InsertDataRow(string messageId, DataRow dataRow)
        {
            string method = string.Format("InsertDataRow(messageId,dataRow:{0})", dataRow);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                string utilityCode = Utilities.Common.NullSafeString(dataRow["UtilityCode"]);
                int tariffCodeId = Utilities.Common.NullSafeInteger(dataRow["TariffCodeId"]);
                string tariffCodeCodeAlias = Utilities.Common.NullSafeString(dataRow["TariffCodeCodeAlias"]);
                string user = string.Format("TariffCodeAliasBusinessLayer.UploadFromExcelToDatabase_{0}", messageId);
                string id = Guid.NewGuid().ToString();
                _repository.usp_TariffCodeAlias_INSERT(messageId, id, utilityCode, tariffCodeId, tariffCodeCodeAlias, user);

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