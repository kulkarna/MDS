using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
	public static class TabletDataCacheSql
	{
		//Get Tablet data cache list by sales channel
		public static DataSet GetTabletDataCacheList( int? ChannelId )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					conn.Open();
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TabletDataCache_list";
					cmd.Parameters.Add( new SqlParameter( "@p_ChannelId", ChannelId ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		//Get Tablet Cache Data if Hash Value already exists.
		public static DataSet GetDataIfHashAlreadyExists( int TabletDataCacheId, Guid HashValue )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					conn.Open();
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TabletDataCacheByHashValue";
					cmd.Parameters.Add( new SqlParameter( "@p_TabletDataCacheId", TabletDataCacheId ) );
					cmd.Parameters.Add( new SqlParameter( "@p_HashValue", HashValue ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

        //Get Tablet Cache Data Expiration Date by Tablet Data Cache Item ID.
        public static DataSet GetTabletCacheItemExpirationDate(int TabletDataCacheId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetTabletCacheItemExpirationDate";
                    cmd.Parameters.Add(new SqlParameter("@CacheItemID", TabletDataCacheId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }

            return ds;
        }

		//Generate Tablet Cache data for sales channel
		public static DataSet GenerateTabletDataCache( int ChannelId )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					conn.Open();
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TabletDataCacheInsert";
					cmd.Parameters.Add( new SqlParameter( "@p_ChannelId", ChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		//Update Tablet data cache 
		public static DataSet UpdateTabletDataCache( int TabletCacheDataId, Guid HashValue, DateTime? LastChanged, DateTime? ExpirationDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					conn.Open();
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TabletDataCacheUpdate";
					cmd.Parameters.Add( new SqlParameter( "@p_TabletDataCacheId", TabletCacheDataId ) );
					cmd.Parameters.Add( new SqlParameter( "@p_HashValue", HashValue ) );


					cmd.Parameters.Add( new SqlParameter( "@p_LastUpdated", LastChanged ) );
					cmd.Parameters.Add( new SqlParameter( "@p_ExpirationDate", ExpirationDate ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		//Update Tablet data cache 
		public static DataSet UpdateTabletDataCacheforCacheItem( int TabletDataCacheItemId, Guid HashValue, int? SalesChannelID, DateTime? LastChanged, DateTime? ExpirationDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					conn.Open();
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TabletDataCacheUpdateforCacheItem";
					cmd.Parameters.Add( new SqlParameter( "@p_TabletDataCacheItemId", TabletDataCacheItemId ) );
					if( HashValue!=System.Guid.Empty)
						cmd.Parameters.Add( new SqlParameter( "@p_HashValue", HashValue ) );
					if( SalesChannelID.HasValue )
						cmd.Parameters.Add( new SqlParameter( "@p_SalesChannelID", SalesChannelID ) );
					cmd.Parameters.Add( new SqlParameter( "@p_LastUpdated", LastChanged ) );
					cmd.Parameters.Add( new SqlParameter( "@p_ExpirationDate", ExpirationDate ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static DataSet GetTabletDataCacheItembySalesChannelIdandCacheitemName( string TabletDataCacheItem, int SalesChannelId )
		{
			var ds = new DataSet();

			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TabletDataCacheItembySalesChannelIdandCacheitemName";
					cmd.Parameters.Add( new SqlParameter( "@p_SalesChannelId", SalesChannelId ) );
					cmd.Parameters.Add( new SqlParameter( "@p_TabletDataCacheItemName", TabletDataCacheItem ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}



		#region "TabletDataCacheTemplate"

		public static DataSet GetTabletDataCacheItemdetailsbyCacheitemId( int TabletDataCacheItemId )
		{
			var ds = new DataSet();

			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TabletDataCacheItemTemplateSelectByItemid";
					cmd.Parameters.Add( new SqlParameter( "@p_TabletDataCacheItemId", TabletDataCacheItemId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		public static DataSet GetCacheItemsbyFrequencyTypeId( int FrequencyTypeId )
		{
			var ds = new DataSet();

			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TabletDataCacheItemSelectByFrequencyId";
					cmd.Parameters.Add( new SqlParameter( "@p_FrequencyTypeId", FrequencyTypeId ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		public static DataSet GetTabletDataCacheItemdetailsbyCacheitemIdandSalesChannelId( int TabletDataCacheItemId, int? SalesChannelId )
		{
			var ds = new DataSet();

			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TabletDataCacheItemTemplateSelectByItemidandSalesChannelId";
					cmd.Parameters.Add( new SqlParameter( "@p_TabletDataCacheItemId", TabletDataCacheItemId ) );
					if( SalesChannelId.HasValue )
						cmd.Parameters.Add( new SqlParameter( "@p_SalesChannelId", SalesChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}


		public static DataSet UpdateTabletDataCacheTemplate( int TabletDataCacheItemId, int? SalesChannelId, int? MaxId, DateTime? MaxDate, int ModifiedBy, DateTime ModifiedDate )
		{

			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TabletDataCacheTemplate_Update";
					cmd.Parameters.Add( new SqlParameter( "@p_TabletDataCacheItemId", TabletDataCacheItemId ) );
					cmd.Parameters.Add( new SqlParameter( "@p_MaxId", MaxId ) );
					cmd.Parameters.Add( new SqlParameter( "@p_MaxDate", MaxDate ) );
					cmd.Parameters.Add( new SqlParameter( "@p_ModifiedBy", ModifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@p_ModifiedDate", ModifiedDate ) );

					if( SalesChannelId.HasValue )
					{
						cmd.Parameters.Add( new SqlParameter( "@p_SalesChannelId", SalesChannelId ) );
					}

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;

		}

		#endregion

		# region "TabletDataCacheAudit"
		public static DataSet InsertTabletDataCacheAudit( int TabletDataCacheItemId, int? SalesChannelId, bool updated, int CreatedBy, DateTime CreatedDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_TabletDataCacheAudit_Insert";
					cmd.Parameters.Add( new SqlParameter( "@p_TabletDataCacheItemId", TabletDataCacheItemId ) );
					cmd.Parameters.Add( new SqlParameter( "@p_SalesChannelId", SalesChannelId ) );
					cmd.Parameters.Add( new SqlParameter( "@p_updated", updated ) );
					cmd.Parameters.Add( new SqlParameter( "@p_CreatedBy", CreatedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@p_CreatedDate", CreatedDate ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;

		}

		#endregion

		# region "TabletDataCacheTemplate"
		public static bool IsTabletDataCacheUpdateforItemActive( int TabletDataCacheItemId, int? SalesChannelId )
		{
			DataSet ds = new DataSet();
			bool result = false;
			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IsTabletDataCacheUpdateforItemActive";
					cmd.Parameters.Add( new SqlParameter( "@p_TabletDataCacheItemId", TabletDataCacheItemId ) );
					if( SalesChannelId.HasValue )
						cmd.Parameters.Add( new SqlParameter( "@p_SalesChannelId", SalesChannelId ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				if( ds.Tables[0].Rows[0][0].ToString() == "1" )
					result = true;

			}
			return result;
		}




		public static bool IsTabletDataCacheUpdateforItemEnabled( int TabletDataCacheItemId )
		{
			DataSet ds = new DataSet();
			bool result = false;
			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IsTabletDataCacheUpdateforItemEnabled";
					cmd.Parameters.Add( new SqlParameter( "@p_TabletDataCacheItemId", TabletDataCacheItemId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				if( ds.Tables[0].Rows[0][0].ToString() == "1" )
					result = true;
			}
			return result;
		}


		public static DataSet GetDailyPricingValuesChanged( System.DateTime currentDateTime, int? SalesChannelId )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_HasDailyPricingValuesChanged";
					cmd.Parameters.Add( new SqlParameter( "@CurrentDate", currentDateTime ) );
					if( SalesChannelId.HasValue )
						cmd.Parameters.Add( new SqlParameter( "@SalesChannelID", SalesChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetMarketProductsDataChanged( int? SalesChannelId )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_HasMarketsProductDataChanged";
					if( SalesChannelId.HasValue )
						cmd.Parameters.Add( new SqlParameter( "@SalesChannelID", SalesChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}



		public static DataSet GetDataforPricing( int? SalesChannelId )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetMaxDailyPricingValues";
					if( SalesChannelId.HasValue )
						cmd.Parameters.Add( new SqlParameter( "@SalesChannelID", SalesChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetDataforMarketProducts( int? SalesChannelId )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetMaxMarketProductsValues";
					if( SalesChannelId.HasValue )
						cmd.Parameters.Add( new SqlParameter( "@SalesChannelID", SalesChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetDataforZipCode(  )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetMaxZipCode";
					
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetDataforSalesAgents( int? SalesChannelId )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetMaxSalesAgentValues";
					if( SalesChannelId.HasValue )
						cmd.Parameters.Add( new SqlParameter( "@SalesChannelID", SalesChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}



		public static DataSet GetDataforPromotionCodeandQualifiers( int? SalesChannelId )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetMaxPromotionandQualifiersValues";
					if( SalesChannelId.HasValue )
						cmd.Parameters.Add( new SqlParameter( "@SalesChannelID", SalesChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetDataforActiveTabletFrequencies()
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetTabletCacheFrequencies_Active";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}


		#endregion


		public static DataSet GetTabletSalesChannels()
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetTabletSalesChannels";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}


	}


}
