using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class TimeTrackerProjectSql
	{

		public static DataSet GetLoggedProjects(int employeeID, DateTime startDate, DateTime endDate, int applicationID)
		{
			DataSet ds = new DataSet();

			using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_TimeTrackerTimeSheetEntriesSelect";

					command.Parameters.Add(new SqlParameter("EmployeeID", employeeID));
					command.Parameters.Add(new SqlParameter("StartDate", startDate));
					command.Parameters.Add(new SqlParameter("EndDate", endDate));
					command.Parameters.Add(new SqlParameter("ApplicationID", applicationID));

					SqlDataAdapter da = new SqlDataAdapter(command);

					da.Fill(ds);
				}
			}
			return ds;
		}


		public static int UpdateProjectName(int id, string name)
		{
			using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_TimeTrackerProjectUpdate";

					command.Parameters.Add(new SqlParameter("ID", id));
					command.Parameters.Add(new SqlParameter("Name", name));

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
			return id;
		}

		public static int InsertProject(int applicationID, string legacyID, string name)
		{
			int id;
			using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_TimeTrackerProjectInsert";

					command.Parameters.Add(new SqlParameter("ApplicationID", applicationID));
					command.Parameters.Add(new SqlParameter("LegacyID", legacyID));
					command.Parameters.Add(new SqlParameter("Name", name));

					connection.Open();
					id = int.Parse(command.ExecuteScalar().ToString());
				}
			}
			return id;
		}
		
	}
}
