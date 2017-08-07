using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	/// <summary>
	/// Object for insertion and selection of events.
	/// </summary>
	public class LoggerSql
	{
		/// <summary>
		/// Inserts event into database
		/// </summary>
		/// <param name="level">Integer value representing the LogLevel (information, warning, error).</param>
		/// <param name="message">Additional message</param>
		/// <param name="exceptionMessage">Exception message</param>
		/// <param name="exceptionSource">Exception source</param>
		/// <param name="exceptionStackTrace">Exception stack trace</param>
		/// <param name="computer">Computer name</param>
		/// <param name="thread">Thread of event</param>
		/// <param name="username">Username</param>
		/// <param name="dateCreated">Date and time of event</param>
		/// <returns>Returns a dataset containing an integer value representing the record ID of logged event.</returns>
		public static DataSet LogEventInsert( int level, string message, string exceptionMessage,
			string exceptionSource, string exceptionStackTrace, string computer, string thread, 
			string username, DateTime dateCreated )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_LogEventInsert";

					cmd.Parameters.Add( new SqlParameter( "@Level", level ) );
					cmd.Parameters.Add( new SqlParameter( "@Message", message ) );
					cmd.Parameters.Add( new SqlParameter( "@ExceptionMessage", exceptionMessage ) );
					cmd.Parameters.Add( new SqlParameter( "@ExceptionSource", exceptionSource ) );
					cmd.Parameters.Add( new SqlParameter( "@ExceptionStackTrace", exceptionStackTrace ) );
					cmd.Parameters.Add( new SqlParameter( "@Computer", computer ) );
					cmd.Parameters.Add( new SqlParameter( "@Thread", thread ) );
					cmd.Parameters.Add( new SqlParameter( "@Username", username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
	}
}
