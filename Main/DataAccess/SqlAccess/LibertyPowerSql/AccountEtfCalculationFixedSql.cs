using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class AccountEtfCalculationFixedSql
	{

		public static int InsertAccountEtfCalculationFixed( int etfID, int lostTermDays, int lostTermMonths, float accountRate, float marketRate, int annualUsage, int term, DateTime flowStartDate, int dropMonthIndicator )
		{
			int id;
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_AccountEtfCalculationFixedInsert";

					command.Parameters.Add( new SqlParameter( "EtfID", etfID ) );
					command.Parameters.Add( new SqlParameter( "LostTermDays", lostTermDays ) );
					command.Parameters.Add( new SqlParameter( "LostTermMonths", lostTermMonths ) );
					command.Parameters.Add( new SqlParameter( "AccountRate", accountRate ) );
					command.Parameters.Add( new SqlParameter( "MarketRate", marketRate ) );
					command.Parameters.Add( new SqlParameter( "AnnualUsage", annualUsage ) );
					command.Parameters.Add( new SqlParameter( "Term", term ) );
					command.Parameters.Add( new SqlParameter( "FlowStartDate", flowStartDate ) );
					command.Parameters.Add( new SqlParameter( "DropMonthIndicator", dropMonthIndicator ) );

					connection.Open();
					id = int.Parse( command.ExecuteScalar().ToString() );
				}
			}
			return id;
		}

		public static int UpdateAccountEtfCalculationFixed( int etfCalculationFixedID, int etfID, int lostTermDays, int lostTermMonths, float accountRate, float marketRate, int annualUsage, int term, DateTime flowStartDate, int dropMonthIndicator )
		{
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_AccountEtfCalculationFixedUpdate";

					command.Parameters.Add( new SqlParameter( "EtfCalculationFixedID", etfCalculationFixedID ) );
					command.Parameters.Add( new SqlParameter( "EtfID", etfID ) );
					command.Parameters.Add( new SqlParameter( "LostTermDays", lostTermDays ) );
					command.Parameters.Add( new SqlParameter( "LostTermMonths", lostTermMonths ) );
					command.Parameters.Add( new SqlParameter( "AccountRate", accountRate ) );
					command.Parameters.Add( new SqlParameter( "MarketRate", marketRate ) );
					command.Parameters.Add( new SqlParameter( "AnnualUsage", annualUsage ) );
					command.Parameters.Add( new SqlParameter( "Term", term ) );
					command.Parameters.Add( new SqlParameter( "FlowStartDate", flowStartDate ) );
					command.Parameters.Add( new SqlParameter( "DropMonthIndicator", dropMonthIndicator ) );

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
			return etfCalculationFixedID;
		}


	}

}
