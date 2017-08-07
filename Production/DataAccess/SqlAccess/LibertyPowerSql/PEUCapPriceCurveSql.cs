using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class PEUCapPriceCurveSql
	{
		/// <summary>
		/// Selects the U-Cap prices for the specified iso, zone and date range.
		/// </summary>
		/// <param name="iso">Iso</param>
		/// <param name="zoneCode">Zone identifier</param>
		/// <param name="beginDate">Begin date of curve</param>
		/// <param name="endDate">End date of curve</param>
		/// <returns>Returns a dataset containing the U-Cap prices for the specified iso, zone and date range.</returns>
		public static DataSet SelectUCapPriceCurve( string iso, string zoneCode, DateTime beginDate, DateTime endDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_VRE_UCapPriceSelect";

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

