using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class UtilityMappingSql
    {
		/// <summary>
		/// Gets utility mappings by utility ID.
		/// </summary>
		/// <param name="utilityID">Utility record identifier</param>
		/// <returns>Returns a dataset that contains the utility mappings by utility ID.</returns>
		public static DataSet SelectUtilityMappingByUtility( int utilityID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityMappingByUtilityIDSelect";

					cmd.Parameters.Add( new SqlParameter( "UtilityID", utilityID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets utility mappings by utility code.
		/// </summary>
		/// <param name="utilityCode">Utility code</param>
		/// <returns>Returns a dataset that contains the utility mappings by utility code.</returns>
		public static DataSet SelectUtilityMappingByUtility( string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityByUtilityCodeSelect";

					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			if( ds != null && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0 )
			{
				int utilityID = Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] );
				ds = SelectUtilityMappingByUtility( utilityID );
			}
			return ds;
		}

		/// <summary>
		/// Gets all utility class mappings.
		/// </summary>
		/// <returns>Returns a dataset that contains all utility class mappings.</returns>
		public static DataSet SelectUtilityMapping()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityMappingSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts new utility class mapping record
		/// </summary>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="accountTypeID">Account type record identifier</param>
		/// <param name="meterTypeID">Meter type record identifier</param>
		/// <param name="voltageID">Voltage record identifier</param>
		/// <param name="rateClassCode">Rate class code</param>
		/// <param name="serviceClassCode">Service class code</param>
		/// <param name="loadProfileCode">Load profile code</param>
		/// <param name="loadShapeCode">Load shape code</param>
		/// <param name="tariffCode">Tariff code</param>
		/// <param name="losses">Losses</param>
		/// <param name="isActive">Active indicator</param>
		public static void InsertUtilityClassMapping( int utilityID, int accountTypeID, int meterTypeID, int voltageID,
			string rateClassCode, string serviceClassCode, string loadProfileCode, string loadShapeCode, string tariffCode,
			decimal? losses, string zone, bool isActive, int mappingRuleType = 0, decimal? icap = null, decimal? tcap = null )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingInsert";

					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MeterTypeID", meterTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@VoltageID", voltageID ) );
					cmd.Parameters.Add( new SqlParameter( "@RateClassCode", rateClassCode.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassCode", serviceClassCode.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@LoadProfileCode", loadProfileCode.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@LoadShapeCode", loadShapeCode.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@TariffCode", tariffCode.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@Losses", losses ) );
					cmd.Parameters.Add( new SqlParameter( "@Zone", zone ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", Convert.ToInt16( isActive ) ) );
                    cmd.Parameters.Add(new SqlParameter("@RuleType", mappingRuleType));
                    if (icap.HasValue)
                        cmd.Parameters.Add(new SqlParameter("@Icap", icap.Value));
                    if (tcap.HasValue)
                        cmd.Parameters.Add(new SqlParameter("@TCap", tcap.Value));
					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static DataSet SelectUtilityIdUtilityCodeList()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityIdUtilityCodeListSelect";
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Updates utility class mapping record
		/// </summary>
		/// <param name="identifier">Utility class mapping record identifier</param>
		/// <param name="utilityId"></param>
		/// <param name="accountTypeID">Account type record identifier</param>
		/// <param name="meterTypeID">Meter type record identifier</param>
		/// <param name="voltageID">Voltage record identifier</param>
		/// <param name="rateClassCode">Rate class code</param>
		/// <param name="serviceClassCode">Service class code</param>
		/// <param name="loadProfileCode">Load profile code</param>
		/// <param name="loadShapeCode">Load shape code</param>
		/// <param name="tariffCode">Tariff code</param>
		/// <param name="losses">Losses</param>
		/// <param name="isActive">Active indicator</param>
		public static void UpdateUtilityClassMapping( int identifier, int utilityId, int accountTypeID, int meterTypeID, int voltageID,
			string rateClassCode, string serviceClassCode, string loadProfileCode, string loadShapeCode, string tariffCode,
			decimal? losses, string zone, bool isActive, int mappingRuleType = 0, decimal ? icap = null, decimal ? tcap = null )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ID", identifier ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MeterTypeID", meterTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@VoltageID", voltageID ) );
					cmd.Parameters.Add( new SqlParameter( "@RateClassCode", rateClassCode.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassCode", serviceClassCode.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@LoadProfileCode", loadProfileCode.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@LoadShapeCode", loadShapeCode.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@TariffCode", tariffCode.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@Losses", losses ) );
					cmd.Parameters.Add( new SqlParameter( "@Zone", zone ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", Convert.ToInt16( isActive ) ) );
                    cmd.Parameters.Add(new SqlParameter("@RuleType", mappingRuleType));
                    if(icap.HasValue)
                        cmd.Parameters.Add(new SqlParameter("@Icap", icap.Value));
                    if(tcap.HasValue)
                        cmd.Parameters.Add(new SqlParameter("@TCap", tcap.Value));

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Deletes utility class mapping record for specified identifier.
		/// </summary>
		/// <param name="identifier">Utility class mapping record identifier</param>
		public static void DeleteUtilityClassMapping( int identifier )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingDelete";

					cmd.Parameters.Add( new SqlParameter( "@ID", identifier ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}
		/// <summary>
		/// Gets utility zone mappings by utility ID.
		/// </summary>
		/// <param name="utilityID">Utility record identifier</param>
		/// <returns>Returns a dataset that contains the utility zone mappings by utility ID.</returns>
		public static DataSet SelectUtilityZoneMappingByUtility( int utilityID )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneMappingByUtilityIDSelect";
					cmd.Parameters.Add( new SqlParameter( "UtilityID", utilityID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
		/// <summary>
		/// Gets utility zone mappings by utility code.
		/// </summary>
		/// <param name="utilityCode">utility code</param>
		/// <returns>Returns a dataset that contains the utility zone mappings by utility code.</returns>
		public static DataSet SelectUtilityZoneMappingByUtility( string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityByUtilityCodeSelect";

					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			if( ds != null && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0 )
			{
				int utilityID = Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] );
				ds = SelectUtilityZoneMappingByUtility( utilityID );
			}
			return ds;
		}

		/// <summary>
		/// Gets all utility zone mappings.
		/// </summary>
		/// <returns>Returns a dataset that contains all utility zone mappings.</returns>
		public static DataSet SelectUtilityZoneMapping()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneMappingSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static void UtilityClassLossFactorUpdate( int marketId, int utilityId, int accountTypeID, string active, int voltageId, decimal lossFactor )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassLossFactorUpdate";

					cmd.Parameters.Add( new SqlParameter( "@MarketId", marketId ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityId", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@Active", active ) );
					cmd.Parameters.Add( new SqlParameter( "@VoltageId", voltageId ) );
					cmd.Parameters.Add( new SqlParameter( "@lossFactor", lossFactor ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static void UtilityZoneLossFactorUpdate( int marketId, int utilityId, string active, decimal lossFactor )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneLossFactorUpdate";

					cmd.Parameters.Add( new SqlParameter( "@MarketId", marketId ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityId", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "@Active", active ) );
					cmd.Parameters.Add( new SqlParameter( "@lossFactor", lossFactor ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}
        
        #region DeterminantAlias DAL support
        public static DataSet DeactivateDeterminantAlias(int id)
        {
            var ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_Determinants_AliasDeactivate";
                    cmd.Parameters.Add(new SqlParameter("@ID", id));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet InsertDeterminantAlias(string utilityCode, string fieldName, string originalValue, string aliasValue, string userIdentity)
        {
            var ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_Determinants_AliasInsert";
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@FieldName", fieldName));
                    cmd.Parameters.Add(new SqlParameter("@OriginalValue", originalValue));
                    cmd.Parameters.Add(new SqlParameter("@AliasValue", aliasValue));
                    cmd.Parameters.Add(new SqlParameter("@UserIdentity", userIdentity));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet DeterminantAliasSelectAll(DateTime contextDate)
        {
            var ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_Determinants_AliasSelectAll";
                    cmd.Parameters.Add(new SqlParameter("@ContextDate", contextDate));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        #endregion

        /// <summary>
		/// Inserts utility zone mapping record.
		/// </summary>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="zoneID">Zone record identifier</param>
		/// <param name="grid">Grid</param>
		/// <param name="lbmpZone">LBMP zone</param>
		/// <param name="losses">Losses</param>
		/// <param name="isActive">Active indicator</param>
        public static void InsertUtilityZoneMapping(int utilityID, int zoneID, string grid, string lbmpZone, decimal? losses, bool isActive, int mappingRuleType = 0)
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneMappingInsert";

					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@Grid", grid.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@LbmpZone", lbmpZone.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@Losses", losses ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", Convert.ToInt16( isActive ) ) );
                    cmd.Parameters.Add(new SqlParameter("@RuleType", mappingRuleType));

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Updates utility zone mapping record
		/// </summary>
		/// <param name="identifier">Utility zone mapping record identifier</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="zoneID">Zone record identifier</param>
		/// <param name="grid">Grid</param>
		/// <param name="lbmpZone">LBMP zone</param>
		/// <param name="losses">Losses</param>
		/// <param name="isActive">Active indicator</param>
        public static void UpdateUtilityZoneMapping(int identifier, int utilityID, int zoneID, string grid, string lbmpZone, decimal? losses, bool isActive, int mappingRuleType = 0)
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneMappingUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ID", identifier ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@Grid", grid.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@LbmpZone", lbmpZone.ToUpper() ) );
					cmd.Parameters.Add( new SqlParameter( "@Losses", losses ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", Convert.ToInt16( isActive ) ) );
                    cmd.Parameters.Add(new SqlParameter("@RuleType", mappingRuleType));

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Deletes utility zone mapping record for specified identifier.
		/// </summary>
		/// <param name="identifier">Utility zone mapping record identifier</param>
		public static void DeleteUtilityZoneMapping( int identifier )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneMappingDelete";

					cmd.Parameters.Add( new SqlParameter( "@ID", identifier ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets utility class mapping determinants for specified utility id
		/// </summary>
		/// <param name="utilityID">Utility record identifier</param>
		/// <returns>Returns a dataset containing the utility class mapping determinants for specified utility id.</returns>
		public static DataSet SelectUtilityClassMappingDeterminants( int utilityID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingDeterminantsSelect";

					cmd.Parameters.Add( new SqlParameter( "UtilityID", utilityID ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets utility class mapping determinants for specified utility code
		/// </summary>
		/// <param name="utilityCode">Utility code</param>
		/// <returns>Returns a dataset containing the utility class mapping determinants for specified utility code.</returns>
		public static DataSet SelectUtilityClassMappingDeterminants( string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityByUtilityCodeSelect";

					cmd.Parameters.Add( new SqlParameter( "UtilityCode", utilityCode ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			if( ds != null && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0 )
			{
				int utilityID = Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] );
				ds = SelectUtilityClassMappingDeterminants( utilityID );
			}
			return ds;
		}

        public static DataSet SelectUtilityClassMappingDeterminants()
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_UtilityClassMappingDeterminantsSelectAll";
                    
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

		/// <summary>
		/// Determines if the UtilityClassMapping Exists based on utilityID and driver
		/// </summary>
		/// <param name="utilityId"></param>
		/// <param name="driverFieldName"></param>
		/// <param name="driverValue"></param>
		/// <returns>The ID if the record exists, 0 otherwise</returns>
		public static int UtilityClassMappingExists( int utilityId, string driverFieldName, string driverValue )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingExists";

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

		/// <summary>
		/// Gets utility class mapping resultants for specified determinants id
		/// </summary>
		/// <param name="determinantsID">Determinants record identifier</param>
		/// <returns>Returns a dataset conatining the utility class mapping resultants for specified determinants id.</returns>
		public static DataSet SelectUtilityClassMappingResultants( int determinantsID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingResultantsSelect";

					cmd.Parameters.Add( new SqlParameter( "DeterminantsID", determinantsID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static bool IsLossFactorMappedInUtilityZoneMappings( int utilityId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneMappingLossFactorExists";

					cmd.Parameters.Add( new SqlParameter( "UtilityId", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", null ) );

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

		public static bool IsZoneMappedInUtilityZoneMappings( int utilityId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityZoneMappingZoneExists";

					cmd.Parameters.Add( new SqlParameter( "UtilityId", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", null ) );

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

		public static bool IsLossFactorMappedInUtilityClassMappings( int utilityId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingLossFactorExists";

					cmd.Parameters.Add( new SqlParameter( "UtilityId", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", null ) );

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

		public static bool IsZoneMappedInUtilityClassMappings( int utilityId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityClassMappingZoneExists";

					cmd.Parameters.Add( new SqlParameter( "UtilityId", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "UtilityCode", null ) );

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

        public static DataSet InsertFieldMapDeterminant(string utilityCode, string determinantFieldName, string determinantValue, string mappingRuleType, string createdBy, DateTime? effectiveDate = null)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_Determinants_FieldMapDeterminantInsert";

                    cmd.Parameters.Add(new SqlParameter("UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("DeterminantFieldName", determinantFieldName));
                    cmd.Parameters.Add(new SqlParameter("DeterminantFieldValue", determinantValue));
                    cmd.Parameters.Add(new SqlParameter("MappingRuleType", mappingRuleType));
                    cmd.Parameters.Add(new SqlParameter("CreatedBy", createdBy));
                    if(effectiveDate.HasValue)
                        cmd.Parameters.Add(new SqlParameter("EffectiveDate", effectiveDate.Value));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet InsertFieldMapResultant(int fieldMapID, string resultantFieldName, string resultantFieldValue)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_Determinants_FieldMapResultantInsert";

                    cmd.Parameters.Add(new SqlParameter("FieldMapID", fieldMapID));
                    cmd.Parameters.Add(new SqlParameter("ResultantFieldName", resultantFieldName));
                    cmd.Parameters.Add(new SqlParameter("ResultantFieldValue", resultantFieldValue));



                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet DeactivateFieldMap(int fieldMapID)
        {
            var ds = new DataSet();

            using (var conn = new SqlConnection(Helper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_Determinants_FieldMapDeactivate";

                    cmd.Parameters.Add(new SqlParameter("ID", fieldMapID));

                    using (var da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet LoadFieldMaps(DateTime contextDate)
        {
            var ds = new DataSet();

            using (var conn = new SqlConnection(Helper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_Determinants_FieldMapsSelect";

                    cmd.Parameters.Add(new SqlParameter("ContextDate", contextDate));

                    using (var da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet LoadFieldMap(int ID)
        {
            var ds = new DataSet();

            using (var conn = new SqlConnection(Helper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_Determinants_FieldMapSelect";

                    cmd.Parameters.Add(new SqlParameter("ID", ID));

                    using (var da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

		public static void DeActivateAllExistingFieldMaps()
		{
			var ds = new DataSet();
			using (var conn = new SqlConnection(Helper.ConnectionString))
			{
				using (var cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_Determinants_FieldMapDeactivateAll";

					using(var da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
		}

    }
}
