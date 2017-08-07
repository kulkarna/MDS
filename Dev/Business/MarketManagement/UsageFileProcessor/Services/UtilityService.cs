using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using UsageFileProcessor.Entities;

namespace UsageFileProcessor.Services
{
    public static class UtilityService
    {
        /// <summary>
        /// Given an account number, we will check to see if we can determine the utility, or at least narrow the message
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilities"></param>
        /// <returns></returns>
        public static UtilityList GetAllUtilitiesMatchingAccountNumber(string accountNumber, UtilityDictionary utilities)
        {
            UtilityList candidates = null;

            foreach (KeyValuePair<string, Utility> item in utilities)
            {
                Utility util = item.Value;

                if (util.AccountNumberLength == accountNumber.Length)
                    if (accountNumber.StartsWith(util.AccountNumberPrefix))
                    {
                        if (candidates == null)
                            candidates = new UtilityList();
                        candidates.Add(item.Value);
                    }
            }

            return candidates;
        }

        /// <summary>
        /// Given an account number, we will check to see if we can determine the utility, or at least narrow the message
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilities"></param>
        /// <returns></returns>
        public static UtilityList GetTexasUtilitiesMatchingAccountNumber(string accountNumber, UtilityDictionary utilities)
        {
            UtilityList candidates = null;

            foreach (KeyValuePair<string, Utility> item in utilities)
            {
                Utility util = item.Value;

                if (util.RetailMarketCode == "TX")
                    if (util.AccountNumberLength == accountNumber.Length)
                        if (accountNumber.StartsWith(util.AccountNumberPrefix))
                        {
                            if (candidates == null)
                                candidates = new UtilityList();
                            candidates.Add(item.Value);
                        }
            }

            return candidates;
        }

        /// <summary>
        /// Get utility by utility code
        /// </summary>
        /// <param name="utilityCode"></param>
        /// <param name="utilities"></param>
        /// <returns></returns>
        public static UtilityList GetUtilitiesMatchingUtilityCode(string utilityCode, UtilityDictionary utilities)
        {
            var candidates = new UtilityList();
            candidates.AddRange((from item in utilities
                                 let util = item.Value
                                 where util.Code.Equals(utilityCode, StringComparison.InvariantCultureIgnoreCase)
                                 select item).Select(item => item.Value));

            return candidates;
        }

        /// <summary>
        /// Given an account number, we will check to see if we can determine the utility by best match
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilities"></param>
        /// <returns></returns>
        public static Utility GetTexasUtilitiesBestMatchingAccountNumber(string accountNumber, UtilityDictionary utilities)
        {
            Utility candidate = null;

            foreach (KeyValuePair<string, Utility> item in utilities)
            {
                Utility util = item.Value;
                var matchScore = 0;
                if (util.RetailMarketCode == "TX")
                    if (util.AccountNumberLength == accountNumber.Length)
                        if (accountNumber.StartsWith(util.AccountNumberPrefix))
                        {
                            if (util.AccountNumberPrefix.Length > matchScore)
                            {
                                matchScore = util.AccountNumberPrefix.Length;
                                candidate = item.Value;
                            }
                        }
            }

            return candidate;
        }

        /// <summary>
        /// Gets a dictionary of all active utilities as utilitystandin objects.
        /// </summary>
        /// <returns>The generic dictionary collection of all active utilities.</returns>
        public static UtilityDictionary GetUtilities()
        {
      
            UtilityDictionary utilities = null; // the return value

            using (DataSet ds = UtilitySql.GetUtilities())
            {
                utilities = GetUtilities(ds);
            }

            return utilities;
        }

        /// <summary>
        /// Gets a dictionary of all active utilities as utilitystarter objects.
        /// </summary>
        /// <param name="dataSet">The list of active utilities.</param>
        /// <returns>A dictionary of all active utilities.</returns>
        internal static UtilityDictionary GetUtilities(DataSet dataSet)
        {
            UtilityDictionary utilities = null;

            if (dataSet != null && dataSet.Tables.Count > 0 && dataSet.Tables[0].Rows.Count > 0)
            {
                utilities = new UtilityDictionary();

                foreach (DataRow dataRow in dataSet.Tables[0].Rows)
                {
                    var utility = (ParserUtility)GetUtility(dataRow);
                   
                    if (utilities.ContainsKey(utility.Code) == false)
                        utilities.Add(utility.Code, utility);
                }
            }

            return utilities;
        }

        /// <summary>
        /// Extracts a single Utility instance out of a data row.
        /// </summary>
        /// <param name="dr">The data row containing the utility values.</param>
        /// <returns>A single Utility instance represented by the given data row.</returns>
        internal static Utility GetUtility(DataRow dr)
        {
            Utility utility = null;

            if (dr != null)
            {
                var code = (string)dr["UtilityCode"];

                var accountNumberLength = (int)dr["AccountLength"];
                var accountNumberPrefix = (string)dr["AccountNumberPrefix"];

                utility = new ParserUtility(code, accountNumberPrefix, accountNumberLength)
                    {
                        FullName = code,
                        RetailMarketCode = (string) dr["RetailMarketCode"],
                        Description = (string) dr["UtilityDescription"],
                        DunsNumber = (string) dr["DunsNumber"],
                        CompanyEntityCode = (string) dr["CompanyEntityCode"],
                        DateCreated = (DateTime) dr["DateCreated"],
                        CreatedBy = (string) dr["CreatedBy"]
                    };
            }
            return utility;
        }


        internal static ParserSchema CreateParserSchema(string utilityCode, List<ParserColumn> parserColumns)
        {
            if (utilityCode.Trim().Length == 0)
                throw new ApplicationException("UtilityCode not specified");

            if (utilityCode.Trim().Length > 50)
                throw new ApplicationException("UtilityCode specified exceeds maximum length of 50 characters");

            var parserSchema = new ParserSchema(utilityCode, parserColumns);

            return parserSchema;
        }


        private static string[] GetDistinctValues(DataTable dt, string columnName)
        {
            if (dt == null || dt.Columns.Contains(columnName) == false)
                throw new ApplicationException("Column not found in DataTable");

            List<string> fields = new List<string>();
            foreach (DataRow row in dt.Rows)
            {
                if (fields.Contains(row[columnName].ToString()) == false)
                {
                    fields.Add(row[columnName].ToString());
                }
            }
            return fields.ToArray();
        }
    }
}