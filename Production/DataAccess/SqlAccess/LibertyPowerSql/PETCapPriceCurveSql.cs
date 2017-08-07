using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class PETCapPriceCurveSql
	{
		/// <summary>
		/// Selects the T-Cap price for the specified iso, zone, beginDate and endDate.
		/// </summary>
		/// <param name="iso">Iso</param>
		/// <param name="zoneCode">Zone identifier</param>
		/// <param name="beginDate">Begin date</param>
		/// <param name="endDate">End date</param>
		/// <returns>Returns a dataset containing the T-Cap price for the specified iso, zone, beginDate and endDate.</returns>
		public static DataSet SelectTCapPriceCurve( string iso, string zoneCode, DateTime beginDate, DateTime endDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp__VRE_TCapPriceSelect";

					cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
					cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
					cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
						ds.Tables[0].TableName = "Data";
					}
				}
			}
			return ds;
		}

	public static int InsertTCapPriceCurve( Guid fileContextGuid, String zoneId, Int32 month, Int32 year, Decimal tCapPrice, int createdBy )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_VRE_TCapPriceCurveInsert";
					cmd.Parameters.Add( new SqlParameter( "@ZoneId", zoneId ) );
					cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
					cmd.Parameters.Add( new SqlParameter( "@Year", year ) );
					cmd.Parameters.Add( new SqlParameter( "@TCapPrice", tCapPrice ) );
					cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
					conn.Open();
					return Convert.ToInt32( cmd.ExecuteScalar() );

				}
			}
		}
	}
}

