using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Office.Interop.Excel;

namespace ExcelLibrary
{
    public interface IExcelWorksheetUtility
    {
        System.Data.DataSet GetDataFromWorksheet(string messageId, string filePathAndName);
        void GenerateAndSaveExcelWorkbook(string messageId, string fileNameAndPath, DataSet dataSet);
    }
}
