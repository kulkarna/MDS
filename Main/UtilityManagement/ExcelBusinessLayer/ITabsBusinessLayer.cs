using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelBusinessLayer
{
    public interface ITabsBusinessLayer
    {
        #region public properties
        List<ITabBusinessLayer> TabBusinessLayerList { get; set; }
        List<string> TabSummaryList { get; set; }
        bool IsExcelFileValidFlag { get; set; }
        List<DataAccessLayerEntityFramework.UtilityCompany> UtilityCompanies { get; set; }
        #endregion

        #region public methods
        bool Initialize(string messageId);
        #endregion
    }
}