using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CrmServiceAccountUpdater
{
    /// <summary>
    /// Extension helper methods to work with Sql data reader.
    /// </summary>
    public static class SqlDataReaderExtension
    {
        #region Methods

        /// <summary>
        /// Gets the value of the table column.
        /// </summary>
        /// 
        /// <typeparam name="T">Type of the object to get</typeparam>
        /// 
        /// <param name="reader">The SQL data reader</param>
        /// <param name="columnName">The database column name</param>
        /// 
        /// <returns>The type of the column, null if the column is a <see cref="DBNull"/> value</returns>
        public static T? GetValue<T>(this SqlDataReader reader, string columnName) where T : struct
        {
            if (reader[columnName] == DBNull.Value)
                return null;

            return reader[columnName] as T?;
        }

        /// <summary>
        /// Get the string value of the table column.
        /// </summary>
        /// 
        /// <param name="reader">The SQL data reader</param>
        /// <param name="columnName">The database column name</param>
        /// 
        /// <returns>The string value of the column, empty string otherwise</returns>
        public static string GetText(this SqlDataReader reader, string columnName)
        {
            if (reader[columnName] == DBNull.Value)
                return string.Empty;

            return reader[columnName].ToString() ?? string.Empty;
        }

        #endregion
    }
}