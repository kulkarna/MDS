using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PETradingHoursPerSymbolSql
    {
        /// <summary>
        /// /// Selects a list of all trading hours per symbol.
        /// </summary>
        /// <returns></returns>
        public static DataSet SelectLisTradingHoursPerSymbol()
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETradingHoursPerSymbolSelectList";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a trading hours per symbol
        /// </summary>
        /// <param name="symbol"></param>
        /// <param name="type"></param>
        /// <param name="tradingOpen"></param>
        /// <param name="tradingClose"></param>
        /// <returns></returns>
        public static int InsertTradingHoursPerSymbol( string symbol, string type , DateTime tradingOpen, DateTime tradingClose )
        {
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETradingHoursPerSymbolInsert";

                    cmd.Parameters.Add( new SqlParameter( "@Symbol", symbol ) );
                    cmd.Parameters.Add( new SqlParameter( "@TradingOpen", tradingOpen ) );
                    cmd.Parameters.Add( new SqlParameter( "@TradingClose", tradingClose ) );
                    cmd.Parameters.Add( new SqlParameter( "@Type", type ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

