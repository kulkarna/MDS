using System;
using System.Data;

namespace UsageFileProcessor.Services
{
    public static class DataSetService
    {
        public static bool IsRowEmpty(DataRow dr, bool ignoreSpaces)
        {
            foreach (var o in dr.ItemArray)
                if (o != DBNull.Value && o.ToString().Trim().Length > 0)
                    return false;

            return true;
        }

        public static bool HasRow(DataSet dataSet)
        {
            return dataSet != null && dataSet.Tables.Count > 0 && dataSet.Tables[0].Rows.Count > 0;
        }

        public static bool HasRow(DataTable dataTable)
        {
            return dataTable != null && dataTable.Rows.Count > 0;
        }

        public static string GetStringValue(Object dataColumn)
        {
            string value = null;

            if (dataColumn != null)
            {
                value = (string)dataColumn;
            }

            return value;
        }

        public static int GetIntValue(Object dataColumn)
        {
            int value = 0;

            if (dataColumn != null)
            {
                value = (int)dataColumn;
            }

            return value;
        }

        public static long GetLongValue(Object dataColumn)
        {
            long value = 0L;

            if (dataColumn != null)
            {
                value = (long)dataColumn;
            }

            return value;
        }

        public static DateTime GetDateTimeValue(Object dataColumn)
        {
            DateTime value = DateTime.MinValue;

            if (dataColumn != null)
            {
                value = (DateTime)dataColumn;
            }

            return value;
        }
    }
}