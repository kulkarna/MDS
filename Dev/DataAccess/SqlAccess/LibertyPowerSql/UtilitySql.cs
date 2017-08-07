using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	/// <summary>
	/// Handles utility related data
	/// </summary>
	[Serializable]
	public static class UtilitySql
	{
		/// <summary>
		/// Gets the number of days lead time required for consolidated billing notification.
		/// If no record is found, returns 0 days.
		/// </summary>
		/// <param name="utilityCode">Identifier for utility</param>
		/// <returns>Number of days lead time required for consolidated billing notification.</returns>
		public static DataSet SelectUtilityLeadTime( string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityConsolidatedLeadTimeSelect";

					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Get records for utility and load shape id that have Icap dates within the date range
		/// </summary>
		/// <param name="utilityCode">Identifier for utility</param>
		/// <param name="loadShapeId">Load Shape ID</param>
		/// <param name="beginDate">Minimum of date range</param>
		/// <param name="endDate">Maximum of date range</param>
		/// <returns>Icap fcators that have dates within the date range</returns>
		public static DataSet SelectIcapFactors( string utilityCode, string loadShapeId,
												DateTime beginDate, DateTime endDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IcapFactorsSelect";

					cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "@LoadShapeId", loadShapeId ) );
					cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
					cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

        
		/// <summary>
		/// Gets the markets that do not have icap factor calculations
		/// </summary>
		/// <returns>DataSet containing retail market ids and icap and tcap exemptions</returns>
		public static DataSet SelectCapsMarketExemptions()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IcapFactorMarketExemptionsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static void CreateUtilityCache( DataSet ds )
		{
			if( HttpContext.Current != null ) //check if data is cached already
			{
				string name = "UtilityCache";
				if( HttpContext.Current.Cache.Get( name ) == null && ds != null )
				{
					var dsCache = ds.Copy();
					HttpContext.Current.Cache.Add( name, dsCache, null, DateTime.Now + TimeSpan.FromMinutes( 10 ),
												  System.Web.Caching.Cache.NoSlidingExpiration,
												  System.Web.Caching.CacheItemPriority.Default, null );
				}
			}
		}

		public static DataSet RetrieveUtilityCacheIfExists()
		{
			if( HttpContext.Current != null ) //check if data is cached already
			{
				var ds = HttpContext.Current.Cache.Get( "UtilityCache" ) as DataSet;
				return ds != null ? ds.Copy() : null;
			}
			return null;
		}

		public static DataSet GetUtility( string utilityCode )
		{
			Int32 its = 0;
			Int32 maxIts;
			var dsCache = RetrieveUtilityCacheIfExists();
			if( dsCache != null && dsCache.Tables.Count > 0 && dsCache.Tables[0].Rows.Count > 0 )
			{
				its = 0;
				maxIts = dsCache.Tables[0].Rows.Count;
				while( dsCache.Tables[0].Rows.Count > 1 && its++ < maxIts )
				{
					var rowTop = dsCache.Tables[0].Rows[0];
					var rowLast = dsCache.Tables[0].Rows[dsCache.Tables[0].Rows.Count - 1];
					if( rowTop["UtilityCode"].ToString().Trim().Equals( utilityCode.Trim() ) == false )
						dsCache.Tables[0].Rows.Remove( rowTop );
					if( rowLast["UtilityCode"].ToString().Trim().Equals( utilityCode.Trim() ) == false )
						dsCache.Tables[0].Rows.Remove( rowLast );
				}
				return dsCache;
			}

			var ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilitySelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}

			CreateUtilityCache( ds );

			if( ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				its = 0;
				maxIts = ds.Tables[0].Rows.Count;

				while( ds.Tables[0].Rows.Count > 1 && its++ < maxIts )
				{
					var rowTop = ds.Tables[0].Rows[0];
					var rowLast = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1];
					if( rowTop["UtilityCode"].ToString().Trim().Equals( utilityCode.Trim() ) == false )
						ds.Tables[0].Rows.Remove( rowTop );
					if( rowLast["UtilityCode"].ToString().Trim().Equals( utilityCode.Trim() ) == false )
						ds.Tables[0].Rows.Remove( rowLast );
				}
			}


			return ds;
		}

		public static DataSet GetUtility( int utilityId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityByIdSelect";

					cmd.Parameters.Add( new SqlParameter( "@UtilityId", utilityId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Retrieves list of utilities based on wholesale market id (i.e. NEISO, PJM, etc.)
		/// </summary>
		/// <param name="marketIdentity"></param>
		/// <returns></returns>
		public static DataSet GetUtilitiesByWholesaleMarketId( int marketIdentity )
		{
			DataSet ds = new DataSet();

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = connection;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilitySelect";
					cmd.Parameters.Add( new SqlParameter( "@WholesaleMktId", marketIdentity ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetUtilitiesByMarket( string marketCode )
		{
			return GetUtilitiesByMarket( marketCode, null );
		}

		public static DataSet GetUtilitiesByMarket( string marketCode, string utilityCodeList )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityByMarketCodeSelect";

					cmd.Parameters.Add( new SqlParameter( "@MarketCode", marketCode ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityCodeList", utilityCodeList ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetUtilityList()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEUtilitySelectList";
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets row and field delimiters for Edi files.
		/// </summary>
		/// <returns>Returns a dataset containing the row and field delimiters for Edi files.</returns>
		public static DataSet SelectUtilityFileDelimiters()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityFileDelimitersSelect";
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the utility code and duns numbers
		/// </summary>
		/// <returns>Returns a dataset containing the utility code and duns numbers.</returns>
		public static DataSet SelectUtilityDuns()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityDunsSelect";
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the utility code and duns numbers
		/// </summary>
		/// <param name="dunsNumber">duns number</param>
		/// <returns>Returns a dataset containing the utility code and duns numbers.</returns>
		public static DataSet SelectUtilityDuns( string dunsNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "[usp_UtilitySelectByDuns]";
					cmd.Parameters.Add( new SqlParameter( "@Duns", dunsNumber ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Get the value for isIDR_EDI_Capable
		/// </summary>
		/// <param name="utilityCode">utility code</param>
		/// <returns>True if isIDR_EDI_Capable=1</returns>
		public static bool IsUtilityIdrEdiCapable( string utilityCode )
		{
			bool isIDR = false;

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				conn.Open();
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityIdrEdiSelect";

					cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
					bool.TryParse( cmd.ExecuteScalar().ToString(), out isIDR );
				}
				conn.Close();
			}
			return isIDR;
		}

		/// <summary>
		/// Gets the utility billing types
		/// </summary>
		/// <param name="utilityCode">utilityCode</param>
		/// <returns>Returns a dataset containing the utility billing types.</returns>
		public static DataSet SelectUtilityBillingTypes( string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityBillingTypeSelect";
					cmd.Parameters.Add( new SqlParameter( "@Utility", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

        /// <summary>
        /// Gets the utility billing types
        /// </summary>
        /// <param name="utilityId">utilityCode</param>
        /// <returns>Returns a dataset containing the utility billing types.</returns>
        public static DataSet SelectUtilityBillingTypes(int utilityId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_UtilityBillingTypeSelectByUtilityId";
                    cmd.Parameters.Add(new SqlParameter("@UtilityId", utilityId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

		/// <summary>
		/// Inserts a voltage type
		/// </summary>
		/// <returns>Returns a dataset containing all voltage types</returns>
		public static DataSet InsertVoltageTypes( string voltageCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_VoltageTypesInsert";
					cmd.Parameters.Add( new SqlParameter( "VoltageCode", voltageCode ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets voltage types
		/// </summary>
		/// <returns>Returns a dataset containing all voltage types</returns>
		public static DataSet SelectVoltageTypes()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_VoltageTypesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateVoltageTypes()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_VoltageTypesUpdate";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets meter types for utility mapping
		/// </summary>
		/// <returns>Returns a dataset containing all meter types for utility mapping.</returns>
		public static DataSet SelectMeterMapTypes()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_MeterMapTypesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet SelectUtilitiesThatHaveZones()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilitiesThatHaveZonesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet SelectZonesForUtility( int utilityID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ZonesForUtilitySelect";

					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static int UtilityZoneMappingExists( int utilityId, string driverFieldName, string driverValue )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneMappingExists";

					cmd.Parameters.Add( new SqlParameter( "UtilityID", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "DriverFieldName", driverFieldName ) );
					cmd.Parameters.Add( new SqlParameter( "DriverValue", driverValue ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			if( ds.Tables.Count > 0 && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0 )
			{
				return Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] );
			}
			else
			{
				return 0;
			}
		}

		public static int ZoneIDByZoneCodeAndUtilityId( int utilityId, string zoneCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ZoneIDByZoneCodeAndUtilityID";

					cmd.Parameters.Add( new SqlParameter( "UtilityID", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "ZoneCode", zoneCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			if( ds.Tables.Count > 0 && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0 )
			{
				return Convert.ToInt32( ds.Tables[0].Rows[0]["ZoneID"] );
			}
			else
			{
				return 0;
			}
		}

		public static bool ZoneIdExistsForUtilityId( string utility, string zoneCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ZoneIdExistsForUtilityId";

					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utility ) );
					cmd.Parameters.Add( new SqlParameter( "ZoneCode", zoneCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			if( ds.Tables.Count > 0 && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0 )
			{
				return Convert.ToInt32( ds.Tables[0].Rows[0]["ZoneID"] ) > 0;
			}
			else
			{
				return false;
			}
		}


		/// <summary>
		/// Gets the utility based on the zip code and sales channel
		/// </summary>
		/// <param name="Username"></param>
		/// <param name="Zipcode"></param>
		/// <returns>Dataset containing the utility info</returns>
		public static DataSet GetUtilities( string Username, string Zipcode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilitiesSelectByZipCode";

					cmd.Parameters.Add( new SqlParameter( "@Username", Username ) );
					cmd.Parameters.Add( new SqlParameter( "@Zipcode", Zipcode ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		public static DataSet GetUtilitiesAndMarkets()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityAndMarketsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		public static bool IsLossFactorMappedInUtilityZoneMappings( string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneMappingLossFactorExists";

					cmd.Parameters.Add( new SqlParameter( "UtilityID", null ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			if( ds.Tables.Count > 0 && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0 )
			{
				return Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] ) > 0;
			}
			return false;
		}

		public static bool IsZoneMappedInUtilityZoneMappings( string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneMappingZoneExists";

					cmd.Parameters.Add( new SqlParameter( "UtilityID", null ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			if( ds.Tables.Count > 0 && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0 )
			{
				return Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] ) > 0;
			}
			return false;
		}

		public static bool IsLossFactorMappedInUtilityClassMappings( string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingLossFactorExists";

					cmd.Parameters.Add( new SqlParameter( "UtilityID", null ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			if( ds.Tables.Count > 0 && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0 )
			{
				return Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] ) > 0;
			}
			return false;
		}

		public static bool IsZoneMappedInUtilityClassMappings( string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingZoneExists";

					cmd.Parameters.Add( new SqlParameter( "UtilityID", null ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			if( ds.Tables.Count > 0 && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0 )
			{
				return Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] ) > 0;
			}
			return false;
		}

		public static void ClearUtilityMapping()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricingUtilityMappingDelete";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
		}

		public static void InsertUtilityMap( int utilityID, string driver, string resultant )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingInsertMap";

					cmd.Parameters.Add( new SqlParameter( "UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "Driver", driver ) );
					cmd.Parameters.Add( new SqlParameter( "Resultant", resultant ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
		}

		public static void ClearUtilityTable()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingClear";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
		}

		public static void ClearZoneTable()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneMappingClear";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
		}



		/// <summary>
		/// get the list of ISOs
		/// </summary>
		/// <returns>dataset with the list of ISOs</returns>
		public static DataSet GetISOLsit()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetISO";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		public static DataSet GetUtilities( int? utilityId, int? marketId, bool? activeIndicator )
		{
			return GetUtilities( utilityId, marketId, null, null, null, activeIndicator );
		}

		public static DataSet GetUtilities( int? utilityId, int? marketId, string utilityCode, string username,
										   string retailMarketCode, bool? activeIndicator )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandText = "usp_UtilitySelect";
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "Username", username ) );
					cmd.Parameters.Add( new SqlParameter( "MarketCode", retailMarketCode ) );
					cmd.Parameters.Add( new SqlParameter( "MarketID", marketId ) );
					cmd.Parameters.Add( new SqlParameter( "ActiveIndicator", activeIndicator ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityID", utilityId ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}

			return ds;
		}

		public static string GetStratumServiceClassMappingId( string serviceClass )
		{
			string mappingId;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandText = "usp_UtilityStratumGetServiceClassID";
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.Add( new SqlParameter( "ServiceClass", serviceClass ) );
					object o = cmd.ExecuteScalar();
					mappingId = (o == DBNull.Value ? null : o.ToString());
				}
				cn.Close();
			}
			return mappingId;
		}

		public static decimal GetStratumEnd( int UtilityId, decimal Stratum, string ServiceClass )
		{
			decimal stratumEnd = -1;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandText = "usp_UtilityStratumGetStratumEnd";
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.Add( new SqlParameter( "UtilityID", UtilityId ) );
					cmd.Parameters.Add( new SqlParameter( "Stratum", Stratum ) );
					cmd.Parameters.Add( new SqlParameter( "ServiceClass", ServiceClass ) );
					object o = cmd.ExecuteScalar();
					decimal.TryParse( o == DBNull.Value ? "-1" : o.ToString(), out stratumEnd );
				}
				cn.Close();
			}
			return stratumEnd;
		}
        /// <summary>
        /// Gets the utilities for the selected markets
        /// </summary>
        /// <returns>DataSet containing utilities for the selected markets</returns>

        public static DataSet GetMarketUtilities(string marketIds)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandText = "usp_MarketUtilityList";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@p_MarketIds", marketIds));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }

            return ds;
        }

		public static DataSet GetUtilityZoneDefault( int utilityID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandText = "usp_UtilityZoneDefaultSelect";
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
	}
}
