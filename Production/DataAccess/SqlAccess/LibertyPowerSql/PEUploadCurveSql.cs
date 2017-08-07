using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public class PEUploadCurveSql
	{
		/// <summary>
		/// Cleans the data into the table
		/// </summary>
		/// <param name="tableName">Table Name</param>		
		public static void CleanTable( string tableName )
		{
			using(SqlConnection conn = new SqlConnection( Helper.ConnectionString ))
			{
				using(SqlCommand cmd = new SqlCommand())
				{
					conn.Open();
					cmd.Connection = conn;
					cmd.CommandType = CommandType.Text;
					cmd.CommandText = "DELETE FROM " + tableName;
					cmd.ExecuteNonQuery();
					conn.Close();
				}
			}			
		}

		/// <summary>
		/// Runs an insert script
		/// </summary>
		/// <param name="script">Script</param>		
		public static void InsertCurves( string script )
		{
			using(SqlConnection conn = new SqlConnection( Helper.ConnectionString ))
			{
				using(SqlCommand cmd = new SqlCommand())
				{
					conn.Open();
					cmd.Connection = conn;
					cmd.CommandType = CommandType.Text;
					cmd.CommandText = script;
					cmd.ExecuteNonQuery();
					conn.Close();
				}
			}			
		}
	}
}
