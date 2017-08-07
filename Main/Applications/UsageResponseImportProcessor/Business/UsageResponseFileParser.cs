using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsageResponseImportProcessor.Help;
using UsageResponseImportProcessor.Entities;
using System.Globalization;

namespace DailyBillingImportProcessor.Business
{
    /// <summary>
    /// Handle the usage response file parsing logic.
    /// </summary>
    public class UsageResponseFileParser : IUsageResponseFileParser
    {
        #region Private Members

        private int index = 1;

        #endregion

        #region Behavior

        /// <summary>
        /// Parse common file to usage response file.
        /// </summary>
        /// <param name="file">Commom file to be parsed.</param>
        /// <returns>Resulting usage response file.</returns>
        public UsageResponseFile Parse(UsageResponseImportProcessor.Transport.File file)
        {
            return new UsageResponseFile
            {
                FileName = file.Name,
                Rows = file.Rows.Select(row => this.Parse(row)).ToList()
            };
        }

        #endregion

        #region Auxilary Methods

        /// <summary>
        /// Parse a single row of the common file to a usage response row.
        /// </summary>
        /// <param name="row">Row of the common file.</param>
        /// <returns>Resulting usage response row.</returns>
        private UsageResponseFileRow Parse(string row)
        {
            var array = row.Split('\t');

            index++;

            return new UsageResponseFileRow
            {
                CUSTOMER_PROSPECT_TKN = array[0],
                CUSTOMER_PROSPECT_ACCOUNT_TKN = array[1],
                TERRITORY_CODE = array[2],
                LDC_ACCOUNT_NUM = array[3],
                STATUS_DESC = array[4],
                CREATE_TSTAMP = array[5],
                TRANS_ID = array[6],
                ORIGINAL_TRANS_ID = array[7],
                TYPE_DESC = array[8],
                REASON_CODE = array[9],
                REASON_DESC = array[10],
                USAGE_TYPE = array[11],
                Index = index,
                Date = this.ToDate(array[5]),
            };
        }

        private DateTime ToDate(string input)
        {
            DateTime date;
            string[] formats = { "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss.f" };
            DateTime.TryParseExact(input, formats, CultureInfo.CurrentCulture, DateTimeStyles.None, out date);

            return date;
        }

        #endregion
    }
}
