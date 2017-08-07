namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql
{
	using System;
	using System.Data;
	using System.Data.SqlClient;

	// Changes to Bill Group type by ManojTFS-63739 -3/09/15
	public static class MisoSql
	{

		public static DataSet AmerenAccountInsert( string accountNumber, string customerName, string billGroup, string operatingCompany, string servicePoint,
			string deliveryVoltage, string supplyVoltage, string meterVoltage, string loadShapeId, string currentSupplyGroupAndType,
			string futureSupplyGroupAndType, string serviceClass, DateTime eligibleSwitchDate, string transformationCharge,
			decimal effectivePLC, string createdBy, string meterNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				conn.Open();

				SqlCommandBuilder commandBuilder = new SqlCommandBuilder( conn, "usp_AmerenAccountInsert" );

				commandBuilder.AddParameter( "AccountNumber", accountNumber );
				commandBuilder.AddParameter( "MeterNumber", meterNumber );
				commandBuilder.AddParameter( "CustomerName", customerName );
				commandBuilder.AddParameter( "BillGroup", billGroup );
				commandBuilder.AddParameter( "OperatingCompany", operatingCompany );
				commandBuilder.AddParameter( "ServicePoint", servicePoint );
				commandBuilder.AddParameter( "DeliveryVoltage", deliveryVoltage );
				commandBuilder.AddParameter( "SupplyVoltage", supplyVoltage );
				commandBuilder.AddParameter( "MeterVoltage", meterVoltage );
				commandBuilder.AddParameter( "LoadShapeId", loadShapeId );
				commandBuilder.AddParameter( "CurrentSupplyGroupAndType", currentSupplyGroupAndType );
				commandBuilder.AddParameter( "FutureSupplyGroupAndType", futureSupplyGroupAndType );
				commandBuilder.AddParameter( "ServiceClass", serviceClass );

				if( eligibleSwitchDate != DateTime.MinValue )
					commandBuilder.AddParameter( "EligibleSwitchDate", eligibleSwitchDate );

				commandBuilder.AddParameter( "TransformationCharge", transformationCharge );
				commandBuilder.AddParameter( "EffectivePLC", effectivePLC );
				commandBuilder.AddParameter( "CreatedBy", createdBy );

				using( SqlDataAdapter da = new SqlDataAdapter( commandBuilder.Build() ) )
					da.Fill( ds );
			}

			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static void AmerenUsageInsert( int accountId, DateTime beginDate, DateTime endDate, int days,
			int totalKwh, decimal onPeakKwh, decimal offPeakKwh, decimal onPeakDemandKw, decimal offPeakDemandKw,
			decimal peakReactivePowerKvar, string createdBy )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				conn.Open();

				SqlCommandBuilder commandBuilder = new SqlCommandBuilder( conn, "usp_AmerenUsageInsert" );

				commandBuilder.AddParameter( "accountId", accountId );
				commandBuilder.AddParameter( "BeginDate", beginDate );
				commandBuilder.AddParameter( "EndDate", endDate );
				commandBuilder.AddParameter( "Days", days );
				commandBuilder.AddParameter( "TotalKwh", totalKwh );
				commandBuilder.AddParameter( "OnPeakKwh", onPeakKwh );
				commandBuilder.AddParameter( "OffPeakKwh", offPeakKwh );
				commandBuilder.AddParameter( "OnPeakDemandKw", onPeakDemandKw );
				commandBuilder.AddParameter( "OffPeakDemandKw", offPeakDemandKw );
				commandBuilder.AddParameter( "PeakReactivePowerKvar", peakReactivePowerKvar );
				commandBuilder.AddParameter( "CreatedBy", createdBy );

				using( SqlCommand cmd = commandBuilder.Build() )
				{
					cmd.ExecuteNonQuery();
				}
			}
		}

	}
}
