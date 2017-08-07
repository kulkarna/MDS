using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class AccountEtfCalculationVariableSql
	{

		public static int InsertAccountEtfCalculationVariable( int etfID, int accountCount, Int64 averageAnnualConsumption )
		{
			int id;
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_AccountEtfCalculationVariableInsert";

					command.Parameters.Add( new SqlParameter( "EtfID", etfID ) );
					command.Parameters.Add( new SqlParameter( "AccountCount", accountCount ) );
					command.Parameters.Add( new SqlParameter( "averageAnnualConsumption", averageAnnualConsumption ) );
				
					connection.Open();
					id = int.Parse( command.ExecuteScalar().ToString() );
				}
			}
			return id;
		}

		public static int UpdateAccountEtfCalculationVariable( int etfCalculationVariableID, int etfID, int accountCount, Int64 averageAnnualConsumption )
		{
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_AccountEtfCalculationVariableUpdate";

					command.Parameters.Add( new SqlParameter( "EtfCalculationVariableID", etfCalculationVariableID ) );
					command.Parameters.Add( new SqlParameter( "EtfID", etfID ) );
					command.Parameters.Add( new SqlParameter( "AccountCount", accountCount ) );
					command.Parameters.Add( new SqlParameter( "averageAnnualConsumption", averageAnnualConsumption ) );

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
			return etfCalculationVariableID;
		}


	}

}
