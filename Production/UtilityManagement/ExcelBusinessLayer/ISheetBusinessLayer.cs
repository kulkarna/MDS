using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
//using GemBox.Spreadsheet;

namespace ExcelBusinessLayer
{
    public interface ISheetBusinessLayer
    {
        bool SaveFromDatabaseToExcel(string messageId, string utilityCode, string filePathAndName);
        bool SaveAllFromDatabaseToExcel(string messageId, string filePathAndName);
        bool UploadFromExcelToDatabase(string messageId, string utilityCode, string filePathAndName, string userName);
        
    }
}