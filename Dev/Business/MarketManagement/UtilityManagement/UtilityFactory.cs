using System;
using System.Collections.Generic;
using System.Data;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using lp = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using System.Linq;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using System.Text.RegularExpressions;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    /// <summary>
    /// Returns the list of all active utilities.
    /// </summary>
    /// <remarks>This is a Factory class used to
    /// retrieve and instantiate utilities.</remarks>
    [Serializable]
    public static class UtilityFactory
    {
        /// <summary>
        /// Gets a dictionary of all active utilities.
        /// </summary>
        /// <returns>The generic dictionary collection of all active utilities.</returns>
        public static UtilityDictionary GetActiveUtilities()
        {
            UtilityDictionary utilities = null; // the return value

            using( DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.UtilitySql.GetUtilities() )
            {
                utilities = UtilityFactory.GetUtilities( ds );
            }

            return utilities;
        }

        /// <summary>
        /// Gets utilities for spcified utility ID
        /// </summary>
        /// <param name="utilityID">Utility record identifier</param>
        /// <returns>Returns a utility list for spcified utility ID.</returns>
        public static UtilityList GetUtilities( int utilityID )
        {
            UtilityList utilities = new UtilityList();

            using( DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.UtilitySql.GetUtilities() )
            {
                utilities = UtilityFactory.GetUtilityList( ds );
            }

            return utilities;
        }

        /// <summary>
        /// Gets utilities
        /// </summary>
        /// <returns>Returns a utility list.</returns>
        public static UtilityList GetUtilityList()
        {
            UtilityList utilities = new UtilityList();

            using( DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.UtilitySql.GetUtilities() )
            {
                utilities = UtilityFactory.GetUtilityList( ds );
            }

            return utilities;
        }


        /// <summary>
        /// Gets utilities for specified market identity.
        /// </summary>
        /// <param name="marketID">Market record identifier</param>
        /// <returns>Returns a utility list for specified market identity.</returns>
        public static UtilityList GetUtilitiesByMarketIdentity( int marketID )
        {
            UtilityList list = new UtilityList();

            list.Add( GetUtilityAllOthers() );

            DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.UtilitySql.GetUtilitiesByMarketIdentity( marketID );
            if( DataSetHelper.HasRow( ds ) )
                foreach( DataRow dr in ds.Tables[0].Rows )
                    list.Add( UtilityFactory.GetUtility( dr ) );
            return list;
        }

        /// <summary>
        /// Gets list of utilities based on wholesale market id (i.e. NEISO, PJM, etc.)
        /// </summary>
        /// <param name="marketID"></param>
        /// <returns></returns>
        public static UtilityList GetUtilitiesByWholesaleMarketId( int marketID )
        {
            UtilityList list = new UtilityList();

            DataSet ds = UtilitySql.GetUtilitiesByWholesaleMarketId( marketID );

            if( DataSetHelper.HasRow( ds ) )
                foreach( DataRow dr in ds.Tables[0].Rows )
                    list.Add( GetUtility( dr ) );

            return list;
        }

        /// <summary>
        /// Gets utilities for specified market identity.
        /// </summary>
        /// <param name="marketID">Market record identifier</param>
        /// <returns>Returns a utility list for specified market identity.</returns>
        public static UtilityDictionary GetUtilitiesByMarketId( int marketID )
        {
            UtilityDictionary utilities = null;

            DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.UtilitySql.GetUtilitiesByMarketIdentity( marketID );
            if( DataSetHelper.HasRow( ds ) )
                utilities = UtilityFactory.GetUtilities( ds );

            return utilities;
        }

        /// <summary>
        /// Gets utility object for all others
        /// </summary>
        /// <returns>Returns a utility object for all others.</returns>
        public static Utility GetUtilityAllOthers()
        {
            Utility u = new Utility( "" );
            u.Identity = -1;
            u.Code = "All Others";
            u.CodeDescription = "All Others";

            return u;
        }

        /// <summary>
        /// Gets utilities by retail market
        /// </summary>
        /// <param name="retailMarketCode">Identifier for market</param>
        /// <returns>DataSet containing a complete list of utilities and related information.</returns>
        public static UtilityDictionary GetUtilitiesByRetailMarket( string retailMarketCode )
        {
            return GetUtilitiesByRetailMarketAndUsername( "", retailMarketCode );
        }

        /// <summary>
        /// Gets utilities by retail market and username
        /// </summary>
        /// <param name="retailMarketCode">Identifier for market</param>
        /// <returns>DataSet containing a complete list of utilities and related information.</returns>
        public static UtilityDictionary GetUtilitiesByRetailMarketAndUsername( string username, string retailMarketCode )
        {
            DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.UtilitySql.GetUtilities( username, retailMarketCode );
            return GetUtilities( ds );
        }

        /// <summary>
        /// Gets utilities by retail market and username
        /// </summary>
        /// <param name="utilityId"></param>
        /// <param name="marketId"></param>
        /// <param name="activeIndicator"></param>
        /// <returns></returns>
        public static UtilityDictionary GetUtilitiesByMarketIdAndUsername( int? marketId, string username )
        {
            DataSet ds = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.GetUtilities( null, marketId, null, username, null, true );
            return GetUtilities( ds );
        }

        /// <summary>
        /// Groups a utility account list by utility
        /// </summary>
        /// <param name="utilityAccountList">List of utility accounts</param>
        /// <returns>UtilityDictionary</returns>
        public static UtilityDictionary GroupAccountsByUtility( UtilityAccountList utilityAccountList )
        {
            UtilityDictionary utilityDictionary = new UtilityDictionary();
            UtilityAccountDictionary utilityAcctDictionary = new UtilityAccountDictionary();
            Utility utility;
            UtilityAccount utilityAccount;

            foreach( UtilityAccount utilAcct in utilityAccountList )
            {
                // determine if Utility object exists for UtilityAccount
                if( utilityDictionary.TryGetValue( utilAcct.UtilityCode, out utility ) )
                {

                    // if UtilityAccount object does not exist in Utility object, create and add to Utility object
                    if( !utility.UtilityAccounts.TryGetValue( utilAcct.AccountNumber, out utilityAccount ) )
                    {
                        //utilityAccount = new UtilityAccount( utilAcct.AccountNumber, utilAcct.UtilityCode );
                        //utilityAccount.ZoneCode = utilAcct.ZoneCode;
                        //utilityAccount.Usages = utilAcct.Usages;

                        utility.AddUtilityAccount( utilAcct );
                    }
                }
                // Utility object not found, create new Utility, UtilityAccount, and LoadShape objects, add values, and add to UtilityDictionary
                else
                {
                    //utilityAccount = new UtilityAccount( utilAcct.AccountNumber, utilAcct.UtilityCode );
                    //utilityAccount.ZoneCode = utilAcct.ZoneCode;
                    //utilityAccount.Usages = utilAcct.Usages;

                    utility = new Utility( utilAcct.UtilityCode );
                    utility.AddUtilityAccount( utilAcct );

                    utilityDictionary.Add( utility );
                }
            }

            return utilityDictionary;
        }

        /// <summary>
        /// Groups accounts by zone
        /// </summary>
        /// <param name="utilityDictionary">UtilityDictionary</param>
        /// <returns>UtilityDictionary grouped by zone</returns>
        public static UtilityDictionary GroupAccountsByZone( UtilityDictionary utilityDictionary )
        {
            UtilityAccount utilityAccount;
            ZoneDictionary zoneDictionary = new ZoneDictionary();
            Zone zone = new Zone();

            foreach( KeyValuePair<string, Utility> pair in utilityDictionary )
            {
                foreach( KeyValuePair<string, UtilityAccount> pairUA in pair.Value.UtilityAccounts )
                {
                    // ensure UtilityDictionary's ZoneDictionary is not null 
                    if( pair.Value.Zones == null )
                    {
                        pair.Value.Zones = new ZoneDictionary();
                    }

                    // zone exists in UtilityDictionary's ZoneDictionary
                    if( pair.Value.Zones.TryGetValue( pairUA.Value.ZoneCode, out zone ) )
                    {
                        // if UtilityAccount is not in zone's UtilityAccountDictionary, add
                        if( !zone.UtilityAccounts.TryGetValue( pairUA.Value.AccountNumber, out utilityAccount ) )
                        {
                            utilityAccount = pairUA.Value;
                            zone.AddUtilityAccount( utilityAccount );

                            // aggregate on and off peak kwh by month
                            AddUsage( utilityAccount, zone );
                        }
                    }
                    // zone does not exist, create zone, 
                    // add UtilityAccount to zone's UtilityAccountDictionary,
                    // add zone to UtilityDictionary's ZoneDictionary
                    else
                    {
                        zone = new Zone();
                        zone.UtilityCode = pairUA.Value.UtilityCode;
                        zone.ZoneCode = pairUA.Value.ZoneCode;
                        zone.AddUtilityAccount( pairUA.Value );

                        // aggregate on and off peak kwh by month
                        AddUsage( pairUA.Value, zone );

                        pair.Value.AddZone( zone );
                    }
                }
            }

            return utilityDictionary;
        }

        /// <summary>
        /// Groups accounts by zone
        /// </summary>
        /// <param name="utilityAccountList">List of utility accounts</param>
        /// <returns>UtilityDictionary</returns>
        public static UtilityDictionary GroupAccountsByZone( UtilityAccountList utilityAccountList )
        {
            UtilityDictionary utilityDictionary = GroupAccountsByUtility( utilityAccountList );
            UtilityAccount utilityAccount;
            ZoneDictionary zoneDictionary = new ZoneDictionary();
            Zone zone = new Zone();

            foreach( KeyValuePair<string, Utility> pair in utilityDictionary )
            {
                foreach( KeyValuePair<string, UtilityAccount> pairUA in pair.Value.UtilityAccounts )
                {
                    // ensure UtilityDictionary's ZoneDictionary is not null 
                    if( pair.Value.Zones == null )
                    {
                        pair.Value.Zones = new ZoneDictionary();
                    }

                    // zone exists in UtilityDictionary's ZoneDictionary
                    if( pair.Value.Zones.TryGetValue( pairUA.Value.ZoneCode, out zone ) )
                    {
                        // if UtilityAccount is not in zone's UtilityAccountDictionary, add
                        if( !zone.UtilityAccounts.TryGetValue( pairUA.Value.AccountNumber, out utilityAccount ) )
                        {
                            utilityAccount = pairUA.Value;
                            zone.AddUtilityAccount( utilityAccount );

                            // aggregate on and off peak kwh by month
                            AddUsage( utilityAccount, zone );
                        }
                    }
                    // zone does not exist, create zone, 
                    // add UtilityAccount to zone's UtilityAccountDictionary,
                    // add zone to UtilityDictionary's ZoneDictionary
                    else
                    {
                        zone = new Zone();
                        zone.UtilityCode = pairUA.Value.UtilityCode;
                        zone.ZoneCode = pairUA.Value.ZoneCode;
                        zone.AddUtilityAccount( pairUA.Value );

                        // aggregate on and off peak kwh by month
                        AddUsage( pairUA.Value, zone );

                        pair.Value.AddZone( zone );
                    }
                }
            }

            return utilityDictionary;
        }

        /// <summary>
        /// Aggregates on and off peak kwh by month
        /// </summary>
        /// <param name="utilityAccount">Single account</param>
        /// <param name="zone"> Reference to Zone object</param>
        private static void AddUsage( UtilityAccount utilityAccount, Zone zone )
        {
            Usage usage = new Usage();

            // loop through usage dictionary, aggregating by month
            foreach( KeyValuePair<DateTime, Usage> pair in utilityAccount.Usages )
            {
                // month exists, add on and off peak values to existing usage
                if( zone.Usages.TryGetValue( pair.Key, out usage ) )
                {
                    if( pair.Value.OnPeakKwh != null )
                        zone.Usages[pair.Key].AddOnPeakKwh( pair.Value.OnPeakKwh );
                    if( pair.Value.OffPeakKwh != null )
                        zone.Usages[pair.Key].AddOffPeakKwh( pair.Value.OffPeakKwh );
                }
                // month does not exist, add usage to zone's usage dictionary
                else
                {
                    zone.Usages.Add( pair.Key, pair.Value );
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataSet">The list of active utilities.</param>
        /// <returns>A dictionary of all active utilities.</returns>
        private static UtilityDictionary GetUtilities( DataSet dataSet )
        {
            UtilityDictionary utilities = null;

            if( dataSet != null && dataSet.Tables.Count > 0 && dataSet.Tables[0].Rows.Count > 0 )
            {
                utilities = new UtilityDictionary();

                foreach( DataRow dataRow in dataSet.Tables[0].Rows )
                {
                    Utility utility = GetUtility( dataRow );
                    if( !utilities.ContainsKey( utility.Code ) )
                    {
                        utilities.Add( utility.Code, utility );
                    }
                }
            }

            return utilities;
        }

        private static UtilityList GetUtilityList( DataSet ds )
        {
            UtilityList utilities = new UtilityList();

            if( DataSetHelper.HasRow( ds ) )
            {
                foreach( DataRow dataRow in ds.Tables[0].Rows )
                {
                    Utility utility = GetUtility( dataRow );
                    utilities.Add( utility );
                }
            }
            return utilities;
        }

        public static UtilityList GetUtilities()
        {
            return GetUtilities( -1 );
        }

        /// <summary>
        /// Extracts a single Utility instance out of a data row.
        /// </summary>
        /// <param name="dr">The data row containing the utility values.</param>
        /// <returns>A single Utility instance represented by the given data row.</returns>
        private static Utility GetUtility( DataRow dr )
        {
            Utility utility = null;

            if( dr != null )
            {
                string code = (string) dr["UtilityCode"];
                string description = dr["UtilityDescription"].ToString();

                utility = new Utility( code );

                utility.Identity = Convert.ToInt32( dr["ID"] );
                utility.FullName = code;
                utility.Description = description;
                utility.CodeDescription = code + " - " + description;
                utility.DunsNumber = (string) dr["DunsNumber"];
                utility.CompanyEntityCode = (string) dr["CompanyEntityCode"];
                utility.DateCreated = (DateTime) dr["DateCreated"];
                utility.CreatedBy = (string) dr["CreatedBy"];
                utility.BillingType = (string) dr["BillingType"];
                utility.RateCodeFormat = (string) dr["RateCodeFormat"];
                utility.RateCodeFields = (string) dr["RateCodeFields"];
                // Begin RAJU Ticket #
				if( dr.Table.Columns.Contains( "AccountLength" ) )
                {
					utility.AccountNumberLength = (int) dr["AccountLength"];
                }
				if( dr.Table.Columns.Contains( "AccountNumberPrefix" ) )
                {
					utility.AccountNumberPrefix = (string) dr["AccountNumberPrefix"];
                }
                // End RAJU Ticket #
                if( dr.Table.Columns.Contains( "ZoneID" ) )
                    utility.DefaultZoneID = (int) dr["ZoneID"];

                if( dr.Table.Columns.Contains( "RetailMarketID" ) )
                {
                    utility.RetailMarketID = Convert.ToInt32( dr["RetailMarketID"] );
                }
                if( dr.Table.Columns.Contains( "ISO" ) )
                    utility.Iso = dr["ISO"].ToString();
                //utility.PricingMode = (PricingMode) Convert.ToInt32( dr["PricingModeID"] );

				if( dr.Table.Columns.Contains( "DeliveryLocationRefID" ) )
					utility.DefaultDeliveryLocationId = (dr["DeliveryLocationRefID"] == System.DBNull.Value ? 0 : (int) dr["DeliveryLocationRefID"]);

				if( dr.Table.Columns.Contains( "DefaultProfileRefID" ) )
					utility.DefaultProfileId = (dr["DefaultProfileRefID"] == System.DBNull.Value ? 0 : (int) dr["DefaultProfileRefID"]);
            }

            return utility;
        }

        /// <summary>
        /// Creates a utility object from data row
        /// </summary>
        /// <param name="dr">Data row</param>
        /// <returns>Returns a utility object from data row.</returns>
        public static Utility CreateUtility( DataRow dr )
        {
            Utility utility = null;

            string code = (string) dr["UtilityCode"];
            utility = new Utility( code );
            utility.Identity = Convert.ToInt32( dr["UtilityID"] );

            return utility;
        }

        /// <summary>
        /// Gets icap factos for specified utility, load shape id and date range
        /// </summary>
        /// <param name="utilityCode">Identifier for utility</param>
        /// <param name="loadShapeId">LOad Shape ID</param>
        /// <param name="beginDate">Start of date range</param>
        /// <param name="endDate">End of date range</param>
        /// <returns>List of IcapFactors</returns>
        public static IcapFactorList GetIcapFactors( string utilityCode, string loadShapeId, DateTime beginDate, DateTime endDate )
        {
            IcapFactorList list = new IcapFactorList();

            DataSet ds = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.SelectIcapFactors( utilityCode, loadShapeId, beginDate, endDate );

            // if icap factor(s) not found, throw error
            if( ds == null )
                throw CreateIcapFactorNotFoundException( loadShapeId, beginDate, endDate );
            if( ds.Tables[0] == null )
                throw CreateIcapFactorNotFoundException( loadShapeId, beginDate, endDate );
            if( ds.Tables[0].Rows.Count == 0 )
                throw CreateIcapFactorNotFoundException( loadShapeId, beginDate, endDate );

            // create list
            foreach( DataRow dr in ds.Tables[0].Rows )
            {
                IcapFactor obj = new IcapFactor( dr["UtilityCode"].ToString(), dr["LoadShapeId"].ToString(),
                    Convert.ToDateTime( dr["IcapDate"] ), Convert.ToDecimal( dr["IcapFactor"] ) );
                obj.ID = Convert.ToInt32( dr["id"] );
                list.Add( obj );
            }

            return list;
        }

        /// <summary>
        /// Creates IcapFactorNotFoundException with specific message
        /// </summary>
        /// <param name="loadShapeId">Load Shape ID</param>
        /// <param name="beginDate">Begin of date range</param>
        /// <param name="endDate">End of date range</param>
        /// <returns>IcapFactorNotFoundException</returns>
        private static IcapFactorNotFoundException CreateIcapFactorNotFoundException(
            string loadShapeId, DateTime beginDate, DateTime endDate )
        {
            string format = "i-Cap Factors for Load Shape ID {0} from {1} to {2} are not found.";
            return new IcapFactorNotFoundException( string.Format( format, loadShapeId,
                beginDate.ToShortDateString(), endDate.ToShortDateString() ) );
        }

        /// <summary>
        /// Gets an utility by its coe
        /// </summary>
        /// <param name="utilityCode">Utility code</param>
        /// <returns>The corresponding utility</returns>
        public static Utility GetUtilityByCode( string utilityCode )
        {
            Utility utility = null; // the return value

            DataSet dsUtility = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.GetUtility( utilityCode );
            if( dsUtility != null )
            {
                if( dsUtility.Tables.Count > 0 && dsUtility.Tables[0].Rows.Count > 0 )
                    utility = GetUtilityFromTable( dsUtility.Tables[0].Rows[0] );
            }

            return utility;
        }

        /// <summary>
        /// Gets the Utility by id.
        /// </summary>
        /// <param name="utilityId">The utility id.</param>
        /// <returns></returns>
        public static Utility GetUtilityById( int utilityId )
        {
            Utility utility = null; // the return value

            DataSet dsUtility = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.GetUtility( utilityId );
            if( DataSetHelper.HasRow( dsUtility ) )
            {
                utility = GetUtilityFromTable( dsUtility.Tables[0].Rows[0] );
            }

            return utility;
        }

        /// <summary>
        /// Extracts a single Utility instance out of a data row from table libertypower..utility
        /// </summary>
        /// <param name="dr">The data row containing the utility values.</param>
        /// <returns>A single Utility instance represented by the given data row.</returns>
        private static Utility GetUtilityFromTable( DataRow dr )
        {
            Utility utility = null;

            if( dr != null )
            {
                string code = (string) dr["UtilityCode"];
                int length = (int) dr["AccountLength"];
                string prefix = (string) dr["AccountNumberPrefix"];
                utility = new Utility( code, prefix, length );

                utility.FullName = code;
                utility.Description = (string) dr["FullName"];
                utility.SSNIsRequired = Convert.ToBoolean( dr["SSNIsRequired"] );
                utility.RetailMarketID = Convert.ToInt32( dr["MarketID"] );
                utility.RetailMarketCode = (string) dr["RetailMarketCode"];

                // New fields:
                if( dr.Table.Columns.Contains( "UtilityDescription" ) && dr["UtilityDescription"] != DBNull.Value )
                    utility.Description = dr["UtilityDescription"].ToString();

                if( dr.Table.Columns.Contains( "CompanyEntityCode" ) && dr["CompanyEntityCode"] != DBNull.Value )
                    utility.CompanyEntityCode = dr["CompanyEntityCode"].ToString();

                if( dr.Table.Columns.Contains( "billing_type" ) && dr["billing_type"] != DBNull.Value )
                    utility.BillingType = dr["billing_type"].ToString();
                // begin ticket 19975
                utility.IsPOR = ((dr["PorOption"].ToString() == "YES") ? true : false);
                // end ticket 19975
                // begin ticket 19540
                utility.HU_RequestType = (string) dr["HU_RequestType"];
                // end ticket 19540
                if( dr.Table.Columns.Contains( "WholeSaleMktID" ) )
                    utility.Iso = dr["WholeSaleMktID"].ToString();

                utility.EnrollmentLeadDays = Convert.ToInt32( dr["EnrollmentLeadDays"] );
                if( dr.Table.Columns.Contains( "CompanyEntityCode" ) )
                    utility.CompanyEntityCode = dr["CompanyEntityCode"].ToString();

                if( dr.Table.Columns.Contains( "ZoneDefault" ) &&
                    dr["ZoneDefault"] != null &&
                    !dr["ZoneDefault"].ToString().Equals( string.Empty ) )
                    utility.DefaultZoneID = int.Parse( dr["ZoneDefault"].ToString() );

                utility.EnrollmentLeadDays = Convert.ToInt32( dr["EnrollmentLeadDays"] );
                if( dr.Table.Columns.Contains( "CompanyEntityCode" ) )
                    utility.CompanyEntityCode = dr["CompanyEntityCode"].ToString();

                if (dr.Table.Columns.Contains("RateCodeRequired"))
                    utility.RateCodeRequired = dr["RateCodeRequired"].ToString();

                try
                {
                    utility.Identity = Convert.ToInt32( dr["ID"] );
                    utility.MultipleMeters = dr["MultipleMeters"] == DBNull.Value ? false : Convert.ToBoolean( dr["MultipleMeters"] );
                }
                catch { }

                utility.IsScrapable = dr.Table.Columns.Contains( "isScrapable" ) && dr["isScrapable"].ToString().Equals( "1" );

				if( dr.Table.Columns.Contains( "DeliveryLocationRefID" ) )
					utility.DefaultDeliveryLocationId = (dr["DeliveryLocationRefID"] == System.DBNull.Value ? 0 : (int) dr["DeliveryLocationRefID"]);

				if( dr.Table.Columns.Contains( "DefaultProfileRefID" ) )
					utility.DefaultProfileId = (dr["DefaultProfileRefID"] == System.DBNull.Value ? 0 : (int) dr["DefaultProfileRefID"]);
            }

            return utility;
        }
        /// <summary>
        /// Gets a dictionary of utility file delimiters.
        /// </summary>
        /// <returns>Returns a dictionary of utility file delimiters.</returns>
        public static UtilityFileDelimiterDictionary GetUtilityFileDelimiters()
        {
            UtilityFileDelimiterDictionary dictionary = new UtilityFileDelimiterDictionary();

            DataSet ds = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.SelectUtilityFileDelimiters();

            if( DataSetHelper.HasRow( ds ) )
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                {
                    string utilityCode = dr["UtilityCode"].ToString();
                    char rowDelimiter = Convert.ToChar( dr["RowDelimiter"] );
                    char fieldDelimiter = Convert.ToChar( dr["FieldDelimiter"] );

                    dictionary.Add( utilityCode, new UtilityFileDelimiter( utilityCode, rowDelimiter, fieldDelimiter ) );
                }
            }
            return dictionary;
        }

        /// <summary>
        /// Gets utility objects that contain utility code, duns number and market code
        /// </summary>
        /// <returns>Returns a utility list that contains utility objects that contain utility code, duns number and market code.</returns>
        public static UtilityList GetUtilityDuns()
        {
            UtilityList list = new UtilityList();

            DataSet ds = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.SelectUtilityDuns();
            if( DataSetHelper.HasRow( ds ) )
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                {
                    string utilityCode = dr["UtilityCode"].ToString();
                    string dunsNumber = dr["DunsNumber"].ToString();
                    string marketCode = dr["MarketCode"].ToString();

                    Utility utility = new Utility( utilityCode );
                    utility.DunsNumber = dunsNumber;
                    utility.RetailMarketCode = marketCode;

                    list.Add( utility );
                }
            }
            return list;
        }

        /// <summary>
        /// Gets one item that is for all utilities
        /// </summary>
        /// <returns>Returns a list that contains one item that is for all utilities.</returns>
        public static UtilityList GetAllUtilitiesItem()
        {
            UtilityList list = new UtilityList();
            Utility utility = new Utility( "" );
            utility.Identity = 0;
            utility.CodeDescription = "All Utilities";
            list.Add( utility );
            return list;
        }

        /// <summary>
        /// Gets utility objects that contain utility code, duns number and market code
        /// </summary>
        /// <param name="dunsNumber">duns number</param>
        /// <returns></returns>
        public static Utility GetUtilityConfig( string dunsNumber, out UtilityFileDelimiter ufd )
        {
            Utility utility = null;
            ufd = null;

            DataSet ds = lp.UtilitySql.SelectUtilityDuns( dunsNumber );
            if( DataSetHelper.HasRow( ds ) )
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                {
                    string utilityCode = dr["UtilityCode"].ToString();
                    string marketCode = dr["MarketCode"].ToString();
                    utility = new Utility( utilityCode );
                    utility.DunsNumber = dunsNumber;
                    utility.RetailMarketCode = marketCode;

                    char rowDelimiter = Convert.ToChar( dr["RowDelimiter"] );
                    char fieldDelimiter = Convert.ToChar( dr["FieldDelimiter"] );
                    ufd = new UtilityFileDelimiter( utilityCode, rowDelimiter, fieldDelimiter );
                }
            }
            return utility;
        }

        /// <summary>
        /// Gets all voltage types
        /// </summary>
        /// <returns>Returns a list of all voltage types.</returns>
        public static VoltageType InsertVoltageTypes( string voltageCode )
        {
            var ds = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.InsertVoltageTypes( voltageCode );
            if( DataSetHelper.HasRow( ds ) )
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                {
                    VoltageType type = new VoltageType();
                    type.Identifier = Convert.ToInt32( dr["ID"] );
                    type.VoltageCode = dr["VoltageCode"].ToString();

                    return type;
                }
            }
            return null;
        }

        /// <summary>
        /// Gets all voltage types
        /// </summary>
        /// <returns>Returns a list of all voltage types.</returns>
        public static VoltageTypeList GetVoltageTypes()
        {
            VoltageTypeList list = new VoltageTypeList();

            DataSet ds = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.SelectVoltageTypes();
            if( DataSetHelper.HasRow( ds ) )
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                {
                    VoltageType type = new VoltageType();
                    type.Identifier = Convert.ToInt32( dr["ID"] );
                    type.VoltageCode = dr["VoltageCode"].ToString();

                    list.Add( type );
                }
            }
            return list;
        }

        /// <summary>
        /// Gets all voltage types
        /// </summary>
        /// <returns>Returns a list of all voltage types.</returns>
        public static VoltageTypeList RefreshVoltageTypes()
        {
            VoltageTypeList list = new VoltageTypeList();

            DataSet ds = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.UpdateVoltageTypes();
            if( DataSetHelper.HasRow( ds ) )
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                {
                    VoltageType type = new VoltageType();
                    type.Identifier = Convert.ToInt32( dr["ID"] );
                    type.VoltageCode = dr["VoltageCode"].ToString();

                    list.Add( type );
                }
            }
            return list;
        }

        /// <summary>
        /// Update the default Zone
        /// </summary>
        /// <param name="z"></param>
        /// <param name="msg"></param>
        /// <returns></returns>
        public static bool UpdateDefaultZone( Utility u, out string msg )
        {
            msg = string.Empty;
            bool bSuccess = true;
            try
            {
                int iRecords = lp.MarkToMarket.UpdateZone( u.Identity, u.DefaultZoneID );
                if( iRecords != 1 )
                {
                    bSuccess = false;
                    msg = "The system could not update the default zone (" + u.Description + "). Please try again later";
                }
            }
            catch( Exception ex )
            {
                bSuccess = false;
                msg = "Error updating the default zone (" + u.Description + "): " + ex.Message;
            }
            return bSuccess;
        }

        /// <summary>
        /// Gets all meter types for utility mapping
        /// </summary>
        /// <returns>Returns a list of all meter types for utility mapping.</returns>
        public static MeterMapTypeList GetMeterMapTypes()
        {
            MeterMapTypeList list = new MeterMapTypeList();

            DataSet ds = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.SelectMeterMapTypes();
            if( DataSetHelper.HasRow( ds ) )
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                {
                    MeterMapType type = new MeterMapType();
                    type.Identifier = Convert.ToInt32( dr["ID"] );
                    type.MeterTypeCode = dr["MeterTypeCode"].ToString();

                    list.Add( type );
                }
            }
            return list;
        }

        /// <summary>.
        /// Gets all utilities that have zones
        /// </summary>
        /// <returns>Returns a utility list that conatins all utilities that have zones</returns>
        public static UtilityList GetUtilitiesThatHaveZones()
        {
            UtilityList list = new UtilityList();
            UtilityList listFiltered = new UtilityList();

            DataSet ds = lp.UtilitySql.SelectUtilitiesThatHaveZones();
            if( DataSetHelper.HasRow( ds ) )
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                    list.Add( BuildUtility( dr ) );
            }
            return list;
        }

        /// <summary>
        /// Gets all utilities that have zones for specified market ID
        /// </summary>
        /// <param name="marketID">Market record identifier</param>
        /// <returns>Returns a utility list that contains all utilities that have zones for specified market ID.</returns>
        public static UtilityList GetUtilitiesThatHaveZones( int marketID )
        {
            UtilityList list = GetUtilitiesThatHaveZones();
            UtilityList listFiltered = new UtilityList();

            var m =
            from p in list
            where p.RetailMarketID == (marketID == 0 ? p.RetailMarketID : marketID)
            orderby p.Code
            select p;

            foreach( Utility u in m )
                listFiltered.Add( u );

            return listFiltered;
        }

        private static Utility BuildUtility( DataRow dr )
        {
            Utility utility = null;

            string utilityCode = dr["UtilityCode"].ToString();
            utility = new Utility( utilityCode );
            utility.Identity = Convert.ToInt32( dr["UtilityID"] );
            utility.FullName = dr["FullName"].ToString();
            utility.RetailMarketID = Convert.ToInt32( dr["MarketID"] );

            return utility;
        }

        /// <summary>
        /// Gets the utilities based on the zip code and sales channel
        /// </summary>
        /// <param name="UserGuid"></param>
        /// <param name="Zipcode"></param>
        /// <returns>Utility object</returns>
        public static UtilityList GetUtilities( string UserGuid, string Zipcode )
        {
            UtilityList utilityList = new UtilityList();

            DataSet ds = SalesChannelUserSql.GetSalesChannelUser( UserGuid );
            if( !DataSetHelper.HasRow( ds ) )
                throw new Exception( "Could not find user by user guid" );

            string Username = ds.Tables[0].Rows[0]["UserName"].ToString();

            DataSet dsUtility = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.GetUtilities( Username, Zipcode );
            if( DataSetHelper.HasRow( dsUtility ) )
            {
                foreach( DataRow dr in dsUtility.Tables[0].Rows )
                {
                    Utility utility = GetUtilityFromTable( dr );
                    utilityList.Add( utility );
                }
            }

            return utilityList;
        }

        /// <summary>
        /// get the list of ISOs with ID
        /// </summary>
        /// <param name="addDefaultValue">if = True, Add < None > as a default entry to the top of the list</param>
        /// <returns>dictionary with a list of ISOs: key= ISO, value = ISO</returns>
		public static Dictionary<string, string> GetISOListWithID( bool addDefaultValue )
        {
            try
            {
                Dictionary<string, string> isoList = new Dictionary<string, string>();
				if( addDefaultValue )
					isoList.Add( "< None >", "< None >" );

                DataSet ds = lp.UtilitySql.GetISOLsit();
				if( DataSetHelper.HasRow( ds ) )
                {
					foreach( DataRow dr in ds.Tables[0].Rows )
                    {
						isoList.Add( dr["ID"].ToString(), dr["ISO"].ToString() );
                    }
                }

                return isoList;
            }
            catch
            {
                return new Dictionary<string, string>();
            }
        }

        /// <summary>
        /// get the list of ISOs
        /// </summary>
        /// <param name="addDefaultValue">if = True, Add < None > as a default entry to the top of the list</param>
        /// <returns>dictionary with a list of ISOs: key= ISO, value = ISO</returns>
        public static Dictionary<string, string> GetISOList( bool addDefaultValue )
        {
            try
            {
                Dictionary<string, string> isoList = new Dictionary<string, string>();
                if( addDefaultValue )
                    isoList.Add( "< None >", "< None >" );

                DataSet ds = lp.UtilitySql.GetISOLsit();
                if( DataSetHelper.HasRow( ds ) )
                    foreach( DataRow dr in ds.Tables[0].Rows )
                        isoList.Add( dr["ISO"].ToString(), dr["ISO"].ToString() );

                return isoList;
            }
            catch
            {
                return new Dictionary<string, string>();
            }
        }

        /// <summary>
        /// Given a single account and a utility-code, this method returns true if the account matches the utility's specs..
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilityCode"></param>
        /// <returns></returns>
        public static bool ValidateAccountFormat( string accountNumber, string utilityCode )
        {
            // Abhi Kulkarni (10/8/2013) - Bug #22480 - account number is invalid if it contains "E+" (malformatted # in excel)
			if( accountNumber.Length > 0 && accountNumber.ToUpper().Contains( "E+" ) )
		        return false;

            Utility utility = new Utility();
			utility = GetUtilityByCode( utilityCode.ToUpper() );

			//// Rafael Ribeiro (1/31/2014) - Bug #32381 - Regex added to validate the account number. It has to be an only numeral field that matches the exact length as the utility.AccountNumberLength property
			//if (utility == null || (utility.AccountNumberLength > 0 && !Regex.Match(accountNumber, @"^[0-9]{" + utility.AccountNumberLength + "}$").Success))
			//    return false;

			// Gail M. (4/1/2014) - Bug 36878/36866 replacing validation above with the original because of issues with NYSEG accounts.   
			// In any case validation should be that only numeric characters exist after the prefix not that the length after the prefix should match. To be researched!!

            if( utility == null || (utility.AccountNumberLength > 0 && accountNumber.Length != utility.AccountNumberLength) )
                return false;

            if( !string.IsNullOrEmpty( utility.AccountNumberPrefix ) && !accountNumber.StartsWith( utility.AccountNumberPrefix ) )
                return false;

            return true;
        }

		/// <summary>
		/// get the stratum end for the stratum variable passed
		/// </summary>
		/// <param name="UtilityId">Utility ID, 18-CONED for now</param>
		/// <param name="Stratum">stratum variable</param>
		/// <param name="ServiceClass">service class</param>
		/// <returns>stratum end</returns>
		public static decimal GetStratumEnd( int UtilityId, decimal Stratum, string ServiceClass )
		{
			decimal stratumEnd;
            //removed error handling so errors will bubble up and be handled by the caller
            //try
            //{
				stratumEnd = UtilitySql.GetStratumEnd( UtilityId, Stratum, ServiceClass );
            //}
            //catch( Exception )
            //{
            //    stratumEnd = -1;
            //}

			return stratumEnd;
		}

		public static string GetStratumServiceClassMappingId( string serviceClass )
	    {
			string mappingId = null;
            //removed error handling so errors will bubble up and be handled by the caller
            //try
            //{
				mappingId = UtilitySql.GetStratumServiceClassMappingId( serviceClass );
            //}
            //catch( Exception )
            //{
            //    mappingId = null;
            //}

		    return mappingId;
	    }

        public static DataSet GetUtilitiesMappingByDate(string lastModifiedDate)
        {

            DataSet utilities = LibertyPower.DataAccess.SqlAccess.CommonSql.UtilitySql.GetUtilitiesMappingByDate(lastModifiedDate);
            return utilities;
        }
    }
}
