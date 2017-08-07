using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public class TimeTrackerTaskSql
	{
		public static int UpdateTaskName(int id, string name)
		{
			using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_TimeTrackerTaskUpdate";

					command.Parameters.Add(new SqlParameter("ID", id));
					command.Parameters.Add(new SqlParameter("Name", name));

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
			return id;
		}

		public static int InsertTask(int projectID, string legacyID, string name)
		{
			int id;
			using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_TimeTrackerTaskInsert";

					command.Parameters.Add(new SqlParameter("ProjectID", projectID));
					command.Parameters.Add(new SqlParameter("LegacyID", legacyID));
					command.Parameters.Add(new SqlParameter("Name", name));

					connection.Open();
					id = int.Parse( command.ExecuteScalar().ToString());
				}
			}
			return id;
		}

		public static void DeleteTask(int id)
		{
			using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_TimeTrackerTaskDelete";

					command.Parameters.Add(new SqlParameter("ID", id));

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
		}		
	}
}
