using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelBusinessLayer
{
   public  class ExcelTabImportSummaryCapacityThreshold:ExcelTabImportSummary
   
   {
       public ExcelTabImportSummaryCapacityThreshold(string tabName): base(tabName)
       {
         
       }
       public override string ToString()
       {
           string returnValue = string.Format("Tab {0}: {1} Inserted Records; {2} Updated Records.  ",
               TabName, InsertedRecordCount, UpdatedRecordCount + DuplicateRecordCount);

           return returnValue;
       }
       
       public override string GetSummaryWithRowNumbers()
       {
           bool isFirstTimeThrough = true;
           StringBuilder rowNumberList = new StringBuilder();
           string returnValue = string.Empty;

           if (InvalidRowList != null && InvalidRowList.Count > 0)
           {
               foreach (string rowNumber in InvalidRowList)
               {
                   if (!isFirstTimeThrough)
                   {
                       rowNumberList.Append(", ");
                   }
                   rowNumberList.Append(rowNumber);
                   isFirstTimeThrough = false;
               }
           }

           if (!string.IsNullOrWhiteSpace(rowNumberList.ToString()))
           {
               returnValue = string.Format("Tab {0}: {1} Inserted Records; {2} Updated Records; -- Row Number:{3}",
                   TabName, InsertedRecordCount, UpdatedRecordCount  + DuplicateRecordCount, rowNumberList.ToString());
           }
           else
           {
               returnValue = string.Format("Tab {0}: {1} Inserted Records; {2} Updated Records.  ",
               TabName, InsertedRecordCount, UpdatedRecordCount + DuplicateRecordCount );
           }

           return returnValue;
       }
    }
}
