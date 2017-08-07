using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PETradingDaysPerBaselineReportSymbolSql
    {   
        /// <summary>
        /// Inserts the data into db
        /// </summary>
        /// <param name="baselineReportSymbol"></param>
        /// <param name="tradingDay"></param>
        /// <returns></returns>
        public static int InsertTradingDaysPerBaselineReportSymbol( string baselineReportSymbol, DateTime tradingDay )
        {
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETradingDaysPerBaselineReportSymbolInsert";

                    cmd.Parameters.Add( new SqlParameter( "@BaselineReportSymbol", baselineReportSymbol ) );
                    cmd.Parameters.Add( new SqlParameter( "@TradingDay", tradingDay ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        /// <summary>
        /// Selects a list of all records.
        /// </summary>
        /// <returns></returns>
        public static DataSet SelectListTradingDaysPerBaselineReportSymbol()
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETradingDaysPerBaselineReportSymbolSelectList";

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
        public static DataSet SelectTradingDayRange( string baselineSymbol )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETradingDaysPerBaselineReportSymbolSelectRange";

                    cmd.Parameters.Add( new SqlParameter( "@BaselineReportSymbol", baselineSymbol ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }


    }
}
