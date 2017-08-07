namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	using System.Data;
	using System.Data.SqlClient;

	public static class ZoneSql
	{
		/// <summary>
		/// Get zones
		/// </summary>
		/// <returns>Returns a dataset that contains all zones</returns>
		public static DataSet SelectZones()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ZonesSelect";

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
