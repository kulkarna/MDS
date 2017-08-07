using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelBusinessLayer
{
    public class ExcelWorksheetImportSummary
    {
        public List<ExcelTabImportSummary> ExcelTabImportSummaryList { get; set; }

        public override string ToString()
        {
            StringBuilder returnValue = new StringBuilder();
            returnValue.AppendLine("Excel Worksheet Import Summary: ");
            foreach (ExcelTabImportSummary excelTabImportSummary in ExcelTabImportSummaryList)
            {
                returnValue.AppendLine(excelTabImportSummary.ToString());
            }
            return returnValue.ToString();
        }
    }
}