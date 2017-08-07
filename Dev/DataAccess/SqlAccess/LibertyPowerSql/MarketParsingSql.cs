using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	/// <summary>
	/// 
	/// </summary>
	public static class MarketParsingSql
	{
		/// <summary>
		/// Retrieves the minimum field requirements for creating a utility account object for account list parsing 
		/// </summary>
		/// <returns>DataSet</returns>
		public static DataSet GetUtilityAccountSchemas()
		{
			DataSet ds = new DataSet();

			using( SqlConnection selectConnection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand selectCommand = new SqlCommand() )
				{
					selectCommand.Connection = selectConnection;
					selectCommand.CommandType = CommandType.StoredProcedure;
					selectCommand.CommandText = "usp_UtilityAccountSchemasSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( selectCommand ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		public static bool SaveProspectAccount( int serviceAddressID, int billingAddressID, string accountNumber, string billingAccount, string utilityCode, string retailMarketCode,
			string rateClass, string nameKey, string loadProfile, string meterReadCycleId, Guid fileGuid, int createdBy )
		{
			DataSet ds = null;


			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_ProspectAccountInsert";

					command.Parameters.Add( new SqlParameter( "ServiceAddressID", serviceAddressID ) );
					command.Parameters.Add( new SqlParameter( "BillingAddressID", billingAddressID ) );
					command.Parameters.Add( new SqlParameter( "AccountNumber", accountNumber ) );
					command.Parameters.Add( new SqlParameter( "BillingAccount", billingAccount == null ? DBNull.Value : (object) billingAccount ) );
					command.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode == null ? DBNull.Value : (object) utilityCode ) );
					command.Parameters.Add( new SqlParameter( "RetailMarketId", retailMarketCode == null ? DBNull.Value : (object) retailMarketCode ) );
					command.Parameters.Add( new SqlParameter( "RateClass", rateClass == null ? DBNull.Value : (object) rateClass ) );
					command.Parameters.Add( new SqlParameter( "NameKey", nameKey == null ? DBNull.Value : (object) nameKey ) );
					command.Parameters.Add( new SqlParameter( "LoadProfile", loadProfile == null ? DBNull.Value : (object) loadProfile ) );
					command.Parameters.Add( new SqlParameter( "MeterReadCycleID", meterReadCycleId == null ? DBNull.Value : (object) meterReadCycleId ) );
					command.Parameters.Add( new SqlParameter( "DocumentID", fileGuid ) );
					command.Parameters.Add( new SqlParameter( "CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						ds = new DataSet();
						try
						{
							da.Fill( ds );
						}
						catch( Exception e )
						{
							//gobble error and send a solution
							if( e.Message.Contains( "MSDTC" ) )
							{
								MarketParsingSqlException mpe = new MarketParsingSqlException( "MSDTC is required to be running; be sure that the 'Distributed Transaction Coordinator' service is started and set to automatic on all machines involved in this transaction.    Original exception:" + e.Message );
								throw mpe;
							}
							else //bubble up the original error
								throw e;
						}

					}
				}
			}

			return ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0;
		}


		public static bool UpdateProspectAccount( string accountNumber, string utilityCode, string billingAccount, string retailMarketCode,
			string rateClass,	string nameKey, string loadProfile, string meterReadCycleId, int modifiedBy )
		{
			DataSet ds = null;

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_ProspectAccountUpdateEx";


					command.Parameters.Add( new SqlParameter( "AccountNumber", accountNumber ) );
					command.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode));
					command.Parameters.Add( new SqlParameter( "BillingAccount", billingAccount == null ? DBNull.Value : (object) billingAccount ) );
					command.Parameters.Add( new SqlParameter( "RetailMarketId", retailMarketCode == null ? DBNull.Value : (object) retailMarketCode ) );
					command.Parameters.Add( new SqlParameter( "NameKey", nameKey == null ? DBNull.Value : (object) nameKey ) );
					command.Parameters.Add( new SqlParameter( "ModifiedBy", modifiedBy ) );
					command.Parameters.Add( new SqlParameter( "DateModified", DateTime.Now ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						ds = new DataSet();
						try
						{
							da.Fill( ds );
						}
						catch( Exception e )
						{
							//gobble error and send a solution
							if( e.Message.Contains( "MSDTC" ) )
							{
								MarketParsingSqlException mpe = new MarketParsingSqlException( "MSDTC is required to be running; be sure that the 'Distributed Transaction Coordinator' service is started and set to automatic on all machines involved in this transaction.    Original exception:" + e.Message );
								throw mpe;
							}
							else //bubble up the original error
								throw e;
						}

					}
				}
			}

			return ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0;
		}


		public static bool SaveProspectUsage( string utilityCode, string accountNumber, int usageType, int usageSource, DateTime beginDate, DateTime endDate,
																decimal? actualKwH, decimal? meteredKw, decimal? billedKw, decimal? tdspCharges, int createdBy )
		{
			DataSet ds = null;

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_ProspectUsageInsert";

					command.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode == null ? DBNull.Value : (object) utilityCode ) );
					command.Parameters.Add( new SqlParameter( "AccountNumber", accountNumber == null ? DBNull.Value : (object) accountNumber ) );
					command.Parameters.Add( new SqlParameter( "UsageType", usageType ) );
					command.Parameters.Add( new SqlParameter( "UsageSource", usageSource ) );
					command.Parameters.Add( new SqlParameter( "FromDate", beginDate ) );
					command.Parameters.Add( new SqlParameter( "ToDate", endDate ) );
					int daysUsed = ((TimeSpan) (endDate - beginDate)).Days;
					command.Parameters.Add( new SqlParameter( "DaysUsed", daysUsed ) );
					int actual = System.Convert.ToInt32( actualKwH ); //cast to int to conform with expected input type and avoid potential PK violation when amounts don't match from implicit casting
					command.Parameters.Add( new SqlParameter( "ActualKwH", actualKwH == null ? DBNull.Value : (object) actual ) );
					command.Parameters.Add( new SqlParameter( "MeteredKw", meteredKw == null ? DBNull.Value : (object) meteredKw ) );
					command.Parameters.Add( new SqlParameter( "BilledKw", billedKw == null ? DBNull.Value : (object) billedKw ) );
					command.Parameters.Add( new SqlParameter( "TdspCharges", tdspCharges ) );
					command.Parameters.Add( new SqlParameter( "CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						ds = new DataSet();
						da.Fill( ds );
					}
				}
			}

			return ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0;
		}

		public static DataSet LoadUtilityAccountByFileContextGuid( Guid documentID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_ProspectAccountSelect";

					command.Parameters.Add( new SqlParameter( "DocumentID", documentID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		public static DataSet LoadUtilityAccountByUtilityAndAccount( string utilityCode, string accountNumber )
		{
			
			DataSet ds = new DataSet();

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_ProspectAccountSelectByUtilityAndAccount";

					command.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );
					command.Parameters.Add( new SqlParameter( "AccountNumber", accountNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		public static DataSet LoadUtilityAccountByID( long ID )
		{

			DataSet ds = new DataSet();

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_ProspectAccountSelectByID";

					command.Parameters.Add( new SqlParameter( "ID", ID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		public static DataSet LoadUsageByAccountNumber( string accountNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_ProspectUsageSelect";

					command.Parameters.Add( new SqlParameter( "AccountNumber", accountNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		public static DataSet LoadCountiesAndZoneCodesByMarket( string marketID )
		{
			DataSet ds = new DataSet();
			string connString = System.Configuration.ConfigurationManager.ConnectionStrings["OfferEngine"].ConnectionString;
			using( SqlConnection connection = new SqlConnection( connString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_county_zone_xref_by_mkt_sel";

					command.Parameters.Add( new SqlParameter( "p_retail_mkt_id", marketID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						da.Fill( ds );
					}
				}
			}
			
			return ds;
		}

		public static DataSet LoadDefaultZoneCodesByUtility( )
		{
			DataSet ds = new DataSet();
			string connString = System.Configuration.ConfigurationManager.ConnectionStrings["OfferEngine"].ConnectionString;
			using( SqlConnection connection = new SqlConnection( connString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_utility_zone_xref_sel";

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
