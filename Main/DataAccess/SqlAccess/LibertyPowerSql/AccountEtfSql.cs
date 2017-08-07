using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class AccountEtfSql
	{

		public static DataSet Get(int etfID)
		{
			DataSet ds = new DataSet();

			using ( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfSelect";

					cmd.Parameters.Add( new SqlParameter( "@EtfID", etfID ) );

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static int InsertEtf( int accountID, int etfProcessingStateID, int etfEndStatusID, string errorMessage, decimal? etfAmount, DateTime? deenrollmentDate, bool isEstimated, DateTime calculatedDate, decimal? etfFinalAmount, string lastUpdatedBy, string etfCalculatorType )
		{
			int id;
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_AccountEtfInsert";

					command.Parameters.Add( new SqlParameter( "@AccountID", accountID ) );
					command.Parameters.Add( new SqlParameter( "@EtfProcessingStateID", etfProcessingStateID ) );
					command.Parameters.Add( new SqlParameter( "@EtfEndStatusID", etfEndStatusID ) );

					command.Parameters.Add( new SqlParameter( "@ErrorMessage", (errorMessage == null) ? DBNull.Value : (object) errorMessage ) );
					command.Parameters.Add( new SqlParameter( "@EtfAmount", (etfAmount == null) ? DBNull.Value : (object) etfAmount ) );
					command.Parameters.Add( new SqlParameter( "@DeenrollmentDate", (deenrollmentDate == null) ? DBNull.Value : (object) deenrollmentDate ) );
					command.Parameters.Add( new SqlParameter( "@IsEstimated", isEstimated ) );
					command.Parameters.Add( new SqlParameter( "@CalculatedDate", calculatedDate ) );
					command.Parameters.Add( new SqlParameter( "@EtfFinalAmount", (etfFinalAmount == null) ? DBNull.Value : (object) etfFinalAmount ) );
					command.Parameters.Add( new SqlParameter( "@LastUpdatedBy", lastUpdatedBy ) );
                    command.Parameters.Add( new SqlParameter( "@EtfCalculatorType", (etfCalculatorType == null) ? DBNull.Value : (object) etfCalculatorType ) );

					connection.Open();
					id = int.Parse( command.ExecuteScalar().ToString() );
				}
			}
			return id;
		}

		public static int UpdateEtf( int etfID, int accountID, int etfProcessingStateID, int etfEndStatusID, string errorMessage, decimal? etfAmount, DateTime deenrollmentDate, bool isEstimated, DateTime calculatedDate, decimal? etfFinalAmount, string lastUpdatedBy, string etfCalculatorType )
		{
			using ( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_AccountEtfUpdate";

					command.Parameters.Add( new SqlParameter( "@EtfID", etfID ) );
					command.Parameters.Add( new SqlParameter( "@AccountID", accountID ) );
					command.Parameters.Add( new SqlParameter( "@EtfProcessingStateID", etfProcessingStateID ) );
					command.Parameters.Add( new SqlParameter( "@EtfEndStatusID", etfEndStatusID ) );
					command.Parameters.Add( new SqlParameter( "@ErrorMessage", errorMessage ) );
					command.Parameters.Add( new SqlParameter( "@EtfAmount", (etfAmount == null) ? DBNull.Value : (object) etfAmount ) );
					command.Parameters.Add( new SqlParameter( "@DeenrollmentDate", deenrollmentDate ) );
					command.Parameters.Add( new SqlParameter( "@IsEstimated", isEstimated ) );
					command.Parameters.Add( new SqlParameter( "@CalculatedDate", calculatedDate ) );
                    command.Parameters.Add( new SqlParameter( "@EtfFinalAmount", (etfFinalAmount == null) ? DBNull.Value : (object) etfFinalAmount ) );
					command.Parameters.Add( new SqlParameter( "@LastUpdatedBy", lastUpdatedBy ) );
                    command.Parameters.Add( new SqlParameter( "@EtfCalculatorType", (etfCalculatorType == null) ? DBNull.Value : (object)etfCalculatorType ) );

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
			return etfID;
		}

		public static void DeleteEtf( int etfID)
		{
			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_AccountEtfDelete";

					command.Parameters.Add( new SqlParameter( "@EtfID", etfID ) );

					connection.Open();
					command.ExecuteNonQuery();
				}
			}
		}


	}

}
