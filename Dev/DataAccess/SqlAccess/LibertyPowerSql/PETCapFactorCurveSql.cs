using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class PETCapFactorCurveSql
	{
		/// <summary>
		/// Selects the T-Cap factors for the specified iso, zone, beginDate, and endDate.
		/// </summary>
		/// <param name="iso">Iso</param>
		/// <param name="zoneCode">Zone identifier</param>
		/// <param name="beginDate">Begin date</param>
		/// <param name="endDate">End date</param>
		/// <returns>Returns a dataset containing the T-Cap factor for the specified iso, zone, beginDate, and endDate.</returns>
		public static DataSet SelectTCapFactorCurve( string iso, string zoneCode, DateTime beginDate, DateTime endDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp__VRE_TCapFactorSelect";

					cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
					cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
					cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

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

