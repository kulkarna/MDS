using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace ExcelBusinessLayer
{
    public class ExcelTabImportSummary
    {
        public string TabName { get; set; }
        public int InsertedRecordCount { get; set; }
        public int UpdatedRecordCount { get; set; }
        public int DuplicateRecordCount { get; set; }
        public int InvalidRecordCount { get; set; }
        public List<string> InvalidRowList { get; set; }

        public ExcelTabImportSummary(string tabName)
        {
            TabName = tabName;
            InsertedRecordCount = 0;
            UpdatedRecordCount = 0;
            DuplicateRecordCount = 0;
            InvalidRecordCount = 0;
            InvalidRowList = new List<string>();
        }

        public void IncrementInvalidRecordCount(int rowNumber, string code)
        {
            InvalidRecordCount++;
            string result = (rowNumber + 1).ToString();
            if (!string.IsNullOrWhiteSpace(code))
            {
                result += ":" + code;
            }
            InvalidRowList.Add(result);
        }

        public void IncrementInvalidRecordCount(int rowNumber)
        {
            InvalidRecordCount++;
            string result = (rowNumber + 1).ToString();
            InvalidRowList.Add(result);
        }

        public void ProcessCount(DataSet dataSet, int rowCount)
        {
            if (Common.IsDataSetRowValid(dataSet))
            {
                if (dataSet.Tables[0].Rows[0]["Result"] != null && !string.IsNullOrWhiteSpace(dataSet.Tables[0].Rows[0]["Result"].ToString()))
                {
                    int result = Common.NullSafeInteger(dataSet.Tables[0].Rows[0]["Result"]);
                    switch (result)
                    {
                        case 0:
                            InvalidRowList.Add((rowCount+1).ToString());
                            InvalidRecordCount++;
                            break;
                        case 1:
                            InsertedRecordCount++;
                            break;
                        case 2:
                            UpdatedRecordCount++;
                            break;
                        case 3:
                            DuplicateRecordCount++;
                            break;
                        case 4:
                            InvalidRowList.Add((rowCount + 1).ToString());
                            InvalidRecordCount++;
                            break;
                    }
                }
            }
        }

        public virtual string GetSummaryWithRowNumbers()
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
                returnValue = string.Format("Tab {0}: {1} Inserted Records; {2} Updated Records; {3} Previously Imported Records; {4} Invalid Records -- Row Numbers:{5}",
                    TabName, InsertedRecordCount, UpdatedRecordCount, DuplicateRecordCount, InvalidRecordCount, rowNumberList.ToString());
            }
            else
            {
                returnValue = string.Format("Tab {0}: {1} Inserted Records; {2} Updated Records; {3} Previously Imported Records; {4} Invalid Records.  ",
                TabName, InsertedRecordCount, UpdatedRecordCount, DuplicateRecordCount, InvalidRecordCount);
            }

            return returnValue;
        }

        public override string ToString()
        {
            string returnValue = string.Format("Tab {0}: {1} Inserted Records; {2} Updated Records; {3} Previously Imported Records; {4} Invalid Records.  ",
                TabName, InsertedRecordCount, UpdatedRecordCount, DuplicateRecordCount, InvalidRecordCount);

            return returnValue;
        }
    }
}