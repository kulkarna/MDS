using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GemBox.Spreadsheet;

namespace ExcelBusinessLayer
{
    public interface IBusinessLayer
    {
        bool SaveFromDatabaseToExcel(string messageId, string utilityCode, string filePathAndName);
        bool UploadFromExcelToDatabase(string messageId, string utilityCode, string filePathAndName);
    }
}