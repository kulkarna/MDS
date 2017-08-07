using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEEnergyTradingMarketCurveReportsSql
    {
        public static DataSet SelectEnergyTradingMarketCurveReports( string symbol, DateTime timeStampStart, DateTime timeStampEnd )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[usp_PEEnergyTradingMarketCurveReportsSelect]";

                    cmd.Parameters.Add( new SqlParameter( "@Symbol", symbol ) );
                    cmd.Parameters.Add( new SqlParameter( "@TimeStampStart", timeStampStart ) );
                    cmd.Parameters.Add( new SqlParameter( "@TimeStampEnd", timeStampEnd) );


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
