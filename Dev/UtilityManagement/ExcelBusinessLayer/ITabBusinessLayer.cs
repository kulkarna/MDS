using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelBusinessLayer
{
    public interface ITabBusinessLayer
    {
        List<string> UtilityCodes { get; set; }
        List<string> ParsedUtilityCodes { get; set; }
        int TabOrder { get; set; }
        ExcelTabImportSummary ExcelTabImportSummary { get; set; }
        List<DataAccessLayerEntityFramework.UtilityCompany> UtilityCompanies { get; set; }


        bool IsExcelTabValid(string messageId);
        bool Populate(string messageId, string userName);
    }
}