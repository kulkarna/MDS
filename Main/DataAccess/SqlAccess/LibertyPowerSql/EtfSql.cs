using System;
using System.Data;
using System.Data.SqlClient;
using LibertyPower.DataAccess;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class EtfSql
	{
		public static DataSet GetEtfWaivedReasonCodes()
		{
			DataSet ds = new DataSet();

			using ( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfWaivedReasonCodeSelect";

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}

			return ds;
		}


		public static DataSet GetEtfMarketRateUtility( DateTime effectiveDateStart, DateTime effectiveDate, string retailMarket, string utility, int term, int dropMonthIndicator, string accountType )
		{
			DataSet ds = new DataSet();

			using ( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfMarketRateUtilitySelect";

					cmd.Parameters.Add( new SqlParameter( "EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "EffectiveDateStart", effectiveDateStart ) );
					cmd.Parameters.Add( new SqlParameter( "RetailMarket", retailMarket ) );
					cmd.Parameters.Add( new SqlParameter( "Utility", utility ) );
					cmd.Parameters.Add( new SqlParameter( "Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "DropMonthIndicator", dropMonthIndicator ) );
					cmd.Parameters.Add( new SqlParameter( "AccountType", accountType ) );

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static DataSet GetEtfMarketRateUtilityZone( DateTime effectiveDateStart, DateTime effectiveDate, string retailMarket, string utility, string zone, int term, int dropMonthIndicator, string accountType )
		{
			DataSet ds = new DataSet();

			using ( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfMarketRateUtilityZoneSelect";

					cmd.Parameters.Add( new SqlParameter( "EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "EffectiveDateStart", effectiveDateStart ) );
					cmd.Parameters.Add( new SqlParameter( "RetailMarket", retailMarket ) );
					cmd.Parameters.Add( new SqlParameter( "Utility", utility ) );
					cmd.Parameters.Add( new SqlParameter( "Zone", zone ) );
					cmd.Parameters.Add( new SqlParameter( "Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "DropMonthIndicator", dropMonthIndicator ) );
					cmd.Parameters.Add( new SqlParameter( "AccountType", accountType ) );

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetEtfMarketRateUtilityZoneServiceClass( DateTime effectiveDateStart, DateTime effectiveDate, string retailMarket, string utility, string zone, string serviceClass, int term, int dropMonthIndicator, string accountType )
		{
			DataSet ds = new DataSet();

			using ( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfMarketRateUtilityZoneServiceClassSelect";

					cmd.Parameters.Add( new SqlParameter( "EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "EffectiveDateStart", effectiveDateStart ) );
					cmd.Parameters.Add( new SqlParameter( "RetailMarket", retailMarket ) );
					cmd.Parameters.Add( new SqlParameter( "Utility", utility ) );
					cmd.Parameters.Add( new SqlParameter( "Zone", zone ) );
					cmd.Parameters.Add( new SqlParameter( "ServiceClass", serviceClass ) );
					cmd.Parameters.Add( new SqlParameter( "Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "DropMonthIndicator", dropMonthIndicator ) );
					cmd.Parameters.Add( new SqlParameter( "AccountType", accountType ) );

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static DataSet GetEtfMarketRateUtilityPricingZoneServiceClass( DateTime effectiveDateStart, DateTime effectiveDate, string retailMarket, string utility, string pricingZoneAndServiceClass, int term, int dropMonthIndicator, string accountType )
		{
			DataSet ds = new DataSet();

			using ( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfMarketRateUtilityPricingZoneServiceClassSelect";

					cmd.Parameters.Add( new SqlParameter( "EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "EffectiveDateStart", effectiveDateStart ) );
					cmd.Parameters.Add( new SqlParameter( "RetailMarket", retailMarket ) );
					cmd.Parameters.Add( new SqlParameter( "Utility", utility ) );
					cmd.Parameters.Add( new SqlParameter( "ZoneAndServiceClass", pricingZoneAndServiceClass ) );
					cmd.Parameters.Add( new SqlParameter( "Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "DropMonthIndicator", dropMonthIndicator ) );
					cmd.Parameters.Add( new SqlParameter( "AccountType", accountType ) );

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Truncates the etf market rate import.
		/// </summary>
		public static void TruncateEtfMarketRateImport( )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfMarketRateImportTruncate";

					cmd.Connection.Open();
					cmd.ExecuteNonQuery();
					cmd.Connection.Close();
				}
			}
		}

		/// <summary>
		/// Inserts the etf market rate record to the import table.
		/// </summary>
		/// <param name="effectiveDate">The effective date.</param>
		/// <param name="marketCode">The market code.</param>
		/// <param name="utilityCode">The utility code.</param>
		/// <param name="zoneCode">The zone code.</param>
		/// <param name="serviceClassCode">The service class code.</param>
		/// <param name="term">The term.</param>
		/// <param name="dropMonthIndicator">The drop month indicator.</param>
		/// <param name="rate">The rate.</param>
		/// <param name="accountTypeCode">The account type code.</param>
		/// <returns></returns>
		public static DataSet InsertEtfMarketRateImport( DateTime effectiveDate, string marketCode, string utilityCode, string zoneCode, string serviceClassCode, int term, int dropMonthIndicator, decimal rate, string accountTypeCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfMarketRateImportInsert";

					cmd.Parameters.Add( new SqlParameter( "@EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@RetailMarket", marketCode ) );
					cmd.Parameters.Add( new SqlParameter( "@Utility", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "@Zone", zoneCode) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClass", serviceClassCode ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@DropMonthIndicator", dropMonthIndicator ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountTypeCode ) );
					cmd.Parameters.Add( new SqlParameter( "@Rate", rate ) );

					cmd.Connection.Open();
					cmd.ExecuteNonQuery();
					cmd.Connection.Close();
				}
			}
			return ds;

		}

		public static DataSet MarketRateDataExistsForEffectiveDate( DateTime effectiveDateStart, DateTime effectiveDate )
		{
			DataSet ds = new DataSet();

			using ( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using ( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfMarketRateDataExistsForEffectiveDate";

					cmd.Parameters.Add( new SqlParameter( "EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "EffectiveDateStart", effectiveDateStart ) );

					using ( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Performs a bulk insert of CrossProductPrices into the AccountEtfMarketRate database.
		/// </summary>
		/// <param name="dataTable">The data table.</param>
		public static void EtfMarketRateImportBulkInsert( DataTable dataTable )
		{
			string connStr = Helper.ConnectionString;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				connection.Open();

				// Set up the bulk copy object. 
				// Note that the column positions in the source data reader match the column positions in 
				// the destination table so there is no need to map columns.
				using( SqlBulkCopy bulkCopy = new SqlBulkCopy( connection ) )
				{
					#region Column Mappings
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "EffectiveDate", "EffectiveDate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "RetailMarket", "RetailMarket" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Utility", "Utility" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Zone", "Zone" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ServiceClass", "ServiceClass" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Term", "Term" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "DropMonthIndicator", "DropMonthIndicator" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Rate", "Rate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "AccountType", "AccountType" ) );
					#endregion

					bulkCopy.BatchSize = 100000;

					bulkCopy.DestinationTableName = "dbo.AccountEtfMarketRateImport";

					bulkCopy.WriteToServer( dataTable );
				}
			}
		}

		/// <summary>
		/// Copies the data from the EtfMarketImportRate table to the EtfMarketRate table
		/// </summary>
		public static void EtfMarketRateBulkInsert()
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountEtfMarketRateBulkInsert";

					cn.Open();
					cmd.ExecuteNonQuery();
					cn.Close();
				}
			}
		}
	}
}
