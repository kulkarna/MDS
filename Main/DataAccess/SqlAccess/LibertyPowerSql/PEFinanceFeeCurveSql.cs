using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class PEFinanceFeeCurveSql
	{
		/// <summary>
		/// Selects finance fee based on market.
		/// </summary>
		/// <param name="market">Market identifier</param>
		/// <returns>Returns a dataset containing the finance fee based on market.</returns>
		public static DataSet SelectFinanceFeeCurve( string market )
		{
			DataSet ds = new DataSet();

			using(SqlConnection conn = new SqlConnection( Helper.ConnectionString ))
			{
				using(SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_VRE_FinanceFeeSelect";

					cmd.Parameters.Add( new SqlParameter( "@Market", market ) );

					using(SqlDataAdapter da = new SqlDataAdapter( cmd ))
						da.Fill( ds );
				}
			}
			return ds;
		}
	}
}

