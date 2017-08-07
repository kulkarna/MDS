using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	/// <summary>
	/// Gross margin related data methods
	/// </summary>
	public static class GrossMarginSql
	{
		/// <summary>
		/// Get proxy usage for account type
		/// </summary>
		/// <param name="accountType">Account type (RESIDENTIAL, SMB, LCI, etc.)</param>
		/// <returns>Returns a DataSet containing the proxy usage</returns>
		public static DataSet GetGrossMarginUsageProxy( string accountType )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GrossMarginUsageProxySelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountType ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Log error message
		/// </summary>
		/// <param name="accountId">Account identifier</param>
		/// <param name="errorLocation">Where error occurred</param>
		/// <param name="errorMessage">Error message</param>
		/// <param name="errorDate">Date of error</param>
		/// <returns></returns>
		public static DataSet LogError( string accountId, string errorLocation, string errorMessage, DateTime errorDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GrossMarginErrorInsert";

					cmd.Parameters.Add( new SqlParameter( "@AccountId", accountId ) );
					cmd.Parameters.Add( new SqlParameter( "@ErrorLocation", errorLocation ) );
					cmd.Parameters.Add( new SqlParameter( "@ErrorMessage", errorMessage ) );
					cmd.Parameters.Add( new SqlParameter( "@ErrorDate", errorDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
	}


}
