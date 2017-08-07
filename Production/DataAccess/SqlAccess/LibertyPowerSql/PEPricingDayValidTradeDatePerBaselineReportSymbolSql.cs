using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEPricingDayValidTradeDatePerBaselineReportSymbolSql
    {

        /// <summary>
        /// Inserts a new Pricing Day Valid Trade Date Per Baseline Report Symbol.
        /// </summary>
        /// <param name="baselineReportSymbol"></param>
        /// <param name="validaTradeDate"></param>
        /// <param name="pricingDay"></param>
        /// <returns></returns>
        public static int InsertPricingDayValidTradeDatePerBaselineReportSymbol( string baselineReportSymbol, DateTime validaTradeDate, DateTime pricingDay)
        {
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPricingDayValidTradeDatePerBaselineReportSymbolInsert";

                    cmd.Parameters.Add( new SqlParameter( "@BaselineReportSymbol", baselineReportSymbol ) );
                    cmd.Parameters.Add( new SqlParameter( "@ValidateTradeDate", validaTradeDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@PricingDay", pricingDay ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        /// <summary>
        /// Selects a list of all records.
        /// </summary>
        /// <returns></returns>
        public static DataSet SelectListPricingDaysPerBaselineReportSymbol()
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPricingDayValidTradeDatePerBaselineReportSymbolSelectList";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the max and min trading day based on Baseline Symbol.
        /// </summary>
        /// <param name="baselineSymbol"></param>
        /// <returns></returns>
        public static DataSet SelectPricingDayRange( string baselineSymbol )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPricingDayValidTradeDatePerBaselineReportSymbolSelectRange";

                    cmd.Parameters.Add( new SqlParameter( "@BaselineReportSymbol", baselineSymbol ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }
    }
}
