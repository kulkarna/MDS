using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class AccountSalesPitchLetterQueueSql
    {

		public static DataSet Get( int salesPitchLetterID )
		{
			DataSet ds = new DataSet();

			using ( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountSalesPitchLetterQueueSelectBySalesPitchLetterID";

					cmd.Parameters.Add( new SqlParameter( "@SalesPitchLetterID", salesPitchLetterID ) );

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetPendingList(  )
		{
			DataSet ds = new DataSet();

			using ( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountSalesPitchLetterQueueSelectPending";

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetAutomatedProcessingList()
		{
			DataSet ds = new DataSet();

			using ( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
        {
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountSalesPitchLetterQueueSelectAutomatedProcessing";

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static int InsertAccountSalesPitchLetterQueue( int accountID, int etfID, int statusID, DateTime dateScheduled, DateTime dateInserted )
		{
			int id;
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountSalesPitchLetterQueueInsert";

					command.Parameters.Add( new SqlParameter( "AccountID", accountID ) );
					command.Parameters.Add( new SqlParameter( "EtfID", etfID ) );
					command.Parameters.Add( new SqlParameter( "StatusID", statusID ) );
                    command.Parameters.Add(new SqlParameter("DateScheduled", dateScheduled));
					command.Parameters.Add( new SqlParameter( "DateInserted", dateInserted ) );

                    connection.Open();
					id = int.Parse( command.ExecuteScalar().ToString() );
				}
			}
			return id;
		}

		public static int UpdateAccountSalesPitchLetterQueue( int salesPitchLetterID, int accountID, int etfID, int statusID, DateTime dateScheduled, DateTime dateProcessed, DateTime dateInserted )
		{
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_AccountSalesPitchLetterQueueUpdate";

					command.Parameters.Add( new SqlParameter( "SalesPitchLetterID", salesPitchLetterID ) );
					command.Parameters.Add( new SqlParameter( "AccountID", accountID ) );
					command.Parameters.Add( new SqlParameter( "EtfID", etfID ) );
					command.Parameters.Add( new SqlParameter( "StatusID", statusID ) );
					command.Parameters.Add( new SqlParameter( "DateScheduled", dateScheduled ) );
					command.Parameters.Add( new SqlParameter( "DateProcessed", dateProcessed ) );
					command.Parameters.Add( new SqlParameter( "DateInserted", dateInserted ) );

					connection.Open();
					command.ExecuteNonQuery();
                }
            }
            return salesPitchLetterID;
        }
    }
}