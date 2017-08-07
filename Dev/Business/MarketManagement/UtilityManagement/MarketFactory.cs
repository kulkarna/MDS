namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using System.Text;
    using System.Data;
    using LibertyPower.Business.CommonBusiness.CommonHelper;
    using LibertyPower.DataAccess.SqlAccess.CommonSql;
    using lp = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    /// <summary>
    /// Factory for market related data
    /// </summary>
    public class MarketFactory
    {
        /// <summary>
        /// Returns a Dictionary with a List of Retail Markets
        /// </summary>
        /// <returns>RetailMarketDictionary</returns>
        public static RetailMarketDictionary GetRetailMarketList()
        {
            RetailMarketDictionary retailMarketDicionary = null;

            DataSet dsMarket = MarketSql.GetMarketList();

            if (DataSetHelper.HasRow(dsMarket))
            {
                retailMarketDicionary = new RetailMarketDictionary();
                foreach (DataRow row in dsMarket.Tables[0].Rows)
                {
                    int id = Convert.ToInt32(row["ID"]);
                    string code = row["retail_mkt_id"].ToString();
                    string description = row["retail_mkt_descp"].ToString();

                    RetailMarket retailMarket = new RetailMarket(code);

                    retailMarket.ID = id;
                    retailMarket.Description = description;
                    retailMarket.CodeDescription = code + " - " + description;

                    AddUtilities(retailMarket);
                    if (!retailMarketDicionary.ContainsKey(retailMarket.Code))
                        retailMarketDicionary.Add(retailMarket.Code, retailMarket);
                }
            }

            return retailMarketDicionary;
        }

        /// <summary>
        /// Gets markets for specified username
        /// </summary>
        /// <param name="username">Username</param>
        /// <returns>Returns a market dictionary for specified username.</returns>
        public static RetailMarketDictionary GetMarketsByUsername(string username)
        {
            RetailMarketDictionary dict = null;

            DataSet ds = MarketSql.GetMarketsByUsername(username);

            if (DataSetHelper.HasRow(ds))
            {
                dict = new RetailMarketDictionary();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    int id = Convert.ToInt32(dr["ID"]);
                    string code = dr["MarketId"].ToString();
                    string description = dr["MarketDesc"].ToString();

                    if (!dict.ContainsKey(code))
                    {

                        RetailMarket rm = new RetailMarket(code);

                        rm.ID = id;
                        rm.Description = description;
                        rm.CodeDescription = code + " - " + description;

                        AddUtilitiesByMarketId(rm);
                        dict.Add(rm.Code, rm);
                    }
                }
            }
            return dict;
        }

        /// <summary>
        /// Gets markets for specified channel id
        /// </summary>
        /// <param name="salesChannelId"></param>
        /// <returns></returns>
        public static RetailMarketDictionary GetMarketsBySalesChannelId(int salesChannelId)
        {
            RetailMarketDictionary dict = null;

            DataSet ds = MarketSql.GetMarketsBySalesChannelId(salesChannelId);

            if (DataSetHelper.HasRow(ds))
            {
                dict = new RetailMarketDictionary();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    int id = Convert.ToInt32(dr["ID"]);
                    string code = dr["MarketId"].ToString();
                    string description = dr["MarketDesc"].ToString();

                    if (!dict.ContainsKey(code))
                    {

                        RetailMarket rm = new RetailMarket(code);

                        rm.ID = id;
                        rm.Description = description;
                        rm.CodeDescription = code + " - " + description;

                        AddUtilitiesByMarketId(rm);
                        dict.Add(rm.Code, rm);
                    }
                }
            }
            return dict;
        }

        /// <summary>
        /// Gets markets for specified username
        /// </summary>
        /// <param name="username">Username</param>
        /// <returns>Returns a market list for specified username.</returns>
        public static RetailMarketList GetMarketsByUsernameForDailyPricing(string username)
        {
            RetailMarketList list = new RetailMarketList();

            DataSet ds = MarketSql.GetMarketsByUsernameForDailyPricing(username);

            if (DataSetHelper.HasRow(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    int id = Convert.ToInt32(dr["ID"]);
                    string code = dr["MarketId"].ToString();
                    string description = dr["MarketDesc"].ToString();
                    bool enableTieredPricing = Convert.ToBoolean(dr["EnableTieredPricing"]);

                    RetailMarket rm = new RetailMarket(code);

                    rm.ID = id;
                    rm.Description = description;
                    rm.CodeDescription = code + " - " + description;
                    rm.EnableTieredPricing = enableTieredPricing;

                    AddUtilitiesByMarketId(rm);
                    list.Add(rm);
                }
            }
            return list;
        }

        /// <summary>
        /// Gets a list of retail market objects
        /// </summary>
        /// <returns>Returns a list of retail market objects</returns>
        public static RetailMarketList GetRetailMarketListWithAll()
        {
            RetailMarketList list = null;
            RetailMarket rm;

            DataSet dsMarket = LibertyPower.DataAccess.SqlAccess.CommonSql.MarketSql.GetMarketListForDailyPricing();

            if (DataSetHelper.HasRow(dsMarket))
            {
                list = new RetailMarketList();

                list.Add(GetRetailMarketAllOthers());

                foreach (DataRow dr in dsMarket.Tables[0].Rows)
                {
                    int id = Convert.ToInt32(dr["ID"]);
                    string code = dr["retail_mkt_id"].ToString();
                    string description = dr["retail_mkt_descp"].ToString();

                    rm = new RetailMarket(code);

                    rm.ID = id;
                    rm.Description = description;
                    rm.CodeDescription = code + " - " + description;

                    list.Add(rm);
                }
            }

            return list;
        }

        /// <summary>
        /// Gets market object for all others
        /// </summary>
        /// <returns>Returns a market object for all others.</returns>
        public static RetailMarket GetRetailMarketAllOthers()
        {
            RetailMarket rm = new RetailMarket();
            rm.ID = -1;
            rm.Code = "All Others";
            rm.CodeDescription = "All Others";

            return rm;
        }

        /// <summary>
        /// Return a RetailMarket object
        /// </summary>
        /// <param name="retailMarketCode">Retail market code</param>
        /// <returns>RetailMarket</returns>
        public static RetailMarket GetRetailMarket(string retailMarketCode)
        {
            RetailMarket retailMarket = null;

            DataSet dsMarket = LibertyPower.DataAccess.SqlAccess.CommonSql.MarketSql.GetMarket(retailMarketCode);

            if (dsMarket.Tables[0].Rows.Count > 0)
            {
                retailMarket = LoadRetailMarket(dsMarket.Tables[0].Rows[0]);
                AddUtilities(retailMarket);

            }

            return retailMarket;
        }



        /// <summary>
        /// Gets the retail market.
        /// </summary>
        /// <param name="id">The id.</param>
        /// <returns>Returns a retail market object for specified record identifier</returns>
        public static RetailMarket GetRetailMarket(int id)
        {
            RetailMarket retailMarket = null;

            DataSet dsMarket = LibertyPower.DataAccess.SqlAccess.CommonSql.MarketSql.GetMarket(id);

            if (dsMarket.Tables[0].Rows.Count > 0)
            {
                retailMarket = LoadRetailMarket(dsMarket.Tables[0].Rows[0]);
                AddUtilities(retailMarket);

            }

            return retailMarket;
        }

        /// <summary>
        /// Gets market for specified utility code
        /// </summary>
        /// <param name="utilityCode">Utility code</param>
        /// <returns>Returns a market code string for specified utility code</returns>
        public static string GetRetailMarketByUtility(string utilityCode)
        {
            string retailMarket = "";

            DataSet dsMarket = LibertyPower.DataAccess.SqlAccess.CommonSql.MarketSql.GetMarketByUtility(utilityCode);

            if (dsMarket.Tables[0].Rows.Count > 0)
                retailMarket = dsMarket.Tables[0].Rows[0]["RetailMarketId"].ToString();
            return retailMarket;
        }

        /// <summary>
        /// Gets market code for specified utility ID
        /// </summary>
        /// <param name="utilityID">Utility record identifier</param>
        /// <returns>Returns a market code string for specified utility ID.</returns>
        public static string GetRetailMarketByUtilityID(int utilityID)
        {
            string retailMarket = "";

            DataSet ds = lp.MarketSql.SelectMarketByUtilityID(utilityID);

            if (DataSetHelper.HasRow(ds))
                retailMarket = ds.Tables[0].Rows[0]["MarketCode"].ToString();

            return retailMarket;
        }

        /// <summary>
        /// Gets markets that have zones
        /// </summary>
        /// <returns>Returns a list that contains markets that have zones.</returns>
        public static RetailMarketList GetMarketsThatHaveZones()
        {
            RetailMarketList list = new RetailMarketList();

            DataSet ds = lp.MarketSql.SelectMarketsThatHaveZones();

            if (DataSetHelper.HasRow(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    int id = Convert.ToInt32(dr["MarketID"]);
                    string code = dr["MarketCode"].ToString();
                    string description = dr["RetailMktDescp"].ToString();

                    RetailMarket rm = new RetailMarket(code);

                    rm.ID = id;
                    rm.Description = description;
                    rm.CodeDescription = code + " - " + description;

                    list.Add(rm);
                }
            }
            return list;
        }

        private static void AddUtilities(RetailMarket retailMarket)
        {
            UtilityDictionary utilityDictionary = UtilityFactory.GetUtilitiesByMarketId(retailMarket.ID);

            if (utilityDictionary != null)
            {
                foreach (KeyValuePair<string, Utility> kvp in utilityDictionary)
                {
                    retailMarket.AddUtility(kvp.Value);
                }
            }
        }

        private static void AddUtilitiesByMarketId(RetailMarket retailMarket)
        {
            UtilityDictionary utilityDictionary = UtilityFactory.GetUtilitiesByMarketId(retailMarket.ID);
            if (utilityDictionary != null)
            {
                foreach (KeyValuePair<string, Utility> kvp in utilityDictionary)
                {
                    retailMarket.AddUtility(kvp.Value);
                }
            }
        }

        /// <summary>
        /// Loads the Retail Market object.
        /// </summary>
        /// <param name="datarow">The datarow.</param>
        /// <returns></returns>
        private static RetailMarket LoadRetailMarket(DataRow datarow)
        {
            RetailMarket rm = null;

            string code = datarow["retail_mkt_id"].ToString();
            string description = datarow["retail_mkt_descp"].ToString();

            rm = new RetailMarket(code);
            rm.ID = Convert.ToInt32(datarow["ID"]);
            rm.Description = description;
            rm.CodeDescription = code + " - " + description;
            rm.PucCertificationNumber = datarow["puc_certification_number"].ToString();
            rm.DateCreated = Convert.ToDateTime(datarow["date_created"]);
            rm.ActiveDate = Convert.ToDateTime(datarow["active_date"]);
            return rm;
        }

        /// <summary>
        /// Creates a market object from data row.
        /// </summary>
        /// <param name="dr">Data row</param>
        /// <returns>Returns a market object from data row.</returns>
        public static RetailMarket CreateMarket(DataRow dr)
        {
            string code = dr["MarketCode"].ToString();

            RetailMarket rm = new RetailMarket(code);
            rm.ID = Convert.ToInt32(dr["MarketID"]);

            return rm;
        }

        public static RetailMarketSalesTax GetMarketSalesTax(RetailMarket market, DateTime date)
        {
            RetailMarketSalesTax salesTax = null;

            DataSet dsSalesTax = LibertyPower.DataAccess.SqlAccess.CommonSql.MarketSql.GetMarketSalesTaxByMarket(market.ID, date);

            if (dsSalesTax.Tables[0].Rows.Count > 0)
            {
                DataRow drSalesTax = dsSalesTax.Tables[0].Rows[0];

                DateTime? effectiveEndDate;

                if (Convert.IsDBNull(drSalesTax["EffectiveEndDate"]))
                    effectiveEndDate = null;
                else
                    effectiveEndDate = Convert.ToDateTime(drSalesTax["EffectiveEndDate"]);

                salesTax = new RetailMarketSalesTax(Convert.ToInt32(drSalesTax["MarketSalesTaxID"]),
                    Convert.ToInt32(drSalesTax["MarketId"]), Convert.ToDouble(drSalesTax["SalesTax"]),
                    Convert.ToDateTime(drSalesTax["EffectiveStartDate"]), effectiveEndDate,
                    Convert.ToDateTime(drSalesTax["DateCreated"]));
            }

            return salesTax;
        }

        public static List<RetailMarketSalesTax> GetMarketGrtSalesTax(RetailMarket market, DateTime date)
        {
            RetailMarketSalesTax salesTax = null;

            var dsSalesTax = LibertyPower.DataAccess.SqlAccess.CommonSql.MarketSql.GetMarketSalesGrtTaxByMarket(market.Code, date);
            
            if (dsSalesTax == null || dsSalesTax.Tables.Count == 0)
                return null;

            var salesTaxList = dsSalesTax.Tables[0].AsEnumerable().Select(row =>
                new RetailMarketSalesTax
                {
                    Identifier = row.Field<int>("MarketSalesTaxID"),
                    MarketID = row.Field<int>("MarketId"),
                    SalesTax = row.Field<double>("SalesTax"),
                    EffectiveStartDate = row.Field<DateTime>("EffectiveStartDate"),
                    EffectiveEndDate = row.Field<DateTime?>("EffectiveEndDate"),
                    CreatedDate = row.Field<DateTime>("DateCreated"),
                    TaxTypeID = row.Field<int>("TaxTypeID"),
                    ChannelTypeID = row.Field<int>("ChannelTypeID"),
                    ApplicationKeyID = row.Field<int>("ApplicationKeyID")

                });

            return (salesTaxList != null && salesTaxList.Count() > 0) ? salesTaxList.ToList() : null;
        }

        public static List<RetailMarketSalesTax> GetMarketSalesTax()
        {
            List<RetailMarketSalesTax> list = new List<RetailMarketSalesTax>();

            DataSet ds = lp.LibertyPowerSql.GetMarketSalesTax();
            if (DataSetHelper.HasRow(ds))
            {
                list.AddRange(from DataRow dr in ds.Tables[0].Rows select BuildRetailMarketSalesTax(dr));
            }   
            return list;
        }

        private static RetailMarketSalesTax BuildRetailMarketSalesTax(DataRow dr)
        {
            return new RetailMarketSalesTax(Convert.ToInt32(dr["MarketSalesTaxID"]),
                    Convert.ToInt32(dr["MarketId"]), Convert.ToDouble(dr["SalesTax"]),
                    Convert.ToDateTime(dr["EffectiveStartDate"]),
                    dr["EffectiveEndDate"] == DBNull.Value ? null : (DateTime?)Convert.ToDateTime(dr["EffectiveEndDate"]),
                    Convert.ToDateTime(dr["DateCreated"]),
                    dr["TaxTypeID"] == DBNull.Value ? 0 : Convert.ToInt32(dr["TaxTypeID"]),
                    dr["ChannelTypeID"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ChannelTypeID"]),
                    dr["ApplicationKeyID"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ApplicationKeyID"]));
        }

        public static RetailMarket GetMarket(int identity)
        {
            RetailMarket market = null;

            DataSet ds = lp.LibertyPowerSql.GetMarket(identity);

            if (DataSetHelper.HasRow(ds))
            {
                market = BuildMarket(ds.Tables[0].Rows[0]);
            }
            return market;
        }

        public static RetailMarketList GetMarkets()
        {
            RetailMarketList list = new RetailMarketList();

            DataSet dsMarket = lp.LibertyPowerSql.GetMarkets();

            if (DataSetHelper.HasRow(dsMarket))
            {
                foreach (DataRow dr in dsMarket.Tables[0].Rows)
                    list.Add(BuildMarket(dr));
            }
            return list;
        }

        private static RetailMarket BuildMarket(DataRow dr)
        {
            string code = dr["MarketCode"].ToString();
            RetailMarket market = new RetailMarket(code);
            int id = Convert.ToInt32(dr["ID"]);
            string description = dr["RetailMktDescp"].ToString();

            market.ID = id;
            market.Description = description;
            market.CodeDescription = code + " - " + description;
            market.WholesaleMarkedId = Convert.ToInt32(dr["WholesaleMktId"]);
            market.PucCertificationNumber = dr["PucCertification_number"].ToString();
            market.DateCreated = Convert.ToDateTime(dr["DateCreated"]);
            market.UserName = dr["Username"].ToString();
            market.ActiveDate = Convert.ToDateTime(dr["ActiveDate"]);
            market.IsInactive = dr["InactiveInd"].ToString() == "1" ? true : false;
            market.TransferOwnershipEnabled = Convert.ToBoolean(dr["TransferOwnershipEnabled"]);
            market.WholesaleMarketCode = dr["WholesaleMarketCode"].ToString();
            market.ChangeStamp = Convert.ToInt32(dr["Chgstamp"]);
            market.EnableTieredPricing = Convert.ToBoolean(dr["EnableTieredPricing"]);

            return market;
        }

        public static void InsertMarket(string marketCode, string description, int wholesaleMarketID, string pucCertificationNumber,
            DateTime dateCreated, string username, string inactiveInd, DateTime activeDate, int changeStamp, int transferOwnershipEnabled, int enableTieredPricing)
        {
            lp.LibertyPowerSql.InsertMarket(marketCode, description, wholesaleMarketID, pucCertificationNumber,
                dateCreated, username, inactiveInd, activeDate, changeStamp, transferOwnershipEnabled, enableTieredPricing);
        }

        public static void UpdateMarket(int identity, string marketCode, string description, int wholesaleMarketID, string pucCertificationNumber,
            string username, string inactiveInd, DateTime activeDate, int changeStamp, int transferOwnershipEnabled, int enableTieredPricing)
        {
            lp.LibertyPowerSql.UpdateMarket(identity, marketCode, description, wholesaleMarketID, pucCertificationNumber,
                username, inactiveInd, activeDate, changeStamp, transferOwnershipEnabled, enableTieredPricing);
        }

        public static WholesaleMarketList GetWholesaleMarkets()
        {
            WholesaleMarketList list = new WholesaleMarketList();
            DataSet ds = lp.LibertyPowerSql.GetWholesaleMarkets();
            if (DataSetHelper.HasRow(ds))
            {
                list.AddRange(from DataRow dr in ds.Tables[0].Rows select BuildWholesaleMarket(dr));
            }
            return list;
        }

        private static WholesaleMarket BuildWholesaleMarket(DataRow dr)
        {
            int identity = Convert.ToInt32(dr["ID"]);
            string wholesaleMarketID = dr["WholesaleMktId"].ToString();
            string description = dr["WholesaleMktDescp"].ToString();
            DateTime dateCreated = Convert.ToDateTime(dr["DateCreated"]);
            string username = dr["Username"].ToString();
            string inactiveInd = dr["InactiveInd"].ToString();
            DateTime activeDate = Convert.ToDateTime(dr["ActiveDate"]);
            int changeStamp = Convert.ToInt32(dr["Chgstamp"]);

            return new WholesaleMarket(identity, wholesaleMarketID, description, dateCreated, username, inactiveInd, activeDate, changeStamp);
        }
    }
}
