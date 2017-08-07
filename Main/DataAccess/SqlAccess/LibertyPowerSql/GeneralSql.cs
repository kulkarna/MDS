using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class GeneralSql
	{
		public static DataSet GetMonths()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_MonthsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetMonthByNumber(int monthNumber)
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_MonthByNumberSelect";

					cmd.Parameters.Add( new SqlParameter( "@MonthNumber", monthNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetYears()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_YearsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets account types
		/// </summary>
		/// <returns>Returns a dataset that contains account types.</returns>
		public static DataSet GetAccountTypes()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountTypesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets an account type for specified identity
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <returns>Returns a dataset that contains an account type for specified identity.</returns>
		public static DataSet GetAccountType(int identity)
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountTypeSelect";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets an account type for specified accountType
		/// </summary>
		/// <param name="accountType">Unique accountType</param>
		/// <returns>Returns a dataset that contains an account type for specified accountType</returns>
		public static DataSet GetAccountType(string accountType)
		{
			var ds = new DataSet();
			using (var conn = new SqlConnection(Helper.ConnectionString))
			{
				using (var cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetAccountTypeEntityByAccountType";

					cmd.Parameters.Add(new SqlParameter("@AccountType", accountType));

					using (var da = new SqlDataAdapter(cmd))
						da.Fill(ds);
				}
			}
			return ds;
		}
	}
}
