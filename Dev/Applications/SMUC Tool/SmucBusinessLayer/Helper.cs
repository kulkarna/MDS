using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Web;

namespace SmucBusinessLayer
{
    public static class Helper
    {
        public static DataTable ConvertToDataTable<T>(this IEnumerable<T> collection, string tableName)
        {
            DataTable tbl = ToDataTable(collection);
            tbl.TableName = tableName;
            return tbl;
        }

        public static DataTable ToDataTable<T>(this IEnumerable<T> collection)
        {
            DataTable dtTable = new DataTable();
            Type t = typeof(T);
            PropertyInfo[] piaTable = t.GetProperties();
            //Create the columns in the DataTable
            foreach (PropertyInfo pi in piaTable)
            {
                dtTable.Columns.Add(pi.Name, pi.PropertyType);
            }
            //Populate the table
            foreach (T item in collection)
            {
                DataRow drTable = dtTable.NewRow();
                drTable.BeginEdit();
                foreach (PropertyInfo pi in piaTable)
                {
                    drTable[pi.Name] = pi.GetValue(item, null);
                }
                drTable.EndEdit();
                dtTable.Rows.Add(drTable);
            }
            return dtTable;
        }

       
    }
}