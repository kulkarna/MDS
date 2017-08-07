using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class PEPorCurveSql
	{
		/// <summary>
		/// Selects POR type and rate based on utility.
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <returns>Returns a dataset containing the POR type and rate based on utility.</returns>
		public static DataSet SelectPOR( string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEPorByUtilitySelect";

					cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
	}
}

