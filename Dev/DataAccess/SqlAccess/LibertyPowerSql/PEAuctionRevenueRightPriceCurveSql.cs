using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class PEAuctionRevenueRightPriceCurveSql
	{
		/// <summary>
		/// Selects the auction revenue right price for the specified iso, zone, month, and year.
		/// </summary>
		/// <param name="iso">Iso</param>
		/// <param name="zoneCode">Zone identifier</param>
		/// <param name="beginDate">Begin date of curve</param>
		/// <param name="endDate">End date of curve</param>
		/// <returns>Returns a dataset containing the auction revenue right price for the specified 
		/// iso, zone, month, and year.</returns>
		public static DataSet SelectAuctionRevenueRightPriceCurve( string iso, string zoneCode, DateTime beginDate, DateTime endDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_VRE_AuctionRevenueRightsSelect";

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

