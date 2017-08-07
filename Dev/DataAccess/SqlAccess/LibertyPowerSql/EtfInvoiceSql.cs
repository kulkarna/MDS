using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class EtfInvoiceSql
	{

		public static DataSet Get( int etfInvoiceID )
		{
			DataSet ds = new DataSet();

			using ( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfInvoiceQueueSelectByEtfInvoiceID";

					cmd.Parameters.Add( new SqlParameter( "@EtfInvoiceID", etfInvoiceID ) );

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetList( string accountNumber, string customerName, string istaInvoiceNumber, int invoiceStatus, DateTime? invoiceStartDate, DateTime? invoiceEndDate, DateTime? insertedStart, DateTime? insertedEnd, int? aging)
		{
			DataSet ds = new DataSet();

			using ( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfInvoiceQueueSelect";

					cmd.Parameters.Add( new SqlParameter( "@DateInvoicedStart", invoiceStartDate ) );
					cmd.Parameters.Add( new SqlParameter( "@DateInvoicedEnd", invoiceEndDate ) );
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

		public static int InsertAccountEtfInvoiceQueue( int accountID, int etfID, int statusID, bool isPaid, DateTime dateInserted )
		{
			int id;
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_AccountEtfInvoiceQueueInsert";

					command.Parameters.Add( new SqlParameter( "AccountID", accountID ) );
					command.Parameters.Add( new SqlParameter( "EtfID", etfID ) );
					command.Parameters.Add( new SqlParameter( "StatusID", statusID ) );
					command.Parameters.Add( new SqlParameter( "IsPaid", isPaid ) );
					command.Parameters.Add( new SqlParameter( "DateInserted", dateInserted ) );

					connection.Open();
					id = int.Parse( command.ExecuteScalar().ToString() );
				}
			}
			return id;
		}


		public static int UpdateAccountEtfInvoiceQueue( int etfInvoiceID, int accountID, int etfID, int statusID, bool isPaid, DateTime? dateInvoiced, string istaInvoiceNumber, DateTime dateInserted )
		{
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_AccountEtfInvoiceQueueUpdate";

					command.Parameters.Add( new SqlParameter( "EtfInvoiceID", etfInvoiceID ) );
					command.Parameters.Add( new SqlParameter( "AccountID", accountID ) );
					command.Parameters.Add( new SqlParameter( "EtfID", etfID ) );
					command.Parameters.Add( new SqlParameter( "StatusID", statusID ) );
					command.Parameters.Add( new SqlParameter( "IsPaid", isPaid ) );
					command.Parameters.Add( new SqlParameter( "DateInvoiced", (dateInvoiced == null) ? DBNull.Value : (object) dateInvoiced ) );
					command.Parameters.Add( new SqlParameter( "IstaInvoiceNumber", istaInvoiceNumber ) );
					command.Parameters.Add( new SqlParameter( "DateInserted", dateInserted ) );

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
			return etfInvoiceID;
		}



	}

}
