namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Text;

    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.DataAccess.SqlAccess.CommonSql;
    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    public static class UtilityStandInFactory
    {
        #region Methods

        /// <summary>
        /// Gets a dictionary of all active utilities as utilitystandin objects.
        /// </summary>
        /// <returns>The generic dictionary collection of all active utilities.</returns>
        public static UtilityDictionary GetUtilities()
        {
            ParserSchemaDictionary allParserSchemas = ParserSchemaFactory.GetParserSchemas();

            UtilityDictionary utilities = null; // the return value

            using (DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.UtilitySql.GetUtilities())
            {
                utilities = UtilityStandInFactory.GetUtilities(ds, allParserSchemas);
            }

            return utilities;
        }

        /// <summary>
        /// Gets a dictionary of all active utilities as utilitystarter objects.
        /// </summary>
        /// <param name="dataSet">The list of active utilities.</param>
        /// <returns>A dictionary of all active utilities.</returns>
        private static UtilityDictionary GetUtilities(DataSet dataSet, ParserSchemaDictionary allParserSchemas)
        {
            UtilityDictionary utilities = null;

            if (dataSet != null && dataSet.Tables.Count > 0 && dataSet.Tables[0].Rows.Count > 0)
            {
                utilities = new UtilityDictionary();

                foreach (DataRow dataRow in dataSet.Tables[0].Rows)
                {
                    UtilityStandIn utility = (UtilityStandIn)GetUtility(dataRow);
                    if (allParserSchemas.ContainsKey(utility.Code))
                        utility.Schema = allParserSchemas[utility.Code];
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
        private static Utility GetUtility(DataRow dr)
        {
            Utility utility = null;

            if (dr != null)
            {
                string code = (string)dr["UtilityCode"];

                int accountNumberLength = (int)dr["AccountLength"];
                string accountNumberPrefix = (string)dr["AccountNumberPrefix"];

                utility = new UtilityStandIn(code, accountNumberPrefix, accountNumberLength);
                utility.FullName = code;
                utility.RetailMarketCode = (string)dr["RetailMarketCode"];
                utility.Description = (string)dr["UtilityDescription"];
                utility.DunsNumber = (string)dr["DunsNumber"];
                utility.CompanyEntityCode = (string)dr["CompanyEntityCode"];
                utility.DateCreated = (DateTime)dr["DateCreated"];
                utility.CreatedBy = (string)dr["CreatedBy"];
            }
            return utility;
        }

        #endregion Methods
        
    }
}