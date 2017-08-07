using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Principal;

namespace Utilities
{
    /// <summary>
    /// Class Common.
    /// </summary>
    public static class Common
    {
        public const string DOWNARROW = @"/Images/sortDescending_arrow.png";
        public const string UPARROW = @"/Images/sortAscending_arrow.png";
        public const string BEGIN = "BEGIN";
        public const string CREATEDBY = "CreatedBy";
        public const string CREATEDDATE = "CreatedDate";
        public const string END = "END";
        public const string ERRORMESSAGE = "ErrorMessage";
        public const string ISPOSTBACK = "IsPostBack";
        public const string MESSAGEID = "MessageId";
        public const string NAMESPACE = "UtilityManagement.Controllers";
        public const string SORTCOLUMNNAME = "SortColumnName";
        public const string SORTDIRECTION = "SortDirection";
        public const string ASC = "Asc";
        public const string DESC = "Desc";

        public static string DataTableGenerateInsertStatements(DataTable dataTable, string tableName)
        {
            StringBuilder stringBuilder = new StringBuilder();

            if (dataTable == null || dataTable.Rows == null || dataTable.Rows.Count == 0 || dataTable.Columns == null || dataTable.Columns.Count == 0)
                return string.Empty;

            foreach (DataRow dataRow in dataTable.Rows)
            {
                if (dataRow != null)
                {
                    stringBuilder.Append(string.Format("INSERT INTO {0} (", tableName));
                    bool isFirstTimeThrough = true;
                    foreach (DataColumn dataColumn in dataTable.Columns)
                    { 
                        if(!isFirstTimeThrough)
                        {
                            stringBuilder.Append(",");
                        }
                        stringBuilder.AppendFormat("[{0}]",dataColumn.ColumnName);
                        isFirstTimeThrough = false;
                    }
                    stringBuilder.Append(") VALUES (");
                    isFirstTimeThrough = true;
                    foreach (DataColumn dataColumn in dataTable.Columns)
                    { 
                        if(!isFirstTimeThrough)
                        {
                            stringBuilder.Append(",");
                        }
                        bool needsQuotes = false;
                        switch(dataColumn.DataType.Name)
                        {
                            case "String":
                                needsQuotes = true;
                                break;
                            case "DateTime":
                                needsQuotes = true;
                                break;
                            case "Guid":
                                needsQuotes = true;
                                break;
                        }
                        if (needsQuotes)
                        {
                            stringBuilder.AppendFormat("'{0}'", Utilities.Common.NullSafeString(dataRow[dataColumn]));
                        }
                        else
                        {
                            stringBuilder.Append(Utilities.Common.NullSafeString(dataRow[dataColumn]));
                        }
                        isFirstTimeThrough = false;
                    }
                    stringBuilder.Append(")");
                }
            }
            return stringBuilder.ToString();
        }

        public static bool IsDataSetRowValid(DataSet dataSet)
        {
            return
                dataSet != null
                && dataSet.Tables != null
                && dataSet.Tables.Count > 0
                && dataSet.Tables[0] != null
                && dataSet.Tables[0].Rows != null
                && dataSet.Tables[0].Rows.Count > 0
                && dataSet.Tables[0].Rows[0] != null;
        }

        /// <summary>
        /// Gets the name of the user.
        /// </summary>
        /// <param name="user">The user.</param>
        /// <returns>System.String.</returns>
        public static string GetUserName(IPrincipal user)
        {
            if (user == null || user.Identity == null || string.IsNullOrWhiteSpace(user.Identity.Name))
                return "NULL USER NAME";

            return user.Identity.Name;
        }

        /// <summary>
        /// Gets the name of the user.
        /// </summary>
        /// <param name="user">The user.</param>
        /// <returns>System.String.</returns>
        public static string GetUserName(object user)
        {
            if (user == null)
                return "NULL USER NAME";

            return user.ToString();
        }

        /// <summary>
        /// Gets the minimum SQL safe date.
        /// </summary>
        /// <returns>DateTime.</returns>
        public static DateTime GetMinimumSqlSafeDate()
        {
            return new DateTime(1753, 1, 1);
        }

        /// <summary>
        /// Nulls the safe date to string.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>System.String.</returns>
        public static string NullSafeDateToString(object value) 
        { 
            string returnValue = "INVALID DATE VALUE";
            DateTime parsedDateTime = DateTime.MinValue;
            if (value != null && DateTime.TryParse(value.ToString(), out parsedDateTime))
                returnValue = string.Format("{0}-{1}-{2} {3}:{4}:{5}.{6}",
                    parsedDateTime.Year.ToString(),
                    parsedDateTime.Month.ToString(),
                    parsedDateTime.Day.ToString(),
                    parsedDateTime.Hour.ToString(),
                    parsedDateTime.Minute.ToString(),
                    parsedDateTime.Second.ToString(),
                    parsedDateTime.Millisecond.ToString());
            return returnValue;
        }

