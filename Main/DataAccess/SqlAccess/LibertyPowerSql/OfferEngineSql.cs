using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class OfferEngineSql
    {


        /// <summary>
        /// Defines a Commission value
        /// </summary>
        /// <param name="offerId"></param>
        /// <param name="commission"></param>
        public static void DefineCommissionUpdate(string offerId, decimal commission)
        {
          DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDefineCommissionUpdate";

                    cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );
                    cmd.Parameters.Add( new SqlParameter( "@Commission", commission ) );

                    conn.Open();
                    cmd.ExecuteScalar();

                }
            }
        }
      
        /// <summary>
        ///  Defines a Bandwitdh Price value.
        /// </summary>
        /// <param name="offerId"></param>
        /// <param name="bandwitdhPrice"></param>
        public static void DefineBandwitdhPriceUpdate( string offerId, decimal bandwitdhPrice )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDefineBandwitdhPriceUpdate";

                    cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );
                    cmd.Parameters.Add( new SqlParameter( "@BandwitdhPrice", bandwitdhPrice ) );

                    conn.Open();
                    cmd.ExecuteScalar();

                }
            }
        }

        /// <summary>
        /// Defines a Bandwitdh Percent value.
        /// </summary>
        /// <param name="bandwitdhPercent"></param>
        /// <param name="offerId"></param>
        public static void DefineBandwitdhPercentUpdate( string offerId, decimal bandwitdhPercent)
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDefineBandwitdhPercentUpdate";

                    cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );
                    cmd.Parameters.Add( new SqlParameter( "@BandwitdhPercent", bandwitdhPercent ) );

                    conn.Open();
                    cmd.ExecuteScalar();

                }
            }
        }


        /// <summary>
        /// Defines a Bandwitdh Premium value.
        /// </summary>
        /// <param name="bandwitdhPercent"></param>
        /// <param name="offerId"></param>
        public static void DefineBandwitdhPremiumUpdate( string offerId, decimal bandwitdhPremium )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDefineBandwitdhPremiumUpdate";

                    cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );
                    cmd.Parameters.Add( new SqlParameter( "@BandwitdhPercent", bandwitdhPremium ) );

                    conn.Open();
                    cmd.ExecuteScalar();

                }
            }
        }

















    }
}
