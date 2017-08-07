using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEZoneSql
    {

        /// <summary>
        /// Selects all ZoneId's
        /// </summary>
        /// <param name=ZoneId></param>
        /// <returns>A dataset with all ZoneId's</returns>
        public static DataSet GetZoneIds()
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEZoneIdSelect";

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a Zone
        /// </summary>
        /// <param name=Zone></param>
        public static int InsertZone( string zoneId, string iso, string zoneCode, char activeFlag )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEZoneInsert";

                    cmd.Parameters.Add(new SqlParameter("@ZoneId", zoneId));
                    cmd.Parameters.Add(new SqlParameter("@Iso", iso));
                    cmd.Parameters.Add(new SqlParameter("@ZoneCode", zoneCode));
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

		/// <summary>
		/// Selects a List of Zones related to an ISO
		/// </summary>
		/// <param name="isoId">ISO id</param>
		/// <returns>Dataset containing the zone codes</returns>
		public static DataSet SelectZonesByIso(int isoId)
		{
			DataSet ds = new DataSet();
			using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEZoneSelectList";
					cmd.Parameters.Add(new SqlParameter("@p_iso_id", isoId));

					using (SqlDataAdapter da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}


        public static void UpdateZone( int id, char activeFlag )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEZoneUpdate";

                    cmd.Parameters.Add( new SqlParameter( "@Id", id ) );
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );

                    conn.Open();
                    cmd.ExecuteScalar();

                }
            }
        }

    }
}

