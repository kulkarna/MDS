using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class PEBillingTransactionCostCurveSql
	{
		/// <summary>
		/// Select billing transaction cost based on billing type.
		/// </summary>
		/// <param name="billingType">Billing type (ex. Supplier Consolidated, Dual Billing, Rate Ready, Bill Ready</param>
		/// <returns>Returns a dataset containing the billing transaction cost based on billing type.</returns>
		public static DataSet SelectBillingTransactionCostCurve( string billingType )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_VRE_BillingTransactionCostSelect";

					cmd.Parameters.Add( new SqlParameter( "@BillingType", billingType ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

	}
}

