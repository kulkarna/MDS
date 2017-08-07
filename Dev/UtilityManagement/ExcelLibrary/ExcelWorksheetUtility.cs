using Microsoft.Office.Interop.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;
using UtilityLogging;
using Aspose.Cells;

namespace ExcelLibrary
{
    public class ExcelWorksheetUtility : IExcelWorksheetUtility
    {

        #region private variables
        const string ExcelConnectionFormat = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=1\";";
        protected ILogger _logger = null;
        protected const string NAMESPACE = "ExcelLibrary";
        private const string CLASS = "ExcelWorksheetUtility";
        Aspose.Cells.Workbook _workbook = null;
        Aspose.Cells.License license = new Aspose.Cells.License();
        #endregion


        #region public constructors
        public ExcelWorksheetUtility(ILogger logger, string licensePath)
        {
            license.SetLicense(licensePath);
            _workbook = new Aspose.Cells.Workbook();
            _logger = logger;
        }
        #endregion


        #region public methods
        public void GenerateAndSaveExcelWorkbook(string messageId, string fileNameAndPath, DataSet dataSet)
        {
            string method = string.Format("GenerateAndSaveExcelWorkbook(messageId,fileNameAndPath:{0},dataSet)", fileNameAndPath);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                GenerateWithDataSet(messageId, dataSet);
                _logger.LogDebug(messageId, string.Format("GenerateWithDataSet(messageId, dataSet:{0})", Utilities.Common.NullSafeString(dataSet)));
                SaveWorkbook(messageId, fileNameAndPath);
                _logger.LogDebug("D");
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public virtual System.Data.DataSet GetDataFromWorksheet(string messageId, string filePathAndName)
        {
            string method = string.Format("GetDataFromWorksheet(messageId,filePathAndName:{0})", filePathAndName);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                _workbook = new Aspose.Cells.Workbook(filePathAndName);
                System.Data.DataSet returnValue = new System.Data.DataSet();
                System.IO.FileStream fileStream = new System.IO.FileStream(filePathAndName, System.IO.FileMode.Open);
                foreach (Aspose.Cells.Worksheet worksheet in _workbook.Worksheets)
                {
                    if (worksheet.Cells.MaxRow > 0)
                    {
                        System.Data.DataTable dataTableColumnHeader = worksheet.Cells.ExportDataTable(0, 0, worksheet.Cells.MaxRow + 1, worksheet.Cells.MaxColumn + 1);
                        System.Data.DataTable dataTable = new System.Data.DataTable();
                        string s = string.Empty;
                        for (int i = 0; i < dataTableColumnHeader.Columns.Count; i++)
                        {
                            dataTable.Columns.Add(dataTableColumnHeader.Columns[i].ColumnName, s.GetType());
                        }
                        if (dataTableColumnHeader != null && dataTableColumnHeader.Rows != null && dataTableColumnHeader.Rows.Count > 0 && dataTableColumnHeader.Rows[0] != null && dataTableColumnHeader.Rows[0][0] != null && dataTableColumnHeader.Rows[0][0].ToString() != "")
                        {
                            dataTable = worksheet.Cells.ExportDataTableAsString(1, 0, worksheet.Cells.MaxRow, worksheet.Cells.MaxColumn + 1);
                            int columnCounter = 0;
                            foreach (System.Data.DataColumn dataColumn in dataTableColumnHeader.Columns)
                            {
                                dataTable.Columns[columnCounter].ColumnName = dataTableColumnHeader.Rows[0][columnCounter].ToString();
                                columnCounter++;
                            }
                            dataTable.TableName = worksheet.Name;
                            returnValue.Tables.Add(dataTable);
                        }
                    }
                }
                fileStream.Close();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dt END", NAMESPACE, CLASS, method));
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

        #region private methods
        private void GenerateWithDataSet(string messageId, DataSet dataSet)
        {
            string method = "GenerateWithDataSet(messageId,dataSet)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                int dataTableCounter = 0;
                if (dataSet != null && dataSet.Tables != null && dataSet.Tables.Count > 0 && dataSet.Tables[0] != null)
                {
                    foreach (System.Data.DataTable dataTable in dataSet.Tables)
                    {
                        if (dataTable != null && dataTable.TableName != "Table One" && dataTable.TableName != "Table Two" && dataTable.TableName != "Table Three")
                        {
                            GenerateAsposeWorksheetFromDataTable(messageId, dataTable, dataTableCounter);
                            dataTableCounter++;
                        }
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return _excelFile END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private void SaveWorkbook(string messageId, string fileName)
        {
            string method = string.Format("SaveWorkbook(messageId,fileName:{0})", Utilities.Common.NullSafeString(fileName));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                _logger.LogDebug(messageId, "A");
                _logger.LogDebug(messageId, string.Format("_workbook is null = {0}; fileName:{1}", _workbook == null, fileName));

                System.IO.FileStream fileStream = new System.IO.FileStream(fileName, System.IO.FileMode.Create);
                _workbook.Save(fileStream, SaveFormat.Xlsx);
                fileStream.Close();
                _logger.LogDebug(messageId, "B");

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                _logger.LogDebug(messageId, "C");
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} a ERROR:{3} {4}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc.StackTrace));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private Aspose.Cells.Worksheet GenerateAsposeWorksheetFromDataTable(string messageId, System.Data.DataTable dataTable, int tableCounter)
        {
            string method = "GenerateAsposeWorksheetFromDataTable(messageId,dataTable)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                _workbook.Worksheets.Add();
                Aspose.Cells.Worksheet worksheet = _workbook.Worksheets[tableCounter];
                worksheet.Cells.ImportDataTable(dataTable, false, "A2");
                worksheet.Name = dataTable.TableName;
                for (int i = 0; i < worksheet.Cells.MaxColumn + 1; i++)
                {
                    worksheet.Cells.Rows[0][i].Value = dataTable.Columns[i].ColumnName;
                    if (dataTable.Columns[i].ColumnName.Contains("Date"))
                    {
                        int rowCounterDateTime = 1;
                        foreach (DataRow dataRow in dataTable.Rows)
                        {
                            Aspose.Cells.Style style = worksheet.Cells.Rows[rowCounterDateTime][i].GetStyle();
                            style.Number = 14;
                            worksheet.Cells.Rows[rowCounterDateTime][i].SetStyle(style);
                            rowCounterDateTime++;
                        }
                    }
                    Aspose.Cells.Style styleDate = worksheet.Cells.Rows[0][i].GetStyle();
                    styleDate.Pattern = Aspose.Cells.BackgroundType.Gray50;
                    styleDate.Pattern = Aspose.Cells.BackgroundType.Gray50;
                    styleDate.ForegroundColor = System.Drawing.Color.Gray;
                    worksheet.Cells.Rows[0][i].SetStyle(styleDate);
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return excelWorksheet END", NAMESPACE, CLASS, method));
                return worksheet;
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