        public static DateTime NullSafeDateTime(object value)
        {
            DateTime returnValue = DateTime.MinValue;
            if (value != null)
                DateTime.TryParse(value.ToString(), out returnValue);
            return returnValue;
        }

        public static DateTime? NullableDateTime(object value)
        {
            if (value == null)
                return null;

            DateTime returnValue = DateTime.MinValue;
            DateTime.TryParse(value.ToString(), out returnValue);
            return returnValue;
        }

        /// <summary>
        /// Nulls the safe string.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>System.String.</returns>
        public static string NullSafeString(object value)
        {
            if (value != null)
                return value.ToString();
            return string.Empty;
        }

        public static decimal NullSafeDecimal(object value)
        {
            decimal returnValue = 0;
            if(value != null && decimal.TryParse(value.ToString(), out returnValue))
                return returnValue;
            return 0;
        }

        public static decimal? NullableDecimal(object value)
        {
            if (value == null)
                return null;
            decimal returnValue = 0;
            if (value != null && decimal.TryParse(value.ToString(), out returnValue))
                return returnValue;
            return 0;
        }

        /// <summary>
        /// Nulls the safe integer.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>System.Int32.</returns>
        public static int NullSafeInteger(object value)
        {
            int returnValue = 0;
            if (value != null && int.TryParse(value.ToString(), out returnValue))
                return returnValue;
            return 0;
        }

        /// <summary>
        /// Nulls the safe integer.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>System.Int32.</returns>
        public static int? NullableInteger(object value)
        {
            if (value == null)
                return null;
            int returnValue = 0;
            if (value != null && int.TryParse(value.ToString(), out returnValue))
                return returnValue;
            return 0;
        }


        /// <summary>
        /// Nulls the safe integer.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>System.Int32.</returns>
        public static bool? NullableBoolean(object value)
        {
            if (value == null)
                return null;
            bool returnValue = false;
            if (bool.TryParse(value.ToString(), out returnValue))
                return returnValue;
            return false;
        }

        /// <summary>
        /// Nulls the safe large integer.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>System.Int32.</returns>
        public static Int64 NullSafeLargeInteger(object value)
        {
            Int64 returnValue = 0;
            if (value != null && Int64.TryParse(value.ToString(), out returnValue))
                return returnValue;
            return 0;
        }

        /// <summary>
        /// Nulls the safe large integer.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>System.Int32.</returns>
        public static Int64? NullableLargeInteger(object value)
        {
            if (value == null)
                return null;
            Int64 returnValue = 0;
            if (value != null && Int64.TryParse(value.ToString(), out returnValue))
                return returnValue;
            return 0;
        }

        /// <summary>
        /// Nulls the safe unique identifier.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>Guid.</returns>
        /// <exception cref="System.ArgumentException">Invalid Value For Guid</exception>
        public static Guid NullSafeGuid(object value)
        {
            if (value != null && !string.IsNullOrEmpty(value.ToString()))
                return Guid.Parse(value.ToString());
            throw new ArgumentException("Invalid Value For Guid");
        }

        /// <summary>
        /// Nulls the save dictionary string string.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>System.String.</returns>
        public static string NullSaveDictionaryStringString(Dictionary<string, string> value)
        {
            if (value == null)
                return "NULL";

            StringBuilder stringBuilder = new StringBuilder();
            bool isFirstIteration = true;
            foreach (string key in value.Keys)
            {
                if (!isFirstIteration)
                    stringBuilder.Append(",");
                stringBuilder.Append(string.Format("{0}:{1}", NullSafeString(key), NullSafeString(value[key])));
                isFirstIteration = false;
            }
            return stringBuilder.ToString();
        }

        /// <summary>
        /// Determines whether [is valid string] [the specified value].
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns><c>true</c> if [is valid string] [the specified value]; otherwise, <c>false</c>.</returns>
        public static bool IsValidString(string value)
        {
            bool returnValue = !string.IsNullOrWhiteSpace(value);
            return returnValue;
        }

        /// <summary>
        /// Determines whether [is valid date] [the specified date time].
        /// </summary>
        /// <param name="dateTime">The date time.</param>
        /// <returns><c>true</c> if [is valid date] [the specified date time]; otherwise, <c>false</c>.</returns>
        public static bool IsValidDate(DateTime dateTime)
        {
            bool returnValue = dateTime != null && dateTime > new DateTime(2001, 1, 1);
            return returnValue;
        }

        /// <summary>
        /// Determines whether [is valid unique identifier] [the specified unique identifier].
        /// </summary>
        /// <param name="guid">The unique identifier.</param>
        /// <returns><c>true</c> if [is valid unique identifier] [the specified unique identifier]; otherwise, <c>false</c>.</returns>
        public static bool IsValidGuid(Guid guid)
        {
            bool returnValue = guid != null && !string.IsNullOrEmpty(guid.ToString()) && Guid.Empty != guid;
            return returnValue;
        }

    }
}
