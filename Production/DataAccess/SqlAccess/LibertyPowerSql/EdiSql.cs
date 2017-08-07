using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	/// <summary>
	/// EDI data related methods
	/// </summary>
	public static class EdiSql
	{
		/// <summary>
		/// Get last processed 814 key
		/// </summary>
		/// <returns>Returns a DataSet containing the last processed 814 key</returns>
		public static DataSet SelectLastProcessed814Key()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetLastProcessed814Key";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Insert header record, returning the batch ID
		/// </summary>
		/// <param name="began">Date began</param>
		/// <param name="ended">Date ended</param>
		/// <returns>Returns a DataSet containing the batch ID</returns>
		public static DataSet InsertEdiTransactionProcessingHeader( DateTime began, DateTime ended )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiTransactionProcessingHeaderInsert";

					cmd.Parameters.Add( new SqlParameter( "@Began", began ) );
					cmd.Parameters.Add( new SqlParameter( "@Ended", ended ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Update header record, incrementing records processed 
		/// and updating ended date for specified batch ID
		/// </summary>
		/// <param name="batchId">Batch ID</param>
		/// <param name="ended">Date ended</param>
		/// <returns></returns>
		public static DataSet UpdateEdiTransactionProcessingHeader( int batchId, DateTime ended )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiTransactionProcessingHeaderUpdate";

					cmd.Parameters.Add( new SqlParameter( "@BatchId", batchId ) );
					cmd.Parameters.Add( new SqlParameter( "@Ended", ended ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Insert EDI transaction detail record
		/// </summary>
		/// <param name="key814">814 key</param>
		/// <param name="outcome">Result of process (enumerated value)</param>
		/// <param name="message">Any error message, etc.</param>
		/// <param name="batchId">Batch ID of process</param>
		/// <returns></returns>
		public static DataSet InsertEdiTransactionProcessingDetail(int key814, int outcome, string message, int batchId)
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiTransactionProcessingDetailInsert";

					cmd.Parameters.Add( new SqlParameter( "@Key814", key814 ) );
					cmd.Parameters.Add( new SqlParameter( "@Outcome", outcome ) );
					cmd.Parameters.Add( new SqlParameter( "@Message", message ) );
					cmd.Parameters.Add( new SqlParameter( "@BatchId", batchId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets unprocessed 814 transactions for accepted enrollment, reenrollment, 
		/// and deenrollment responses.
		/// </summary>
		/// <param name="key814"></param>
		/// <returns></returns>
		public static DataSet GetUnprocessed814Transactions( int key814 )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_Unprocessed814TransactionsSelect";

					cmd.Parameters.Add( new SqlParameter( "@Key814", key814 ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );

					ds.Tables[0].TableName = "Header";
					ds.Tables[1].TableName = "Service";
				}
			}
			return ds;
		}

		/// <summary>
		/// Get pertinent transaction status'
		/// </summary>
		/// <returns>Returns a DataSet containing pertinent transaction status'</returns>
		public static DataSet SelectEdiTransactionStatus(  )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiTransactionStatusSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
	}
}
