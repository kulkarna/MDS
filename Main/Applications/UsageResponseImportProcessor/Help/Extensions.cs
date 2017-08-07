using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;

namespace UsageResponseImportProcessor.Help
{
    /// <summary>
    /// Extensions of the solution.
    /// </summary>
    public static class Extensions
    {
        /// <summary>
        /// Return the Description attribute of the enumerator.
        /// </summary>
        /// <param name="arg">Enumerator value.</param>
        /// <returns> Description attribute. </returns>
        public static string GetDescription(this IConvertible arg)
        {
            return ((DescriptionAttribute)arg.GetType().GetField(arg.ToString()).GetCustomAttributes(false)[0]).Description;
        }

        /// <summary>
        /// Return true if the format match with input format and false if doesn't match.
        /// </summary>
        /// <param name="input">Input to be verified.</param>
        /// <param name="format">Format to match the input.</param>
        /// <returns> true if the input match the patter, otherwise, false. </returns>
        public static bool ValidatePattern(this string input, string pattern)
        {
            if (string.IsNullOrEmpty(pattern)) return true;
            else if (!string.IsNullOrEmpty(pattern) && string.IsNullOrEmpty(input)) return false;
            else
            {
                Regex rgx = new Regex(pattern);

                return rgx.IsMatch(input);
            }
        }

        /// <summary>
        /// Return true if the dataset has something, otherwise return false.
        /// </summary>
        /// <param name="ds">Dataset to be verified.</param>
        /// <returns> true if the dataset is fulfilled, otherwise, false. </returns>
        public static bool IsFilled(this DataSet ds)
        {
            return ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0;
        }

        /// <summary>
        /// Convert an object to int.
        /// </summary>
        /// <param name="obj"> object to be converted. </param>
        /// <returns> Object converted. </returns>
        public static int ToInt(this object obj)
        {
            if (obj == null) return 0;

            int aux;
            if (int.TryParse(obj.ToString(), out aux))
                return aux;
            else
                return 0;
        }

        /// <summary>
        /// Convert an object to Datetime.
        /// </summary>
        /// <param name="obj"> object to be converted. </param>
        /// <returns> Converted date. </returns>
        public static DateTime? ToNullableDate(this object obj)
        {
            if (obj == null)
                return null;

            DateTime aux;
                if (DateTime.TryParse(obj.ToString(), out aux))
                return aux;
            else
                return null;
        }

        /// <summary>
        /// Converts an object to a non-nullable date/time.
        /// </summary>
        /// <param name="obj">The object to be converted.</param>
        /// <returns>The resulting date/time.</returns>
        public static DateTime ToNonNullableDate(this object obj)
        {
            var result = obj.ToNullableDate();

            if (result == null)
                return DateTime.MinValue;

            return result.Value;
        }

        /// <summary>
        /// Converts the data row collection into an enumerable fo rows.
        /// </summary>
        /// <param name="rows">The source data row collection.</param>
        /// <returns>The resulting enumerable.</returns>
        public static IEnumerable<DataRow> ToEnumerable(this DataRowCollection rows)
        {
            IList<DataRow> result = new List<DataRow>();

            for (var i = 0; i < rows.Count; i++)
                result.Add(rows[i]);

            return result.AsEnumerable();
        }

        /// <summary>
        /// Convert an DateTime? to DateTime.
        /// </summary>
        /// <param name="data"> nullable datetime to be converted. </param>
        /// <returns> Converted date. </returns>
        public static DateTime ToDate(this DateTime? data)
        {
            return data == null ? DateTime.MinValue : Convert.ToDateTime(data);
        }
    }
}