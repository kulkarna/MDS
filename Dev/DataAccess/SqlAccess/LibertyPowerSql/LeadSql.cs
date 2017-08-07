using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class LeadSql
	{
		public static DataSet GetLeads()
		{
			DataSet ds = new DataSet();

			string connStr = ConfigurationManager.ConnectionStrings["LibertyPower"].ConnectionString;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandText = "usp_LeadSelect";
					command.CommandType = CommandType.StoredProcedure;

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}
	}
}
