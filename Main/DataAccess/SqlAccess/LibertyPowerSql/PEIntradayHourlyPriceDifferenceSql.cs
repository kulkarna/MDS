using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEIntradayHourlyPriceDifferenceSql
    {
        public static int InsertPEIntradayHourlyPriceDifference( int month, int year, decimal lastPriceChange, string intradayVolatility, DateTime timeStamp )
        {
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEIntradayHourlyPriceDifferenceInsert";

                    cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
                    cmd.Parameters.Add( new SqlParameter( "@Year", year ) );
                    cmd.Parameters.Add( new SqlParameter( "@LastPriceChange", lastPriceChange ) );
                    cmd.Parameters.Add( new SqlParameter( "@IntradayVolatility", intradayVolatility ) );
                    cmd.Parameters.Add( new SqlParameter( "@TimeStamp", timeStamp ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
        public static DataSet GetMonthBySymbol( string symbol ) 
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyTradingMarketMonthBySymbolSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Symbol", symbol.Substring( symbol.Length - 1 ) ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }
    }
}
