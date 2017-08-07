namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql
{
	using System;
	using System.Data;
	using System.Data.SqlClient;

	// December 2010
    /// <summary>
    /// // Changes to Bill Group type by ManojTFS-63739 -3/09/15
    /// </summary>
	public static class NeIsoSql
	{

		public static void CmpAccountInsert( string accountNumber, string billGroup, string readCycle, string createdBy )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				conn.Open();

				SqlCommandBuilder commandBuilder = new SqlCommandBuilder( conn, "usp_CmpAccountInsert" );

				commandBuilder.AddParameter( "AccountNumber", accountNumber );
				commandBuilder.AddParameter( "BillGroup", billGroup );
				commandBuilder.AddParameter( "ReadCycle", readCycle );
				commandBuilder.AddParameter( "CreatedBy", createdBy );

				using( SqlCommand cmd = commandBuilder.Build() )
				{
					cmd.ExecuteNonQuery();
				}
			}
		}

		// ------------------------------------------------------------------------------------
		public static void CmpUsageInsert( string accountNumber, decimal highestDemandKw, string rateCode,
			DateTime beginDate, DateTime endDate, int days, string meterNumber, int totalKwh, int totalUnmetered, int totalActiveUnmetered, string createdBy )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				conn.Open();

				SqlCommandBuilder commandBuilder = new SqlCommandBuilder( conn, "usp_CmpUsageInsert" );

				commandBuilder.AddParameter( "AccountNumber", accountNumber );
				commandBuilder.AddParameter( "HighestDemandKw", highestDemandKw );
				commandBuilder.AddParameter( "RateCode", rateCode );
				commandBuilder.AddParameter( "BeginDate", beginDate );
				commandBuilder.AddParameter( "EndDate", endDate );
				commandBuilder.AddParameter( "Days", days );
				commandBuilder.AddParameter( "MeterNumber", meterNumber );
				commandBuilder.AddParameter( "TotalKwh", totalKwh );
				commandBuilder.AddParameter( "TotalUnmetered", totalUnmetered );
				commandBuilder.AddParameter( "TotalActiveUmetered", totalActiveUnmetered );
				commandBuilder.AddParameter( "CreatedBy", createdBy );

				using( SqlCommand cmd = commandBuilder.Build() )
				{
					cmd.ExecuteNonQuery();
				}
			}
		}

	}
}
