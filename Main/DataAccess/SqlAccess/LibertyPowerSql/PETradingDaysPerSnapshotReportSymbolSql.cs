using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PETradingDaysPerSnapshotReportSymbolSql
    {
        /// <summary>
        /// Inserts a TradingDayssPerSnapshotReportSymbol.
        /// </summary>
        /// <param name="snapshotReportSymbol"></param>
        /// <param name="tradingDay"></param>
        /// <returns></returns>
        public static int InsertTradingDaysPerSnapshotReportSymbol( string snapshotReportSymbol, DateTime tradingDay)
        {
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETradingDaysPerSnapshotReportSymbolInsert";

                    cmd.Parameters.Add( new SqlParameter( "@SnapshotReportSymbol", snapshotReportSymbol ) );
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
        public static DataSet SelectListTradingDaysPerSnapshotReportSymbol( )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETradingDaysPerSnapshotReportSymbolSelectList";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }



        /// <summary>
        /// Selects the max and min trading day based on Snapshot Symbol.
        /// </summary>
        /// <param name="snapshotSymbol"></param>
        /// <returns></returns>
        public static DataSet SelectTradingDayRange( string snapshotSymbol )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETradingDaysPerSnapshotReportSymbolSelectRange";

                    cmd.Parameters.Add( new SqlParameter( "@SnapshotReportSymbol", snapshotSymbol ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }
        
    }
}
