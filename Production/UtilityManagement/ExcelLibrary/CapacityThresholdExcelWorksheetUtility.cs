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
    public class CapacityThresholdExcelWorksheetUtility : ExcelWorksheetUtility
    {

        #region private variables
        const string ExcelConnectionFormat = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=1\";";

        protected const string NAMESPACE = "ExcelLibrary";
        private const string CLASS = "CapacityThresholdExcelWorksheetUtility";
        Aspose.Cells.Workbook _workbook = null;
        Aspose.Cells.License license = new Aspose.Cells.License();
        #endregion
        public CapacityThresholdExcelWorksheetUtility(ILogger _logger, string licensePath)
            : base(_logger, licensePath)
        {


        }


        public override System.Data.DataSet GetDataFromWorksheet(string messageId, string filePathAndName)
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
                        if (dataTableColumnHeader != null && dataTableColumnHeader.Rows != null && dataTableColumnHeader.Rows.Count > 0 && dataTableColumnHeader.Rows[0] != null)
                        {
                            dataTable = worksheet.Cells.ExportDataTableAsString(1, 0, worksheet.Cells.MaxRow, worksheet.Cells.MaxColumn + 1);
                            int columnCounter = 0;
                            foreach (System.Data.DataColumn dataColumn in dataTableColumnHeader.Columns)
                            {
                                if (string.IsNullOrEmpty(dataTableColumnHeader.Rows[0][columnCounter].ToString()))
                                    dataTable.Columns[columnCounter].ColumnName = "Invalid Column";
                                else
                                {
                                    try
                                    {
                                        dataTable.Columns[columnCounter].ColumnName = dataTableColumnHeader.Rows[0][columnCounter].ToString().Trim();
                                    }
                                    catch (DuplicateNameException exception)
                                    {
                                        dataTable.Columns[columnCounter].ColumnName = "Duplicate-"+dataTableColumnHeader.Rows[0][columnCounter].ToString().Trim();
                                    }
                                }
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
    }
}
