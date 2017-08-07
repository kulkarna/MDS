namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	using System;
	using System.Data;
	using System.Data.SqlClient;

	public static class FieldHistoryManagerSql
	{
		public static DataSet FieldValueInsert( string utilityCode, string accountNumber, DateTime effectiveDate, string zoneCode,
			string rateClass, string loadProfile, string voltage, string meterType, string fieldSource, string userIdentity, string fieldLockStatus )
		{
			DataSet ds = new DataSet();

			using( SqlConnection selectConnection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = selectConnection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_Determinants_FieldValueInsertAll";
					command.Parameters.Add( new SqlParameter( "@UtilityID", utilityCode ) );
					command.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					command.Parameters.Add( new SqlParameter( "@EffectiveDate", effectiveDate ) );
					command.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
					command.Parameters.Add( new SqlParameter( "@RateClass", rateClass ) );
					command.Parameters.Add( new SqlParameter( "@LoadProfile", loadProfile ) );
					command.Parameters.Add( new SqlParameter( "@Voltage", voltage ) );
					command.Parameters.Add( new SqlParameter( "@MeterType", meterType ) );
					command.Parameters.Add( new SqlParameter( "@FieldSource", fieldSource ) );
					command.Parameters.Add( new SqlParameter( "@UserIdentity", userIdentity ) );
					command.Parameters.Add( new SqlParameter( "@LockStatus", fieldLockStatus ) );

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
