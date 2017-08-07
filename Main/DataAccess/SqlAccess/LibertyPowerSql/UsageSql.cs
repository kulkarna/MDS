using System;
using System.Data;
using System.Linq;
using System.Collections;
using System.Text;
using System.Collections.Generic;
using System.Data.SqlClient;



namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	/// <summary>
	/// Data related methods for usage
	/// </summary>
	public static class UsageSql
	{

		////////////////////////////////////////////////////////////////////////////////////////////////////////// 
		#region " Shared Functions"

		public static DataSet GetUsageSourcePriorities()
		{
			DataSet ds1 = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using(SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetUsageSourcePriorities";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds1 );
					}
				}
			}
			return ds1;
		}

		/// <summary>
		/// Retrieves usage from the consolidated Usage table
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>/// 
		/// <returns></returns>
		public static DataSet GetConsolidatedUsageByOffer( string offerID, string utilityCode, DateTime from, DateTime to )
		{
			DataSet ds1 = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetConsolidatedUsageByOffer";

					cmd.Parameters.Add( new SqlParameter( "OfferID", offerID ) );
					cmd.Parameters.Add( new SqlParameter( "utilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "beginDate", from ) );
					cmd.Parameters.Add( new SqlParameter( "endDate", to ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds1 );
					}
				}
			}
			return ds1;
		}


		/// <summary>
		/// Retrieves usage from the consolidated Usage table
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>/// 
		/// <returns></returns>
		public static DataSet GetConsolidatedUsage( string accountNumber, string utilityCode, DateTime from, DateTime to )
		{
			DataSet ds1 = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetConsolidatedUsage";

					cmd.Parameters.Add( new SqlParameter( "accountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "utilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "beginDate", from ) );
					cmd.Parameters.Add( new SqlParameter( "endDate", to ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds1 );
					}
				}
			}
			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/*
				/// <summary>
				/// Gets all usage records from consolidated table, including any estimated usage
				/// </summary>
				/// <param name="accountNumber">Account identifier</param>
				/// <returns>Returns a DataSet containing all usage records from consolidated table, including any estimated usage.</returns>
				public static DataSet GetConsolidatedUsageComplete( string accountNumber )
				{
					DataSet ds = new DataSet();

					using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
					{
						using( SqlCommand cmd = new SqlCommand() )
						{
							cmd.Connection = conn;
							cmd.CommandType = CommandType.StoredProcedure;
							cmd.CommandText = "usp_GetAccountUsageComplete";

							cmd.Parameters.Add( new SqlParameter( "accountNumber", accountNumber ) );

							using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
								da.Fill( ds );
						}
					}
					return ds;
				}
		*/
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <param name="utilityCode"></param>
		/// <param name="loadShapeId"></param>
		/// <param name="start"></param>
		/// <param name="end"></param>
		/// <returns></returns>
		public static DataSet GetPeakProfiles( string utilityCode, string loadShapeId, DateTime start, DateTime end )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetPeakProfileByUtilityProfile";

					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "LoadShapeId", loadShapeId ) );
					cmd.Parameters.Add( new SqlParameter( "BeginDate", start ) );
					cmd.Parameters.Add( new SqlParameter( "EndDate", end ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}

			return ds;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="beginDate">Begin date</param>
		/// <param name="endDate">End date</param>
		/// <returns>Returns a dataset containing the peak and off-peak hours for market and date range.</returns>
		public static DataSet GetPeakOffPeakHours( DateTime beginDate, DateTime endDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetPeakOffPeakHours";

					cmd.Parameters.Add( new SqlParameter( "BeginDate", beginDate ) );
					cmd.Parameters.Add( new SqlParameter( "EndDate", endDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}

			return ds;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="marketCode">Market identifier</param>
		/// <param name="beginDate">Begin date</param>
		/// <param name="endDate">End date</param>
		/// <returns>Returns a dataset containing the peak and off-peak hours for market and date range.</returns>
		public static DataSet GetPeakOffPeakHoursByMarket( string marketCode, DateTime beginDate, DateTime endDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PeakOffPeakHoursByMarketSelect";

					cmd.Parameters.Add( new SqlParameter( "MarketCode", marketCode ) );
					cmd.Parameters.Add( new SqlParameter( "BeginDate", beginDate ) );
					cmd.Parameters.Add( new SqlParameter( "EndDate", endDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}

			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Inserts errors from the Calculate Annual Usage logic
		/// </summary>
		/// <param name="nameSpace"></param>
		/// <param name="method"></param>
		/// <param name="errorNumber"></param>
		/// <param name="errorMessage"></param>
		/// <param name="comment"></param>
		/// <param name="createdBy"></param>
		/// <returns>The ID of the inserted record</returns>
		public static int InsertAuditUsageUsedLog( string nameSpace, string method, string errorMessage, string comment, string createdBy )
		{
			int id;

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_AuditUsageUsedLogInsert";

					cmd.Parameters.Add( new SqlParameter( "nameSpace", nameSpace ) );
					cmd.Parameters.Add( new SqlParameter( "method", method ) );
					//					cmd.Parameters.Add( new SqlParameter( "errorNumber", errorNumber ) );
					cmd.Parameters.Add( new SqlParameter( "errorMessage", errorMessage ) );
					cmd.Parameters.Add( new SqlParameter( "comment", comment ) );
					cmd.Parameters.Add( new SqlParameter( "createdBy", createdBy ) );

					conn.Open();
					id = int.Parse( cmd.ExecuteScalar().ToString() );
				}
			}
			return id;
		}


		// ------------------------------------------------------------------------------------
		public static DataSet InsertEstimatedUsage( string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate,
		int? totalKwh, int? daysUsed, string meterNumber, int usageType, string userName )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_InsertEstimatedUsage";

					cmd.Parameters.Add( new SqlParameter( "AccountNumber", accountNumber.Trim() ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode.ToUpper().Trim() ) );
					cmd.Parameters.Add( new SqlParameter( "MeterNumber", meterNumber ?? "" ) );
					cmd.Parameters.Add( new SqlParameter( "FromDate", fromDate ) );
					cmd.Parameters.Add( new SqlParameter( "ToDate", toDate ) );
					cmd.Parameters.Add( new SqlParameter( "TotalKwh", totalKwh ) );
					cmd.Parameters.Add( new SqlParameter( "DaysUsed", daysUsed ) );
					cmd.Parameters.Add( new SqlParameter( "UserName", userName ) );
					cmd.Parameters.Add( new SqlParameter( "UsageType", usageType ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet InsertEstimatedUsage( string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate,
		int? totalKwh, int? daysUsed, string meterNumber, string userName )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_InsertEstimatedUsage";

					cmd.Parameters.Add( new SqlParameter( "AccountNumber", accountNumber.Trim() ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode.ToUpper().Trim() ) );
					cmd.Parameters.Add( new SqlParameter( "MeterNumber", meterNumber ?? "" ) );
					cmd.Parameters.Add( new SqlParameter( "FromDate", fromDate ) );
					cmd.Parameters.Add( new SqlParameter( "ToDate", toDate ) );
					cmd.Parameters.Add( new SqlParameter( "TotalKwh", totalKwh ) );
					cmd.Parameters.Add( new SqlParameter( "DaysUsed", daysUsed ) );
					cmd.Parameters.Add( new SqlParameter( "UserName", userName ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Inserts a single record into the usage consolidated table
		/// </summary>
		/// <returns></returns>
		public static DataSet InsertConsolidatedUsage( string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate,
				int? totalKwh, int? daysUsed, string meterNumber, decimal? onPeakKwh, decimal? offPeakKwh, decimal? billingDemandKw,
				decimal? monthlyPeakDemandKw, decimal? intermediateKwh, string userName, int usageSource, int usageType, DateTime? modified,
				decimal? monthlyOffPeakDemandKw, Int16 active, Int16 reasonCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_InsertConsolidatedUsage";

					cmd.Parameters.Add( new SqlParameter( "AccountNumber", accountNumber.Trim() ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode.ToUpper().Trim() ) );
					cmd.Parameters.Add( new SqlParameter( "UsageSource", usageSource ) );
					cmd.Parameters.Add( new SqlParameter( "UsageType", usageType ) );
					cmd.Parameters.Add( new SqlParameter( "FromDate", fromDate ) );
					cmd.Parameters.Add( new SqlParameter( "ToDate", toDate ) );
					cmd.Parameters.Add( new SqlParameter( "TotalKwh", totalKwh ) );
					cmd.Parameters.Add( new SqlParameter( "DaysUsed", daysUsed ) );
					cmd.Parameters.Add( new SqlParameter( "MeterNumber", meterNumber == null ? "" : (object) meterNumber ) );
					cmd.Parameters.Add( new SqlParameter( "OnPeakKwh", onPeakKwh == null ? DBNull.Value : (object) onPeakKwh ) );
					cmd.Parameters.Add( new SqlParameter( "OffPeakKwh", offPeakKwh == null ? DBNull.Value : (object) offPeakKwh ) );
					cmd.Parameters.Add( new SqlParameter( "BillingDemandKw", billingDemandKw == null ? DBNull.Value : (object) billingDemandKw ) );
					cmd.Parameters.Add( new SqlParameter( "MonthlyPeakDemandKw", monthlyPeakDemandKw == null ? DBNull.Value : (object) monthlyPeakDemandKw ) );
					cmd.Parameters.Add( new SqlParameter( "IntermediateKwh", intermediateKwh == null ? DBNull.Value : (object) intermediateKwh ) );
					cmd.Parameters.Add( new SqlParameter( "MonthlyOffPeakDemandKw", monthlyOffPeakDemandKw == null ? DBNull.Value : (object) monthlyOffPeakDemandKw ) );
					cmd.Parameters.Add( new SqlParameter( "modified", modified == null ? DBNull.Value : (object) modified ) );
					cmd.Parameters.Add( new SqlParameter( "UserName", userName ) );
					cmd.Parameters.Add( new SqlParameter( "active", active ) );
					cmd.Parameters.Add( new SqlParameter( "reasonCode", reasonCode ) );

					//Console.WriteLine( "Raw acct: " + accountNumber + ", Type:" + usageType + ", Begin: " + fromDate + ", End: " + toDate + ", Kwh: " + totalKwh + ", Source: " + usageSource );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Updates a record in the usage consolidated table
		/// </summary>
		public static DataSet UpdateConsolidatedUsage( string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate,
		int? totalKwh, int? daysUsed, string meterNumber, decimal? onPeakKwh, decimal? offPeakKwh, decimal? billingDemandKw,
			decimal? monthlyPeakDemandKw, decimal? intermediateKwh, int usageSource, int usageType, DateTime? modified, long? Id,
			decimal? monthlyOffPeakDemandKw, Int16 active, Int16 reasonCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_UpdateConsolidatedUsage";

					cmd.Parameters.Add( new SqlParameter( "id", Id ) );
					cmd.Parameters.Add( new SqlParameter( "AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "UsageSource", usageSource ) );
					cmd.Parameters.Add( new SqlParameter( "UsageType", usageType ) );
					cmd.Parameters.Add( new SqlParameter( "FromDate", fromDate ) );
					cmd.Parameters.Add( new SqlParameter( "ToDate", toDate ) );
					cmd.Parameters.Add( new SqlParameter( "TotalKwh", totalKwh ) );
					cmd.Parameters.Add( new SqlParameter( "DaysUsed", daysUsed ) );
					cmd.Parameters.Add( new SqlParameter( "MeterNumber", meterNumber == null ? DBNull.Value : (object) meterNumber ) );
					cmd.Parameters.Add( new SqlParameter( "OnPeakKwh", onPeakKwh == null ? DBNull.Value : (object) onPeakKwh ) );
					cmd.Parameters.Add( new SqlParameter( "OffPeakKwh", offPeakKwh == null ? DBNull.Value : (object) offPeakKwh ) );
					cmd.Parameters.Add( new SqlParameter( "BillingDemandKw", billingDemandKw == null ? DBNull.Value : (object) billingDemandKw ) );
					cmd.Parameters.Add( new SqlParameter( "MonthlyPeakDemandKw", monthlyPeakDemandKw == null ? DBNull.Value : (object) monthlyPeakDemandKw ) );
					cmd.Parameters.Add( new SqlParameter( "IntermediateKwh", intermediateKwh == null ? DBNull.Value : (object) intermediateKwh ) );
					cmd.Parameters.Add( new SqlParameter( "MonthlyOffPeakDemandKw", monthlyOffPeakDemandKw == null ? DBNull.Value : (object) monthlyOffPeakDemandKw ) );
					cmd.Parameters.Add( new SqlParameter( "modified", modified == null ? DateTime.Now : (object) modified ) );
					cmd.Parameters.Add( new SqlParameter( "active", active ) );
					cmd.Parameters.Add( new SqlParameter( "reasonCode", reasonCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts association between an offer account and usage record.
		/// </summary>
		/// <param name="offerAccountsId">Identifier for an offer account</param>
		/// <param name="usageId">Identifier for a usage record</param>
		public static void InsertOfferUsageMapping( Int64 offerAccountsId, Int64? usageId, int usageType )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_OfferUsageMappingInsert";

					cmd.Parameters.Add( new SqlParameter( "@OfferAccountsId", offerAccountsId ) );
					cmd.Parameters.Add( new SqlParameter( "@UsageId", usageId ) );
					cmd.Parameters.Add( new SqlParameter( "@UsageType", usageType ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

        public static void BulkRunOfferEngineSqlScript(string script)
        {
            
            using (var conn = new SqlConnection(Helper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = conn;

                    var lines = script.Split("\n".ToCharArray());
                    if (lines.Length < 1)
                        return;

                    const int jobSize = 500;

                    var numJobs = (int)((double)lines.Length / (double) jobSize) + 1;

                    var commandCollection = new List<string>(lines);
                    
                    for(var j=0;j<numJobs;j++)
                    {
                        var sb =new StringBuilder();
                        for(var i=0; i < (commandCollection.Count < jobSize ? commandCollection.Count : jobSize); i++)
                        {
                            sb.Append(commandCollection[i]);
                            sb.Append("\n");
                        }
                        commandCollection.RemoveRange(0, commandCollection.Count < jobSize ? commandCollection.Count : jobSize);
                        if (sb.ToString().Trim().Length > 0)
                        {
                            cmd.CommandType = CommandType.Text;
                            cmd.CommandText = sb.ToString();
                            if(!(conn.State == ConnectionState.Open))
                                conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                        
                    }
                }
            }
        }

		/// <summary>
		/// Deletes association between an offer and usage records.
		/// </summary>
		/// <param name="offerId">Identifier for offer</param>
		public static void DeleteOfferUsageMapping( string offerId )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_OfferUsageMappingDelete";

					cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Inserts records into the AuditUsageUsed table in order to log meter reads used (snapshot)
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="rowId"></param>
		/// <param name="triggeringEvent"></param>
		/// <param name="user"></param>
		public static void MapUsageUsedPerAccount( string accountNumber, long? rowId, string triggeringEvent, string user, string dealId )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AuditUsageUsed";

					cmd.Parameters.Add( new SqlParameter( "@accountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@rowId", rowId ) );
					cmd.Parameters.Add( new SqlParameter( "@triggeringEvent", triggeringEvent ) );
					cmd.Parameters.Add( new SqlParameter( "@createdBy", user ) );
					cmd.Parameters.Add( new SqlParameter( "@created", dealId ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Remaps association between an offer and usage records.
		/// </summary>
		/// <param name="offerId">Identifier for offer</param>
		public static void RemapOfferUsage( string offerId )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_OfferUsageRemap";

					cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Deletes association between an offer account and usage records.
		/// </summary>
		/// <param name="offerId">Identifier for offer</param>
		/// <param name="accountNumber">Identifier for account</param>
		public static void DeleteOfferAccountUsageMapping( string offerId, string accountNumber )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_OfferAccountUsageMappingDelete";

					cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Retrieves the inputs from the pricing request used to generate the offer based on a given offer id
		/// </summary>
		/// <param name="offerId"></param>
		/// <returns>Dataset containing offer details</returns>
		public static DataSet GetDetailsPerOffer( string offerId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetDetailsPerOffer";

					cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}

			return ds;
		}

		/// <summary>
		/// Gets mapped usage for an offer account
		/// </summary>
		/// <param name="offerId">Identifier for offer</param>
		/// <param name="accountNumber">Identifier for account</param>
		/// <returns>DataSet containing usage records</returns>
		public static DataSet GetOfferAccountMappedUsage( string offerId, string accountNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_OfferAccountMappedUsageSelect";

					cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}

			return ds;
		}

		/// <summary>
		/// Gets mapped usage for an offer
		/// </summary>
		/// <param name="offerId">Identifier for offer</param>
		/// <returns>Returns a DataSet containing usage records</returns>
		public static DataSet GetOfferMappedUsage( string offerId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_OfferMappedUsageSelect";

					cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}

			return ds;
		}


		/// <summary>
		/// Insert a forecast daily usage header record.
		/// </summary>
		/// <param name="offerId">Identifier for offer</param>
		/// <param name="accountNumber">Identifier for account</param>
		/// <param name="created">User</param>
		/// <param name="createdBy">Date of record insert</param>
		/// <returns>Returns a DataSet containing a forecast daily usage header ID.</returns>
		public static DataSet InsertForecastDailyUsageHeader( string offerId, string accountNumber,
			DateTime created, string createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_ForecastDailyUsageHeaderInsert";

					cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@Created", created ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Insert a forecast daily usage detail record.
		/// </summary>
		/// <param name="dailyUsageId">Header record ID</param>
		/// <param name="date">Date of daily usage</param>
		/// <param name="kwh">KWH of daily usage</param>
		public static void InsertForecastDailyUsageDetail( int dailyUsageId, DateTime date, decimal kwh )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_ForecastDailyUsageDetailInsert";

					cmd.Parameters.Add( new SqlParameter( "@DailyUsageId", dailyUsageId ) );
					cmd.Parameters.Add( new SqlParameter( "@Date", date ) );
					cmd.Parameters.Add( new SqlParameter( "@Kwh", kwh ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Insert a forecast monthly usage header record.
		/// </summary>
		/// <param name="offerId">Identifier for offer</param>
		/// <param name="accountNumber">Identifier for account</param>
		/// <param name="created">User</param>
		/// <param name="createdBy">Date of record insert</param>
		/// <returns>Returns a DataSet containing a forecast monthly usage header ID.</returns>
		public static DataSet InsertForecastMonthlyUsageHeader( string offerId, string accountNumber,
			DateTime created, string createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_ForecastMonthlyUsageHeaderInsert";

					cmd.Parameters.Add( new SqlParameter( "@OfferId", offerId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@Created", created ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts Detailed Forecasted Monthly Usage
		/// </summary>
		/// <param name="monthlyUsageId"></param>
		/// <param name="accountNumber"></param>
		/// <param name="utilityCode"></param>
		/// <param name="usageSource"></param>
		/// <param name="usageType"></param>
		/// <param name="fromDate"></param>
		/// <param name="toDate"></param>
		/// <param name="totalKwh"></param>
		/// <param name="daysUsed"></param>
		/// <param name="created"></param>
		/// <param name="createdBy"></param>
		/// <param name="modified"></param>
		/// <param name="modifiedBy"></param>
		/// <param name="meterNumber"></param>
		/// <param name="onPeakKwh"></param>
		/// <param name="offPeakKwh"></param>
		/// <param name="billingDemnadKw"></param>
		/// <param name="monthlyPeakDemandKw"></param>
		/// <param name="currentCharges"></param>
		/// <param name="comments"></param>
		/// <param name="tdspCharges"></param>
		/// <param name="usageId"></param>
		/// <param name="isConsolidated"></param>
		public static void InsertForecastMonthlyUsageDetail( int monthlyUsageId, string accountNumber,
			string utilityCode, int usageSource, int usageType, DateTime? fromDate, DateTime? toDate,
			int totalKwh, int daysUsed, DateTime? created, string createdBy, DateTime? modified,
			string modifiedBy, string meterNumber, decimal? onPeakKwh, decimal? offPeakKwh,
			decimal? billingDemnadKw, decimal? monthlyPeakDemandKw, decimal? currentCharges, string comments,
			decimal? tdspCharges, int usageId, int isConsolidated )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_ForecastMonthlyUsageDetailInsert";

					cmd.Parameters.Add( new SqlParameter( "@MonthlyUsageId", monthlyUsageId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "@UsageSource", usageSource ) );
					cmd.Parameters.Add( new SqlParameter( "@UsageType", usageType ) );
					cmd.Parameters.Add( new SqlParameter( "@FromDate", fromDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ToDate", toDate ) );
					cmd.Parameters.Add( new SqlParameter( "@TotalKwh", totalKwh ) );
					cmd.Parameters.Add( new SqlParameter( "@DaysUsed", daysUsed ) );
					cmd.Parameters.Add( new SqlParameter( "@Created", created ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
					cmd.Parameters.Add( new SqlParameter( "@Modified", modified ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@MeterNumber", meterNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@OnPeakKwh", onPeakKwh ) );
					cmd.Parameters.Add( new SqlParameter( "@OffPeakKwh", offPeakKwh ) );
					cmd.Parameters.Add( new SqlParameter( "@BillingDemandKw", billingDemnadKw ) );
					cmd.Parameters.Add( new SqlParameter( "@MonthlyPeakDemandKw", monthlyPeakDemandKw ) );
					cmd.Parameters.Add( new SqlParameter( "@CurrentCharges", currentCharges ) );
					cmd.Parameters.Add( new SqlParameter( "@Comments", comments ) );
					//					cmd.Parameters.Add( new SqlParameter( "@TransactionNumber", transactionNbr ) );
					cmd.Parameters.Add( new SqlParameter( "@TdspCharges", tdspCharges ) );
					cmd.Parameters.Add( new SqlParameter( "@UsageId", usageId ) );
					cmd.Parameters.Add( new SqlParameter( "@IsConsolidated", isConsolidated ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}


		/// <summary>
		/// Get the sum and count of all the historical metered reads per account, per year
		/// </summary>
		/// <param name="UtilityID">Utility ID value</param>
		/// <param name="AccountTypeId"></param>
		/// <param name="isCustom">0= non custom deals, 1= custom deals</param>
		/// <param name="UsageTypeBilled">1= Billed Usage</param>
		/// <param name="UsageTypeHist">2= Historical Usage</param>
		/// <param name="Category">FIXED</param>
		/// <param name="UsageStartDate">min date of the usage we need to include in the proxy calculation</param>
		/// <param name="UsageEndDate">max date of the usage we need to include in the proxy calculation</param>
		/// <returns>List in form of Dataset</returns>
		public static DataSet GetUsageByUtility( int UtilityID,int AccountTypeId,
			Int16 isCustom, int UsageTypeBilled, int UsageTypeHist, string Category, DateTime UsageStartDate, DateTime UsageEndDate )
		{
			DataSet ds1 = new DataSet();


			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandTimeout = 180;
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetUsageByUtility";

					cmd.Parameters.Add( new SqlParameter( "UtilityID", UtilityID ) );
					cmd.Parameters.Add( new SqlParameter( "AccountTypeID", AccountTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "IsCustom", isCustom ) );
					cmd.Parameters.Add( new SqlParameter( "UsageTypeBilled", UsageTypeBilled ) );
					cmd.Parameters.Add( new SqlParameter( "UsageTypeHist", UsageTypeHist ) );
					cmd.Parameters.Add( new SqlParameter( "Category", Category ) );
					cmd.Parameters.Add( new SqlParameter( "DateUsageStart", UsageStartDate ) );
					cmd.Parameters.Add( new SqlParameter( "DateUsageEnd", UsageEndDate ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds1 );
					}
				}
			}
			return ds1;
		}

        /// <summary>
        /// Gets the date of the most recent EDI usage, if any, for the specified account
        /// </summary>
        /// <param name="utilityCode"></param>
        /// <param name="accountNumber"></param>
        /// <returns></returns>
        public static DataSet GetEdiUsageMostRecentDate(string utilityCode, string accountNumber)
        {
            var ds = new DataSet();

            using (var cn = new SqlConnection(Helper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_UsageGetMostRecentEdiDate";
                    cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (var da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
		#endregion

		public static DataSet CheckAuditUsageUsed( string accountNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CheckAuditUsageUsed";

					cmd.Parameters.Add( new SqlParameter( "p_account_number", accountNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

        public static DataSet Usp_GetAnnualUsage(DataTable  usageTable)
        {
            DataSet ds = new DataSet();
            try
            {
                using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = conn;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Usp_GetAnnualUsage";

                        cmd.Parameters.Add(new SqlParameter("@ListUsageList", usageTable));

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(ds);
                        }
                    }
                }
            }
            catch (Exception ex) { throw; }
            return ds;
        }






        /// <summary>
        /// Inserts the Summarized Data into IDRSummarized
        /// </summary>
        /// <param name="accountNumber">Identifier for an  account</param>
        /// <param name="utilityCode">Identifier for a utility</param>
        public static DataSet PerformSummarization(string accountNumber, string utilityCode, DateTime from, DateTime to)
        {

            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Usp_GetIDRAnnualUsage";
                    cmd.Parameters.Add(new SqlParameter("@AccountNo", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@From", from));
                    cmd.Parameters.Add(new SqlParameter("@To", to));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }

                    return ds;
                }
            }
        }


 

	}
}
