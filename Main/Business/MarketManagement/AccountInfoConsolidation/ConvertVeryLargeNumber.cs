using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace LibertyPower.Business.MarketManagement.AccountInfoConsolidation
{
    /// <summary>
    /// Helper class to convert very large numbers to their equivalent string values.
    /// </summary>
    public static class ConvertVeryLargeNumber
    {
        #region Methods

        /// <summary>
        /// Converts numbers with scientific notation to its exact string value.
        /// Eg. 9E-31 scientific notation is equivalent to 0.0000000000000000000000000000009.
        /// Eg. 8.8E+30 scientific notation is equivalent to 8800000000000000000000000000000.
        /// </summary>
        /// 
        /// <param name="number">Number to convert</param>
        /// 
        /// <returns>
        /// The exact string value.
        /// </returns>
        public static string ToString(double number)
        {
            string str = number.ToString(System.Globalization.CultureInfo.InvariantCulture);

            if (!str.Contains("E")) return str;

            var positive = true;
            if (number < 0)
            {
                positive = false;
            }

            string separator = Thread.CurrentThread.CurrentCulture.NumberFormat.NumberDecimalSeparator;
            char decimalSeparator = separator.ToCharArray()[0];

            string[] exponentParts = str.Split('E');
            string[] decimalParts = exponentParts[0].Split(decimalSeparator);

            // Fixing missing decimal point
            if (decimalParts.Length == 1)
            {
                decimalParts = new string[]
                {
                    exponentParts[0], "0"
                };
            }

            var exponentValue = int.Parse(exponentParts[1]);

            var newNumber = decimalParts[0].Replace("-", "").
                Replace("+", "") + decimalParts[1];

            string result;

            if (exponentValue > 0) //Positive exponent
            {
                if (positive)
                {
                    result = newNumber + AppendZeros(exponentValue - decimalParts[1].Length);
                }
                else
                {
                    result = "-" + newNumber + AppendZeros(exponentValue - decimalParts[1].Length);
                }
            }
            else //Negative exponent
            {
                if (positive)
                {
                    result = "0" + decimalSeparator +
                                            AppendZeros(exponentValue + decimalParts[0].Replace("-", "").Replace("+", "").Length) + newNumber;
                }

                else
                {
                    result = "-0" + decimalSeparator +
                            AppendZeros(exponentValue + decimalParts[0].Replace("-", "").Replace("+", "").Length) + newNumber;
                }

                result = result.TrimEnd('0');
            }

            var temp = 0.00D;

            if (double.TryParse(result, out temp))
            {
                return result;
            }

            throw new Exception();
        }

        /// <summary>
        /// Builds a string value with <paramref name="zeroCount"/> parameter's amounts of zeros.
        /// </summary>
        /// 
        /// <param name="zeroCount">Number of zeros</param>
        /// 
        /// <returns>A string value with <paramref name="zeroCount"/> parameter's amounts of zeros
        private static string AppendZeros(int zeroCount)
        {
            if (zeroCount < 0)
            {
                zeroCount = Math.Abs(zeroCount);
            }

            var sb = new StringBuilder();

            for (int i = 0; i < zeroCount; i++)
            {
                sb.Append("0");
            }

            return sb.ToString();
        }

        #endregion
    }
}