using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class CommissionSql
	{
		public static DataSet GetUnprocessedCommissionTransactions()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UnprocessedCommissionTransactionsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static void UpdateCommissionTransactionsDetailIdProcessed( int transactionDetailId, DateTime reportDate )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CommTransDetailIdProcessedUpdate";

					cmd.Parameters.Add( new SqlParameter( "@TransactionDetailId", transactionDetailId ) );
					cmd.Parameters.Add( new SqlParameter( "@ReportDate", reportDate ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}
	}
}
