using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class TimeTrackerTimeSheetEntrySql
	{

		public static int InsertTimeSheetEntry(int taskID, int employeeID, string legacyID, DateTime executedDate, decimal workedHours, string comments)
		{
			int id;
			using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_TimeTrackerTimeSheetEntryInsert";

					command.Parameters.Add(new SqlParameter("TaskID", taskID));
					command.Parameters.Add(new SqlParameter("EmployeeID", employeeID));
					command.Parameters.Add(new SqlParameter("LegacyID", legacyID));
					command.Parameters.Add(new SqlParameter("ExecutedDate", executedDate));
					command.Parameters.Add(new SqlParameter("WorkedHours", workedHours));
					command.Parameters.Add(new SqlParameter("comments", comments));

					connection.Open();
					id = int.Parse( command.ExecuteScalar().ToString());
				}
			}
			return id;
		}

		public static int UpdateTimeSheetEntry(int id, string legacyID, decimal workedHours, string comments)
		{
			using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_TimeTrackerTimeSheetEntryUpdate";

					command.Parameters.Add(new SqlParameter("ID", id));
					command.Parameters.Add(new SqlParameter("LegacyID", legacyID));
					command.Parameters.Add(new SqlParameter("WorkedHours", workedHours));
					command.Parameters.Add(new SqlParameter("comments", comments));

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
			return id;
		}

		public static int DeleteTimeSheetEntry(int id)
		{
			using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_TimeTrackerTimeSheetEntryDelete";

					command.Parameters.Add(new SqlParameter("ID", id));

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
			return id;
		}	

	}
}
