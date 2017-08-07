using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class RetentionSavedAccountsQueueSql
	{

		public static DataSet Get( int savedAccountsQueueID )
		{
			DataSet ds = new DataSet();

			using ( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_RetentionSavedAccountsQueueSelectBySavedAccountsQueueID";

					cmd.Parameters.Add( new SqlParameter( "@SavedAccountsQueueID", savedAccountsQueueID ) );

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetList( string accountNumber, string customerName, string istaInvoiceNumber, int invoiceStatus, DateTime? processedStartDate, DateTime? processedEndDate, DateTime? insertedStart, DateTime? insertedEnd, int? aging )
		{
			DataSet ds = new DataSet();

			using ( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_RetentionSavedAccountsQueueSelect";

					cmd.Parameters.Add( new SqlParameter( "@DateProcessingStart", processedStartDate ) );
					cmd.Parameters.Add( new SqlParameter( "@DateProcessingEnd", processedEndDate ) );
					cmd.Parameters.Add( new SqlParameter( "@DateInsertedStart", insertedStart ) );
					cmd.Parameters.Add( new SqlParameter( "@DateInsertedEnd", insertedEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@StatusID", invoiceStatus ) );
					cmd.Parameters.Add( new SqlParameter( "@Aging", aging ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@CustomerName", customerName ) );
					cmd.Parameters.Add( new SqlParameter( "@IstaInvoiceNumber", istaInvoiceNumber ) );

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static int InsertRetentionSavedAccountsQueue( int accountID, int etfID, int etfInvoiceID, int statusID, DateTime dateInserted )
		{
			int id;
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_RetentionSavedAccountsQueueInsert";

					command.Parameters.Add( new SqlParameter( "AccountID", accountID ) );
					command.Parameters.Add( new SqlParameter( "EtfID", etfID ) );
					command.Parameters.Add( new SqlParameter( "EtfInvoiceID", etfInvoiceID ) );
					command.Parameters.Add( new SqlParameter( "StatusID", statusID ) );
					command.Parameters.Add( new SqlParameter( "DateInserted", dateInserted ) );

					connection.Open();
					id = int.Parse( command.ExecuteScalar().ToString() );
				}
			}
			return id;
		}


		public static int UpdateRetentionSavedAccountsQueue( int savedAccountsQueueID, int accountID, int etfID, int etfInvoiceID, int statusID, DateTime dateProcessed, string processedBy, string istaWaivedInvoiceNumber, DateTime dateInserted )
		{
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_RetentionSavedAccountsQueueUpdate";

					command.Parameters.Add( new SqlParameter( "SavedAccountsQueueID", savedAccountsQueueID ) );
					command.Parameters.Add( new SqlParameter( "AccountID", accountID ) );
					command.Parameters.Add( new SqlParameter( "EtfID", etfID ) );
					command.Parameters.Add( new SqlParameter( "EtfInvoiceID", etfInvoiceID ) );
					command.Parameters.Add( new SqlParameter( "StatusID", statusID ) );
					command.Parameters.Add( new SqlParameter( "DateProcessed", dateProcessed ) );
					command.Parameters.Add( new SqlParameter( "ProcessedBy", processedBy ) );
					command.Parameters.Add( new SqlParameter( "IstaWaivedInvoiceNumber", istaWaivedInvoiceNumber ) );
					command.Parameters.Add( new SqlParameter( "DateInserted", dateInserted ) );

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
			return savedAccountsQueueID;
		}

		public static void DeleteRetentionSavedAccountsQueue( int savedAccountsQueueID )
		{
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_RetentionSavedAccountsQueueDelete";

					command.Parameters.Add( new SqlParameter( "SavedAccountsQueueID", savedAccountsQueueID ) );

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
		}


	}

}
