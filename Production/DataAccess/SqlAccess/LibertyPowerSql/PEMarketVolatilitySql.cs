using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEMarketVolatilitySql
    {

        /// <summary>
        /// Selects Market Volatility y range of datesb
        /// </summary>
        /// <param name=MarketVolatilityId></param>
        /// <returns>A dataset with all fields of the PEMarketVolatility table</returns>
        public static DataSet SelectMarketVolatility(DateTime dateFrom, DateTime dateTo)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEMarketVolatilitySelectList";

                    cmd.Parameters.Add(new SqlParameter("@p_dateFrom", dateFrom));
                    cmd.Parameters.Add(new SqlParameter("@p_dateTo", dateTo));
                    
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a MarketVolatility
        /// </summary>
        /// <param name=MarketVolatility></param>
        public static int InsertMarketVolatility( DateTime marketVolatilityDate, String volatilityFlag, char activeFlag )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMarketVolatilityInsert";

                    cmd.Parameters.Add(new SqlParameter("@MarketVolatilityDate", marketVolatilityDate));
                    cmd.Parameters.Add(new SqlParameter("@VolatilityFlag", volatilityFlag));
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        public static void UpdateMarketVolatility( int id, char activeFlag )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMarketVolatilityUpdate";

                    cmd.Parameters.Add( new SqlParameter( "@MarketVolatilityId", id ) );
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );

                    conn.Open();
                    cmd.ExecuteScalar();

                }
            }
        }
    }
}


