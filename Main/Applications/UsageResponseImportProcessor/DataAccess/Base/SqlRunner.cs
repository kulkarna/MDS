using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Dynamic;
using System.Linq;
using System.Reflection;
using System.Web;

namespace UsageResponseImportProcessor.DataAccess.Base
{
    public class SqlRunner : ISqlRunner
    {
        private ISqlConnector connector;

        public SqlRunner(ISqlConnector connector)
        {
            this.connector = connector;
        }

        public IEnumerable<dynamic> ExecuteProcedure(string procedureName, dynamic @params)
        {
            using (var connection = connector.ConnectToLibertyPowerDatabase())
            {
                using (var command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = procedureName;

                    var paramsDict = SqlRunnerExtensions.ToDictionary(@params);
                    foreach (var paramName in paramsDict.Keys)
                        command.Parameters.Add(new SqlParameter(paramName, paramsDict[paramName]));

                    using (var dataAdapter = new SqlDataAdapter(command))
                    {
                        var table = new DataTable();
                        dataAdapter.Fill(table);

                        var result = new List<dynamic>();
                        foreach (DataRow row in table.Rows)
                        {
                            dynamic item = new ExpandoObject();
                            var itemDict = item as IDictionary<string, object>;

                            foreach (DataColumn column in table.Columns)
                                itemDict.Add(column.ColumnName, row.IsNull(column) ? null : row[column]);

                            result.Add(item);
                        }

                        return result;
                    }
                }
            }
        }
    }

    public static class SqlRunnerExtensions
    {
        public static IDictionary<string, object> ToDictionary(Object obj)
        {
            var result = new Dictionary<string, object>();
            foreach (var prop in obj.GetType().GetProperties(BindingFlags.Instance | BindingFlags.Public))
            {
                var key = prop.Name;
                var value = prop.GetValue(obj, null);

                result.Add(key, value);
            }

            return result;
        }

        public static dynamic GetFirstRow(this IEnumerable<dynamic> results)
        {
            if (!results.Any())
                throw new Exception("The results from the SQL command are empty.");

            return results.First();
        }

        public static int GetScalarInt(this IEnumerable<dynamic> results)
        {
            var row = results.GetFirstRow() as IDictionary<string, object>;

            var result = 0;
            if (int.TryParse(row[row.Keys.First()].ToString(), out result))
                return result;
            else
                throw new Exception("The result is not an integer value (result of first column of first row).");
        }
    }
}