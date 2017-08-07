using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.IO;
using System.Data.SqlClient;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class GasPriceFactory
    {
        public static bool IsValidUser(int userId)
        {
            using (LibertyPowerEntities lp = new LibertyPowerEntities())
            {
                return (from u in lp.Users where 
                    (u.UserID == userId && u.isActive == "Y") select u).FirstOrDefault() != null;
            }
        }

        public static bool IsValidPassKey(string passKeySha1Hash, int[] channelIds)
        {
            foreach (int channelId in channelIds)
                if (IsValidPassKey(passKeySha1Hash, channelId))
                    return true;

            return false;
        }

        public static bool IsValidPassKey(string passKeySha1Hash, int channelId)
        {
            using (LibertyPowerEntities lp = new LibertyPowerEntities())
            {
                int cacheItemId = (from cacheItem in lp.TabletDataCacheItems where 
                    (cacheItem.CacheItemName == "Pricing") select cacheItem).First().TabletDataCacheItemID;

                var hashValue = (from data in lp.TabletDataCaches where (data.TabletDataCacheItemID == cacheItemId &&
                    data.ChannelID == channelId) select data).First().HashValue.ToString();

                string hashValueLastFiveDigits = hashValue.Substring(hashValue.Length - 5);

                return string.Equals(passKeySha1Hash, GetStringSha1Hash(hashValueLastFiveDigits), StringComparison.InvariantCultureIgnoreCase);
            }
        }

        public static string GetGasPricesSetting(string key)
        {
            using (LibertyPowerEntities lp = new LibertyPowerEntities())
            {
                return (from template in lp.DailyPricingGasPricesSettings where (template.Name == key) select template).First().Content;
            }
        }

        public static string GenerateGasPricesSqlScript(string[] csvSheets, DateTime allowedStartDate)
        {
            var template = GasPriceFactory.GetGasPricesSetting("StoredProcedureTemplate");
            var priceSqlRows = GenerateGasPricesSqlRows(csvSheets);
            
            var allowedSalesChannels = GetGasPricesSetting("AllowedChannels").Split(',').ToList();
            allowedSalesChannels = (from n in allowedSalesChannels select n.Trim()).ToList();

            var allowedStartDateStr = allowedStartDate.ToString("MM/dd/yyyy");
            var allowedSalesChannelStr = SerializeList<string>(allowedSalesChannels, ", ", '\'');

            return template
                .Replace("%ROWS%", priceSqlRows)
                .Replace("%AllowedStartDate%", allowedStartDateStr)
                .Replace("%AllowedSalesChannel%", allowedSalesChannelStr)
                .Replace("%GasProductName%", GetGasPricesSetting("GasProductBrand"));
        }

        public static void AlterGasPricesStoredProcedure(string alterSqlCode)
        {
            var connectionString = Helper.ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.Text;
                    command.CommandText = alterSqlCode;

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                }
            }

            /*using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_GenerateGasPrice";

                    connection.Open();
                    command.Parameters.AddWithValue("@DefaultProductCrossPriceSetId", null);
                    command.Parameters.AddWithValue("@TestSimulation", 0);
                    rows = command.ExecuteNonQuery();
                }
            }*/
        }

        #region Helpers

        private static string GenerateGasPricesSqlRows(string[] csvSheets)
        {
            var result = new StringBuilder();

            foreach (var csvSheet in csvSheets)
            {
                var marketName = FindSheetMarketCode(csvSheet);
                var csvRows = GetGasPrices(csvSheet);
                var sqlRows = GenerateMarketSqlRows(marketName, csvRows);

                result.Append(sqlRows);
            }

            return result.ToString().Trim().TrimEnd(',');
        }

        private static string GenerateMarketSqlRows(string marketCode, List<GasPriceRow> gasPrices)
        {
            var result = new StringBuilder();
            var marketLabel = marketCode.Equals("NJ", StringComparison.CurrentCultureIgnoreCase) ? "@marketIdNJ" : "@marketId";
            var marketUtilitiesMap = GetMarketUtilityMap();
            var marketId = FindMarketId(marketCode);

            foreach (var gasPrice in gasPrices)
            {
                int? utilityId = marketUtilitiesMap.ContainsKey(gasPrice.Utility) ? FindUtilityId(gasPrice.Utility, marketId) : null;

                if (utilityId == null)
                    continue;

                if (gasPrice.Rate > 2)
                    throw new UnauthorizedAccessException("High rate please check the Excel rates and try again");

                if (gasPrice.Term == 0)
                    continue;

                result.Append("(@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId," + marketLabel + "," + utilityId +
                    ",@segmentId,@zoneId,@serviceClassID,@startDate," + gasPrice.Term + "," + gasPrice.Rate +
                    ",@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),@priceTier,@productBrandId,@grossMargin,null),").Append(Environment.NewLine);
            }

            return result.ToString();
        }

        private static List<GasPriceRow> GetGasPrices(string csvContent)
        {
            var needle = FindCsvNeedle(csvContent);
            var result = new List<GasPriceRow>();
            var counter = 0;

            using (StringReader r = new StringReader(csvContent))
            {
                string[] row;
                string line;

                while ((line = r.ReadLine()) != null)
                {
                    if (counter == 0)
                    {
                        counter++;
                        continue;
                    }

                    row = line.Split(needle);

                    if (string.IsNullOrWhiteSpace(row[0]))
                        continue;

                    result.Add(new GasPriceRow {
                        State = row[0],
                        Utility = row[1],
                        Type = row[2],
                        Term = Int32.Parse(row[3]),
                        Rate = Decimal.Parse(row[4].Replace(',', '.'))
                    });
                }
            }

            return result;
        }

        private static Dictionary<string, string> GetMarketUtilityMap()
        {
            return new Dictionary<string, string> { 
                { "PSEG", "NJ" }, 
                { "Con Ed", "NY" }, 
                { "Central Hudson", "NY" } 
            };
        }

        private static int? FindUtilityId(string utilityName, int marketId)
        {
            using (LibertyPowerEntities lp = new LibertyPowerEntities())
            {
                int? id = (from n in lp.Utilities where n.MarketID == marketId && 
                    n.UtilityCode == utilityName select n.ID).FirstOrDefault();

                if (id != null && id > 0)
                    return id.Value;

                id = (from n in lp.Utilities where n.MarketID == marketId && 
                    n.FullName != null && n.FullName.IndexOf(" (" + utilityName) != -1 select n.ID).FirstOrDefault();

                if (id != null && id > 0)
                    return id.Value;

                return null;
            }
        }

        private static int FindMarketId(string marketCode)
        {
            using (LibertyPowerEntities lp = new LibertyPowerEntities())
            {
                return (from r in lp.Markets where r.MarketCode == marketCode select r.ID).First();
            }
        }

        private static char FindCsvNeedle(string csvContent)
        {
            var firstLine = csvContent.Split('\n')[0];
            var semicolonCount = csvContent.Count(c => c == ';');
            var comman = csvContent.Count(c => c == ',');

            return semicolonCount > comman ? ';' : ',';
        }

        private static string FindSheetMarketCode(string csvSheet)
        {
            var marketUtilityMap = GetMarketUtilityMap();

            foreach (var marketUtility in marketUtilityMap)
            {
                if (csvSheet.IndexOf(marketUtility.Key, StringComparison.InvariantCultureIgnoreCase) != -1)
                    return marketUtility.Value;
            }

            return null;
        }

        private static string SerializeList<T>(List<T> list, string needle, char? quoteChar)
        {
            var result = new StringBuilder();

            foreach (T element in list)
                if (quoteChar != null)
                    result.Append(quoteChar).Append(Convert.ToString(element)).Append(quoteChar).Append(needle);
                else
                    result.Append(Convert.ToString(element)).Append(needle);

            return result.ToString().Trim().Trim(needle[0]);
        }

        public static string GetStringSha1Hash(string text)
        {
            if (String.IsNullOrEmpty(text))
                return String.Empty;

            using (var sha1 = new System.Security.Cryptography.SHA1Managed())
            {
                byte[] textData = Encoding.UTF8.GetBytes(text);
                byte[] hash = sha1.ComputeHash(textData);

                return BitConverter.ToString(hash).Replace("-", String.Empty);
            }
        }

        private class GasPriceRow {
            public string State { get; set; }
            public string Utility { get; set; }
            public string Type { get; set; }
            public int Term { get; set; }
            public decimal Rate { get; set; }
        }

        #endregion
    }
}
