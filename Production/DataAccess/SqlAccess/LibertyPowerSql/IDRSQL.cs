using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class IDRSQL
	{
		/// <summary>
		/// Get the latest upload date of the IDR file for the utlitly in question
		/// </summary>
		/// <param name="utilityID">utility ID (IDR_PECO)</param>
		/// <returns></returns>
		public static DateTime IDRAccountsGetUploadDate( string utilityID )
		{
			object uploadObj;
			DateTime uploadDate = DateTime.MinValue;

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_IDRAccountsGetUploadDate";

					command.Parameters.Add( new SqlParameter( "UtilityID", utilityID ) );

					connection.Open();
					uploadObj = command.ExecuteScalar();
					DateTime.TryParse( uploadObj.ToString(), out uploadDate );
				}
			}
			return uploadDate;
		}

		/// <summary>
		/// Run the stored procedure to insert an IDR account into the DB: usp_IDRAccountsUpdate
		/// </summary>
		/// <param name="utilityID">Utility ID (IDR_PECO</param>
		/// <param name="accountNumber">account number</param>
		/// <param name="idrStartDate">IDR start date</param>
		/// <param name="siteUploadDate">date file was uploaded online</param>
		/// <param name="createDate">date account was added to the database</param>
		/// <param name="userName">user adding the data</param>
		/// <returns></returns>
		public static int IDRAccountsUpdate( string utilityID, string accountNumber, DateTime idrStartDate, 
			DateTime siteUploadDate, DateTime createDate, string userName)
		{
			int iRecords = -1;
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_IDRAccountsUpdate";

					command.Parameters.Add( new SqlParameter( "UtilityID", utilityID ) );
					command.Parameters.Add( new SqlParameter( "AccountNumber", accountNumber ) );
					command.Parameters.Add( new SqlParameter( "IDRStartDate", idrStartDate ) );
					command.Parameters.Add( new SqlParameter( "SiteUploadDate", siteUploadDate ) );
					command.Parameters.Add( new SqlParameter( "CreateDate", createDate ) );
					command.Parameters.Add( new SqlParameter( "ModifiedBy", userName ) );

					connection.Open();
					iRecords = command.ExecuteNonQuery();
				}
			}
			return iRecords;
		}

		/// <summary>
		/// Move the IDR accounts for the utility in question to a temp location (it is used while uploading a new file from the site)
		/// </summary>
		/// <param name="utilityID">utility ID (IDR_PECO)</param>
		/// <returns></returns>
		public static int IDRAccountsTempMove( string utilityID )
		{
			int iRecords = -1;
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_IDRAccountsTempMove";

					command.Parameters.Add( new SqlParameter( "UtilityID", utilityID ) );

					connection.Open();
					iRecords = command.ExecuteNonQuery();
				}
			}
			return iRecords;
		}

		/// <summary>
		/// Delete all the accounts from the IDR list for a particular utility
		/// </summary>
		/// <param name="utilityID">utility id (IDR_PECO)</param>
		/// <returns></returns>
		public static int IDRAccountsDelete( string utilityID )
		{
			int iRecords = -1;
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_IDRAccountsDelete";

					command.Parameters.Add( new SqlParameter( "UtilityID", utilityID ) );

					connection.Open();
					iRecords = command.ExecuteNonQuery();
				}
			}
			return iRecords;
		}

		/// <summary>
		/// Delete all the IDR accounts for the utility in question from the temp location (cleaning up purporses)
		/// </summary>
		/// <param name="utilityID">utility ID (IDR_PECO)</param>
		/// <returns></returns>
		public static int IDRAccountsTempDelete( string utilityID )
		{
			int iRecords = -1;
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_IDRAccountsTempDelete";

					command.Parameters.Add( new SqlParameter( "UtilityID", utilityID ) );

					connection.Open();
					iRecords = command.ExecuteNonQuery();
				}
			}
			return iRecords;
		}

		/// <summary>
		/// Insert logging information regarding the upload/insert of new IDR lists
		/// </summary>
		/// <param name="utilityID">utility ID (IDR_PECO)</param>
		/// <param name="logMessage">message to save</param>
		/// <param name="createDate">date added to the database</param>
		/// <returns></returns>
		public static int IDRLogsInsert( string utilityID, string logMessage, DateTime createDate )
		{
			int iRecords = -1;
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_IDRLogsInsert";

					command.Parameters.Add( new SqlParameter( "UtilityID", utilityID ) );
					command.Parameters.Add( new SqlParameter( "LogMessage", logMessage ) );
					command.Parameters.Add( new SqlParameter( "CreateDate", createDate ) );

					connection.Open();
					iRecords = command.ExecuteNonQuery();
				}
			}
			return iRecords;
		}

		/// <summary>
		/// Delete all the logs that were inserted into the table prior to deleteDate
		/// </summary>
		/// <param name="deleteDate">Cutoff date to delete the old logs</param>
		/// <returns>Number of the records deleted</returns>
		public static int IDRLogsDelete( DateTime deleteDate )
		{
			int iRecords = -1;
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_IDRLogsDelete";

					command.Parameters.Add( new SqlParameter( "Date", deleteDate ) );

					connection.Open();
					iRecords = command.ExecuteNonQuery();
				}
			}
			return iRecords;
		}

		/// <summary>
		/// Gets the utility code and duns numbers
		/// </summary>
		/// <returns>Returns a dataset containing the utility code and duns numbers.</returns>
		public static DataSet GetServiceConfiguration( string utilityID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IDRServiceConfigurationSelect";
					cmd.Parameters.Add( new SqlParameter( "UtilityID", utilityID ) );

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
