using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class TimeTrackerEmployeeSql
	{

		public static DataSet GetEmployee(string windowsLogon)
		{
			DataSet ds = new DataSet();

			using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_TimeTrackerEmployeeSelect";

					command.Parameters.Add(new SqlParameter("WindowsLogon", windowsLogon));

					SqlDataAdapter da = new SqlDataAdapter(command);

					da.Fill(ds);
				}
			}
			return ds;
		}

		public static DataSet GetAllEmployees()
		{
			DataSet ds = new DataSet();

			using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_TimeTrackerEmployeesSelect";

					SqlDataAdapter da = new SqlDataAdapter(command);

					da.Fill(ds);
				}
			}
			return ds;
		}

	}
}
