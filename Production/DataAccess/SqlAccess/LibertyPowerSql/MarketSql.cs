namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	using System;
	using System.Data;
	using System.Data.SqlClient;

	public static class MarketSql
	{
		/// <summary>
		/// Gets markets that have zones
		/// </summary>
		/// <returns>Returns a dataset that has markets that have zones.</returns>
		public static DataSet SelectMarketsThatHaveZones()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
				    cmd.CommandText = "usp_MarketsThatHaveZonesSelect";

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets market for specified utility ID
		/// </summary>
		/// <param name="utilityID">Utility recortd identifier</param>
		/// <returns>Returns a dataset that contains the market for specified utility ID.</returns>
		public static DataSet SelectMarketByUtilityID(int utilityID)
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_MarketByUtilityIDSelect";

					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
        /// <summary>
        /// Gets market for specified utility ID
        /// </summary>
        /// <param name="utilityID">Utility recortd identifier</param>
        /// <returns>Returns a dataset that contains the market for specified utility ID.</returns>
        public static DataSet GetSalesChannelsMarketList(string SalesChannelIds)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_SalesChannelMarketlist";
                    cmd.Parameters.Add(new SqlParameter("@p_salesChannelIds", SalesChannelIds));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }

            return ds;
        }
	}
}
