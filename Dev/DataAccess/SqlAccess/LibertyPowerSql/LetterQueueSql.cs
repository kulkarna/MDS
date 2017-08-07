using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class LetterQueueSql
	{
		/// <summary>
		/// Gets the Letter Queue.
		/// </summary>
		/// <param name="DocumentTypeId">Id of Documment Type.</param>
		/// <param name="LetterStatus">Status of Letter Queue</param>
		/// <param name="OrderBy">Field to sort the list</param>
		/// <param name="SortAscending">Direction of sorting</param>
		/// <returns></returns>
		public static DataSet GetLetterQueue( int DocumentTypeId, string LetterStatus, string OrderBy, string SortAscending, string ContractNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_LetterQueueSelect";

					command.Parameters.Add( new SqlParameter( "@DocumentTypeId", DocumentTypeId ) );
					command.Parameters.Add( new SqlParameter( "@letterStatus", LetterStatus ) );
					command.Parameters.Add( new SqlParameter( "@ContractNumber", ContractNumber ) );
					command.Parameters.Add( new SqlParameter( "@orderBy", OrderBy ) );
					command.Parameters.Add( new SqlParameter( "@SortAscending", SortAscending ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
						da.Fill( ds );
				}
			}

			return ds;
		}

		public static DataSet GetLetterQueueByAccount_Id( int DocumentTypeId, string Account_Id )
		{
			DataSet ds = new DataSet();
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_LetterQueueSelectByAccount_id";

					command.Parameters.Add( new SqlParameter( "@DocumentTypeId", DocumentTypeId ) );
					command.Parameters.Add( new SqlParameter( "@account_id", Account_Id ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
						da.Fill( ds );
				}
			}

			return ds;
		}

		/// <summary>
		/// Updates the Letter Queue
		/// </summary>
		/// <param name="LetterQueueId">Id of Letter Queue.</param>
		/// <param name="LetterStatus">Status of Letter Queue.</param>
		/// <param name="ScheduledDate">Date that Letter is scheduled to be printed.</param>
		/// <param name="PrintDate">Date that Letter was Printed.</param>
		/// <param name="Username">Username</param>
		/// <returns></returns>
		public static DataSet UpdateLetterQueue( int LetterQueueId, string LetterStatus, string ScheduledDate, string PrintDate, string Username )
		{

			DataSet ds = new DataSet();

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_LetterQueueUpdate";

					command.Parameters.Add( new SqlParameter( "@LetterQueueId", LetterQueueId ) );
					command.Parameters.Add( new SqlParameter( "@LetterStatus", LetterStatus ) );
					command.Parameters.Add( new SqlParameter( "@ScheduledDate", ScheduledDate ) );
					command.Parameters.Add( new SqlParameter( "@PrintDate", (PrintDate != "") ? (object) PrintDate : DBNull.Value ) );
					command.Parameters.Add( new SqlParameter( "@Username", Username ) );


					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
						da.Fill( ds );
				}
			}

			return ds;
		}

		/// <summary>
		/// Inserts Letter Queue into table.
		/// </summary>
		/// <param name="LetterStatus">Status of Letter Queue.</param>
		/// <param name="ContractNumber">Contract Number of account associated.</param>
		/// <param name="AccountID">AccountId of account associated.</param>
		/// <param name="DocumentTypeID">Documment type of Letter.</param>
		/// <param name="ScheduledDate">Date that Letter is scheduled to be printed.</param>
		/// <param name="Username">Username</param>
		/// <returns></returns>
		public static DataSet InsertLetterQueue( string LetterStatus, string ContractNumber, int AccountID, int DocumentTypeID, string ScheduledDate, string Username )
		{

			DataSet ds = new DataSet();
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_LetterQueueInsert";

					command.Parameters.Add( new SqlParameter( "@LetterStatus", LetterStatus ) );
					command.Parameters.Add( new SqlParameter( "@ContractNumber", ContractNumber ) );
					command.Parameters.Add( new SqlParameter( "@AccountID", AccountID ) );
					command.Parameters.Add( new SqlParameter( "@DocumentTypeID", DocumentTypeID ) );
					command.Parameters.Add( new SqlParameter( "@ScheduledDate", ScheduledDate ) );
					command.Parameters.Add( new SqlParameter( "@PrintDate", DBNull.Value ) );
					command.Parameters.Add( new SqlParameter( "@Username", Username ) );


					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
						da.Fill( ds );
				}
			}


			return ds;
		}

		/// <summary>
		/// Removes the Letter Queue of table.
		/// </summary>
		/// <param name="LetterQueueId">Id of Letter Queue</param>
		/// <returns></returns>
		public static DataSet DeleteLetterQueue( int LetterQueueId )
		{
			DataSet ds = new DataSet();
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_LetterQueueDelete";

					command.Parameters.Add( new SqlParameter( "@LetterQueueId", LetterQueueId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
						da.Fill( ds );
				}
			}

			return ds;
		}

		public static DataSet GetPendingLetterQueueDocumentTypeId()
		{

			DataSet ds = new DataSet();
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_LetterQueueScheduledDocumentType";


					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
						da.Fill( ds );
				}
			}

			return ds;
		}
	}
}
