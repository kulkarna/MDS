namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	using System;
	using System.Data;
	using System.Data.SqlClient;

	/// <summary>
	/// Data Access for DailyPricing
	/// </summary>
	[Serializable]
	public static class DailyPricingSql
	{
		public static DataSet GetCrossProductPrices( int marketID, int utilityID, int zoneID,
				int serviceClassID, int channelGroupID, int segmentID, int channelTypeID, int productTypeID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingProductCrossPriceTempSelect";

					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetMarketList()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_MarketGetAll";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet FillCrossProductTemp()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceTempFill";

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
			return ds;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="productID"></param>
		/// <param name="rateID"></param>
		/// <param name="rate"></param>
		/// <param name="term"></param>
		/// <param name="effectiveDate"></param>
		/// <param name="expirationDate"></param>
		/// <param name="markupRate"></param>
		/// <param name="rateDescription"></param>
		public static void InsertDailyPricingUpdateLegacyRatesStageData( string productID, int rateID, decimal rate,
			int term, DateTime effectiveDate, DateTime expirationDate, decimal markupRate, string rateDescription )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingUpdateLegacyRates_StageInsert";

					cmd.Parameters.Add( new SqlParameter( "@ProductID", productID ) );
					cmd.Parameters.Add( new SqlParameter( "@RateID", rateID ) );
					cmd.Parameters.Add( new SqlParameter( "@Rate", rate ) );
					cmd.Parameters.Add( new SqlParameter( "@Terms", term ) );
					cmd.Parameters.Add( new SqlParameter( "@EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@DueDate", expirationDate ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMargin", markupRate ) );
					cmd.Parameters.Add( new SqlParameter( "@RateDesc", rateDescription ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}
		#region CostRule Methods

		/// <summary>
		/// Costs the rule get by CostRuleSetID.
		/// </summary>
		/// <param name="costRuleSetID">CostRuleSetID</param>
		/// <returns></returns>
		public static DataSet CostRuleGetByCostRuleSetID( int costRuleSetID )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 3600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCostRuleGetBySetId";
					cmd.Parameters.Add( new SqlParameter( "@ProductCostRuleSetID", costRuleSetID ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Costs the rule get by CostRuleID.
		/// </summary>
		/// <param name="costRuleID">The CostRuleID.</param>
		/// <returns></returns>
		public static DataSet CostRuleGetById( int costRuleID )
		{
			string SQL = "usp_ProductCostRuleGetById";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductCostRuleID", costRuleID );

				da.SelectCommand.Parameters.Add( p1 );

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Inserts the cost rule.
		/// </summary>
		/// <param name="productCostRuleSetID">The product cost rule set ID.</param>
		/// <param name="prospectCustomerTypeID">The prospect customer type ID.</param>
		/// <param name="marketID">The market ID.</param>
		/// <param name="utilityID">The utility ID.</param>
		/// <param name="serviceClassID">The service class ID.</param>
		/// <param name="zoneID">The zone ID.</param>
		/// <param name="productTypeID">The product ID.</param>
		/// <param name="startDate">The start date.</param>
		/// <param name="term">The term.</param>
		/// <param name="rate">Rate.</param>
		/// <param name="createdBy">The created by.</param>
		/// <returns></returns>
		public static DataSet CostRuleInsert( int productCostRuleSetID, int prospectCustomerTypeID, int marketID, int utilityID, int serviceClassID, int zoneID, int productTypeID, DateTime startDate, int term, decimal rate, int createdBy )
		{
			string SQL = "usp_ProductCostRuleInsert";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductCostRuleSetID", productCostRuleSetID );
				SqlParameter p2 = new SqlParameter( "@CustomerTypeID", prospectCustomerTypeID );
				SqlParameter p3 = new SqlParameter( "@MarketID", marketID );
				SqlParameter p4 = new SqlParameter( "@UtilityID", utilityID );
				SqlParameter p5 = new SqlParameter( "@ServiceClassID", serviceClassID );
				SqlParameter p6 = new SqlParameter( "@ZoneID", zoneID );
				SqlParameter p7 = new SqlParameter( "@ProductTypeID", productTypeID );
				SqlParameter p8 = new SqlParameter( "@StartDate", startDate );
				SqlParameter p9 = new SqlParameter( "@Term", term );
				SqlParameter p10 = new SqlParameter( "@Rate", rate );
				SqlParameter p11 = new SqlParameter( "@CreatedBy", createdBy );

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.SelectCommand.Parameters.Add( p5 );
				da.SelectCommand.Parameters.Add( p6 );
				da.SelectCommand.Parameters.Add( p7 );
				da.SelectCommand.Parameters.Add( p8 );
				da.SelectCommand.Parameters.Add( p9 );
				da.SelectCommand.Parameters.Add( p10 );
				da.SelectCommand.Parameters.Add( p11 );

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Gets all of the CostRuleSets.
		/// </summary>
		/// <returns></returns>
		public static DataSet CostRuleSetGetAll()
		{
			string SQL = "usp_ProductCostRuleSetGetAll";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Gets the CostRuleSet by Id
		/// </summary>
		/// <param name="costRuleSetID">The cost rule set ID.</param>
		/// <returns></returns>
		public static DataSet CostRuleSetGetById( int costRuleSetID )
		{
			string SQL = "usp_ProductCostRuleSetGetById";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductCostRuleSetID", costRuleSetID );

				da.SelectCommand.Parameters.Add( p1 );

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Gets the current CostsRuleSet.
		/// </summary>
		/// <returns></returns>
		public static DataSet CostRuleSetGetCurrent()
		{
			string SQL = "usp_ProductCostRuleSetGetCurrent";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.CommandTimeout = 3600;

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Gets the current CostsRuleSet.
		/// </summary>
		/// <returns></returns>
		public static DataSet CostRuleSetGetByDate( DateTime date )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCostRuleSetGetByDate";

					cmd.Parameters.Add( new SqlParameter( "@Date", date ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts the cost rule set.
		/// </summary>
		/// <param name="effectiveDate">The effective date.</param>
		/// <param name="expirationDate">The expiration date.</param>
		/// <param name="sourceFileGuid">The source file GUID.</param>
		/// <param name="UploadedBy">The uploaded by.</param>
		/// <param name="uploadStatus">The upload status.</param>
		/// <returns></returns>
		public static DataSet CostRuleSetInsert( DateTime effectiveDate, DateTime expirationDate, Guid sourceFileGuid, int UploadedBy, int uploadStatus )
		{
			string SQL = "usp_ProductCostRuleSetInsert";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@EffectiveDate", effectiveDate );
				SqlParameter p2 = new SqlParameter( "@ExpirationDate", expirationDate );
				SqlParameter p3 = new SqlParameter( "@FileGuid", sourceFileGuid.ToString() );
				SqlParameter p4 = new SqlParameter( "@UploadedBy", UploadedBy );
				SqlParameter p5 = new SqlParameter( "@UploadStatus", uploadStatus );

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.SelectCommand.Parameters.Add( p5 );
				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Updates the CostRuleSet.
		/// </summary>
		/// <param name="costSetId">The cost set id.</param>
		/// <param name="effectiveDate">The effective date.</param>
		/// <param name="expirationDate">The expiration date.</param>
		/// <param name="uploadStatus">The upload status.</param>
		/// <returns></returns>
		public static DataSet CostRuleSetUpdate( int costSetId, DateTime effectiveDate, DateTime expirationDate, int uploadStatus )
		{
			string SQL = "usp_ProductCostRuleSetUpdate";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductCostRuleSetID", costSetId );
				SqlParameter p2 = new SqlParameter( "@EffectiveDate", effectiveDate );
				SqlParameter p3 = new SqlParameter( "@ExpirationDate", expirationDate );
				SqlParameter p4 = new SqlParameter( "@UploadStatus", uploadStatus );

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Deletes the CostSet.
		/// </summary>
		/// <param name="costSetID">The cost set ID.</param>
		/// <returns></returns>
		public static bool CostRuleSetDelete( int costSetID )
		{
			string SQL = "usp_ProductCostRuleSetDelete";
			string connStr = Helper.ConnectionString;
			int rowsAffected = 0;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				SqlCommand command = new SqlCommand( SQL, connection );
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = 86400; // one day

				SqlParameter p1 = new SqlParameter( "@ProductCostRuleSetID", costSetID );
				command.Parameters.Add( p1 );

				connection.Open();

				rowsAffected = command.ExecuteNonQuery();
			}
			return (rowsAffected > 0);
		}

		/// <summary>
		/// Gets the CostRuleRaw objects for the the give cost set.
		/// </summary>
		/// <param name="productCostRuleSetID">The product cost rule set ID.</param>
		/// <returns></returns>
		public static DataSet CostRuleRawGet( int productCostRuleSetID )
		{
			string SQL = "usp_ProductCostRuleRawGetBySetId";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandTimeout = 600;
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductCostRuleSetID", productCostRuleSetID );

				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}
			return ds;

		}

		/// <summary>
		/// Inserts a CostsRuleRaw record.
		/// </summary>
		/// <param name="productCostRuleSetID">The product cost rule set ID.</param>
		/// <param name="prospectCustomerType">Type of the prospect customer.</param>
		/// <param name="market">The market.</param>
		/// <param name="utility">The utility.</param>
		/// <param name="utilityServiceClass">The utility service class.</param>
		/// <param name="zone">The zone.</param>
		/// <param name="product">The product.</param>
		/// <param name="startDate">The start date.</param>
		/// <param name="term">The term.</param>
		/// <param name="rate">The rate.</param>
		/// <param name="createdBy">The created by.</param>
		/// <param name="priceTier">Price tier</param>
		/// <returns></returns>
		public static DataSet CostRuleRawInsert( int productCostRuleSetID, string prospectCustomerType, string market, string utility, string utilityServiceClass,
			string zone, string product, DateTime startDate, int term, decimal rate, int createdBy, int priceTier )
		{
			string SQL = "usp_ProductCostRuleRawInsert";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductCostRuleSetID", productCostRuleSetID );
				SqlParameter p2 = new SqlParameter( "@CustomerType", prospectCustomerType );
				SqlParameter p3 = new SqlParameter( "@Market", market );
				SqlParameter p4 = new SqlParameter( "@Utility", utility );
				SqlParameter p5 = new SqlParameter( "@UtilityServiceClass", utilityServiceClass );
				SqlParameter p6 = new SqlParameter( "@Zone", zone );
				SqlParameter p7 = new SqlParameter( "@Product", product );
				SqlParameter p8 = new SqlParameter( "@StartDate", startDate );
				SqlParameter p9 = new SqlParameter( "@Term", term );
				SqlParameter p10 = new SqlParameter( "@Rate", rate );
				SqlParameter p11 = new SqlParameter( "@CreatedBy", createdBy );
				SqlParameter p12 = new SqlParameter( "@PriceTier", priceTier );

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.SelectCommand.Parameters.Add( p5 );
				da.SelectCommand.Parameters.Add( p6 );
				da.SelectCommand.Parameters.Add( p7 );
				da.SelectCommand.Parameters.Add( p8 );
				da.SelectCommand.Parameters.Add( p9 );
				da.SelectCommand.Parameters.Add( p10 );
				da.SelectCommand.Parameters.Add( p11 );
				da.SelectCommand.Parameters.Add( p12 );
				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Performs a bulk insert of CostRules into the database.
		/// </summary>
		/// <param name="dataTable">The data table.</param>
		public static void CostRuleListInsert( DataTable dataTable )
		{
			//string SQL = "usp_ProductCostRuleSetDelete";
			string connStr = Helper.ConnectionString;
			//int rowsAffected = 0;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				connection.Open();

				// Set up the bulk copy object. 
				// Note that the column positions in the source data reader match the column positions in 
				// the destination table so there is no need to map columns.
				using( SqlBulkCopy bulkCopy = new SqlBulkCopy( connection ) )
				{
					bulkCopy.BulkCopyTimeout = 86400; // one day
					bulkCopy.BatchSize = 100000;

					bulkCopy.DestinationTableName = "dbo.ProductCostRule";

					bulkCopy.WriteToServer( dataTable );
				}
			}
		}

		/// <summary>
		/// Sets all outdated CostRuleSets to expired.
		/// </summary>
		/// <param name="costSetID">The new costSetID.</param>
		/// <returns></returns>
		public static int CostRuleSetExpireOutdatedSets( int costSetID )
		{
			string SQL = "usp_ProductCostRuleSetExpiredOutdated";
			string connStr = Helper.ConnectionString;
			int rowsAffected = 0;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				SqlCommand command = new SqlCommand( SQL, connection );
				command.CommandType = CommandType.StoredProcedure;

				SqlParameter p1 = new SqlParameter( "@ProductCostRuleSetID", costSetID );
				command.Parameters.Add( p1 );

				connection.Open();

				rowsAffected = command.ExecuteNonQuery();
			}
			return rowsAffected;
		}

		#endregion CostRule Methods


		#region CostRuleSetup Methods

		/// <summary>
		/// Gets the CostsRuleSetup Set by costRuleSetupSetID.
		/// </summary>
		/// <param name="costRuleSetupSetID">costRuleSetupSetID</param>
		/// <returns></returns>
		public static DataSet CostRuleSetupGetByCostRuleSetupSetID( int costRuleSetupSetID )
		{
			string SQL = "usp_ProductCostRuleSetupGetBySetId";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.CommandTimeout = 600;
				SqlParameter p1 = new SqlParameter( "@ProductCostRuleSetupSetID", costRuleSetupSetID );

				da.SelectCommand.Parameters.Add( p1 );

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Inserts the CostRuleSetup .
		/// </summary>
		/// <param name="CostRuleSetupSetID">The cost rule setup set ID.</param>
		/// <param name="Segment">The segment.</param>
		/// <param name="ProductType">Type of the product.</param>
		/// <param name="Market">The market.</param>
		/// <param name="Utility">The utility.</param>
		/// <param name="Zone">The zone.</param>
		/// <param name="ServiceClass">The service class.</param>
		/// <param name="ServiceClassDisplayName">The service class display name.</param>
		/// <param name="MaxRelativeStartMonth">The max relative start month.</param>
		/// <param name="MaxTerm">The max term.</param>
		/// <param name="LowCostRate">The low cost rate.</param>
		/// <param name="HighCostRate">The high cost rate.</param>
		/// <param name="PorRate">The por rate.</param>
		/// <param name="GrtRate">The GRT rate.</param>
		/// <param name="SutRate">The sut rate.</param>
		/// <param name="InsertedBy">The inserted by.</param>
		/// <param name="priceTier">Price tier record identifier</param>
		/// <returns></returns>
		public static DataSet CostRuleSetupInsert( int CostRuleSetupSetID, int Segment, int ProductType, int Market, int Utility, int Zone, int ServiceClass,
			string ServiceClassDisplayName, int MaxRelativeStartMonth, int MaxTerm, decimal LowCostRate, decimal HighCostRate, decimal PorRate, decimal GrtRate,
			decimal SutRate, int InsertedBy, int priceTier )
		{
			string SQL = "usp_ProductCostRuleSetupInsert";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add( new SqlParameter( "@ProductCostRuleSetupSetID", CostRuleSetupSetID ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@Segment", Segment ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@ProductType", ProductType ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@Market", Market ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@Utility", Utility ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@Zone", Zone ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@ServiceClass", ServiceClass ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@MaxRelativeStartMonth", MaxRelativeStartMonth ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@MaxTerm", MaxTerm ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@LowCostRate", LowCostRate ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@HighCostRate", HighCostRate ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@InsertedBy", InsertedBy ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@PorRate", PorRate ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@GrtRate", GrtRate ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@SutRate", SutRate ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@ServiceClassDisplayName", ServiceClassDisplayName ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@PriceTier", priceTier ) );

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Inserts the CostRuleSetup .
		/// </summary>
		/// <param name="CostRuleSetupSetID">The cost rule setup set ID.</param>
		/// <param name="Segment">The segment.</param>
		/// <param name="ProductType">Type of the product.</param>
		/// <param name="productBrandID">Price brand record identifier</param>
		/// <param name="Market">The market.</param>
		/// <param name="Utility">The utility.</param>
		/// <param name="Zone">The zone.</param>
		/// <param name="ServiceClass">The service class.</param>
		/// <param name="ServiceClassDisplayName">The service class display name.</param>
		/// <param name="MaxRelativeStartMonth">The max relative start month.</param>
		/// <param name="MaxTerm">The max term.</param>
		/// <param name="LowCostRate">The low cost rate.</param>
		/// <param name="HighCostRate">The high cost rate.</param>
		/// <param name="PorRate">The por rate.</param>
		/// <param name="GrtRate">The GRT rate.</param>
		/// <param name="SutRate">The sut rate.</param>
		/// <param name="expectedTerms">Expected terms per start date.</param>
		/// <param name="InsertedBy">The inserted by.</param>
		/// <param name="priceTier">Price tier record identifier</param>
		/// <returns></returns>
		public static DataSet CostRuleSetupInsert( int CostRuleSetupSetID, int Segment, int ProductType, int productBrandID, int Market, int Utility, int Zone, int ServiceClass,
			string ServiceClassDisplayName, int MaxRelativeStartMonth, int MaxTerm, decimal LowCostRate, decimal HighCostRate, decimal PorRate, decimal GrtRate,
			decimal SutRate, int expectedTerms, int InsertedBy, int priceTier )
		{
			string SQL = "usp_ProductCostRuleSetupInsert";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add( new SqlParameter( "@ProductCostRuleSetupSetID", CostRuleSetupSetID ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@Segment", Segment ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@ProductType", ProductType ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@Market", Market ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@Utility", Utility ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@Zone", Zone ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@ServiceClass", ServiceClass ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@MaxRelativeStartMonth", MaxRelativeStartMonth ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@MaxTerm", MaxTerm ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@LowCostRate", LowCostRate ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@HighCostRate", HighCostRate ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@InsertedBy", InsertedBy ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@PorRate", PorRate ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@GrtRate", GrtRate ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@SutRate", SutRate ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@ServiceClassDisplayName", ServiceClassDisplayName ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@PriceTier", priceTier ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@ExpectedTerms", expectedTerms ) );

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Gets all of the CostRuleSetupSets.
		/// </summary>
		/// <returns></returns>
		public static DataSet CostRuleSetupSetGetAll()
		{
			string SQL = "usp_ProductCostRuleSetupSetGetAll";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Gets the CostRuleSetupSet by Id
		/// </summary>
		/// <param name="costRuleSetupSetID">The cost rule Setup set ID.</param>
		/// <returns></returns>
		public static DataSet CostRuleSetupSetGetById( int costRuleSetupSetID )
		{
			string SQL = "usp_ProductCostRuleSetupSetGetById";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductCostRuleSetupSetID", costRuleSetupSetID );

				da.SelectCommand.Parameters.Add( p1 );

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Gets the current CostsRuleSetupSet.
		/// </summary>
		/// <returns></returns>
		public static DataSet CostRuleSetupSetGetCurrent()
		{
			string SQL = "usp_ProductCostRuleSetupSetGetCurrent";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.CommandTimeout = 600;

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Inserts the cost rule Setup set.
		/// </summary>
		/// <param name="sourceFileGuid">The source file GUID.</param>
		/// <param name="UploadedBy">The uploaded by.</param>
		/// <param name="uploadStatus">The upload status.</param>
		/// <returns></returns>
		public static DataSet CostRuleSetupSetInsert( Guid sourceFileGuid, int UploadedBy, int uploadStatus )
		{
			string SQL = "usp_ProductCostRuleSetupSetInsert";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;

				SqlParameter p3 = new SqlParameter( "@FileGuid", sourceFileGuid.ToString() );
				SqlParameter p4 = new SqlParameter( "@UploadedBy", UploadedBy );
				SqlParameter p5 = new SqlParameter( "@UploadStatus", uploadStatus );

				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.SelectCommand.Parameters.Add( p5 );
				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Updates the CostRuleSetupSet.
		/// </summary>
		/// <param name="costSetId">The cost set id.</param>
		/// <param name="uploadStatus">The upload status.</param>
		/// <returns></returns>
		public static DataSet CostRuleSetupSetUpdate( int costSetId, int uploadStatus )
		{
			string SQL = "usp_ProductCostRuleSetupSetUpdate";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductCostRuleSetupSetID", costSetId );
				SqlParameter p4 = new SqlParameter( "@UploadStatus", uploadStatus );

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p4 );
				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Deletes the CostSetupSet.
		/// </summary>
		/// <param name="costSetupSetID">The cost Setup set ID.</param>
		/// <returns></returns>
		public static bool CostRuleSetupSetDelete( int costSetupSetID )
		{
			string SQL = "usp_ProductCostRuleSetupSetDelete";
			string connStr = Helper.ConnectionString;
			int rowsAffected = 0;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				SqlCommand command = new SqlCommand( SQL, connection );
				command.CommandType = CommandType.StoredProcedure;

				SqlParameter p1 = new SqlParameter( "@ProductCostRuleSetupSetID", costSetupSetID );
				command.Parameters.Add( p1 );

				connection.Open();

				rowsAffected = command.ExecuteNonQuery();
			}
			return (rowsAffected > 0);
		}

		#endregion CostRuleSetup Methods


		#region MarkupRule Methods

		/// <summary>
		/// Costs the rule get by MarkupRuleSetID.
		/// </summary>
		/// <param name="markupRuleSetID">MarkupRuleSetID</param>
		/// <returns></returns>
		public static DataSet MarkupRuleGetByMarkupRuleSetID( int markupRuleSetID )
		{
			string SQL = "usp_ProductMarkupRuleGetBySetId";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.CommandTimeout = 3600;
				SqlParameter p1 = new SqlParameter( "@ProductMarkupRuleSetID", markupRuleSetID );

				da.SelectCommand.Parameters.Add( p1 );

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Costs the rule get by MarkupRuleID.
		/// </summary>
		/// <param name="markupRuleID">The MarkupRuleID.</param>
		/// <returns></returns>
		public static DataSet MarkupRuleGetById( int markupRuleID )
		{
			string SQL = "usp_ProductMarkupRuleGetById";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductMarkupRuleID", markupRuleID );

				da.SelectCommand.Parameters.Add( p1 );

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Inserts the cost rule.
		/// </summary>
		/// <param name="productMarkupRuleSetID">The product cost rule set ID.</param>
		/// <param name="channelTypeID">The channel type ID.</param>
		/// <param name="channelGroupID">The channel group ID.</param>
		/// <param name="segmentID">The segment ID.</param>
		/// <param name="marketID">The market ID.</param>
		/// <param name="utilityID">The utility ID.</param>
		/// <param name="serviceClassID">The service class ID.</param>
		/// <param name="zoneID">The zone ID.</param>
		/// <param name="productTypeID">The product ID.</param>
		/// <param name="minTerm">The min term.</param>
		/// <param name="maxTerm">The max term.</param>
		/// <param name="rate">The rate.</param>
		/// <param name="createdBy">The created by.</param>
		/// <param name="priceTier">Price tier</param>
		/// <param name="productTerm">Product term</param>
		/// <param name="productBrandID">Product brand recordd identifier</param>
		/// <returns></returns>
		public static DataSet MarkupRuleInsert( int productMarkupRuleSetID, int channelTypeID, int channelGroupID, int segmentID, int marketID, int utilityID,
			int serviceClassID, int zoneID, int productTypeID, int minTerm, int maxTerm, decimal rate, int createdBy, int priceTier, int productTerm, int productBrandID )
		{
			string SQL = "usp_ProductMarkupRuleInsert";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductMarkupRuleSetID", productMarkupRuleSetID );
				SqlParameter p2 = new SqlParameter( "@ChannelTypeID", channelTypeID );
				SqlParameter p3 = new SqlParameter( "@ChannelGroupID", channelGroupID );
				SqlParameter p4 = new SqlParameter( "@SegmentID", segmentID );
				SqlParameter p5 = new SqlParameter( "@MarketID", marketID );
				SqlParameter p6 = new SqlParameter( "@UtilityID", utilityID );
				SqlParameter p7 = new SqlParameter( "@ServiceClassID", serviceClassID );
				SqlParameter p8 = new SqlParameter( "@ZoneID", zoneID );
				SqlParameter p9 = new SqlParameter( "@ProductTypeID", productTypeID );
				SqlParameter p10 = new SqlParameter( "@MinTerm", minTerm );
				SqlParameter p11 = new SqlParameter( "@MaxTerm", maxTerm );
				SqlParameter p12 = new SqlParameter( "@Rate", rate );
				SqlParameter p13 = new SqlParameter( "@CreatedBy", createdBy );
				SqlParameter p14 = new SqlParameter( "@PriceTier", priceTier );
				SqlParameter p15 = new SqlParameter( "@ProductTerm", productTerm );
				SqlParameter p16 = new SqlParameter( "@ProductBrandID", productBrandID );

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.SelectCommand.Parameters.Add( p5 );
				da.SelectCommand.Parameters.Add( p6 );
				da.SelectCommand.Parameters.Add( p7 );
				da.SelectCommand.Parameters.Add( p8 );
				da.SelectCommand.Parameters.Add( p9 );
				da.SelectCommand.Parameters.Add( p10 );
				da.SelectCommand.Parameters.Add( p11 );
				da.SelectCommand.Parameters.Add( p12 );
				da.SelectCommand.Parameters.Add( p13 );
				da.SelectCommand.Parameters.Add( p14 );
				da.SelectCommand.Parameters.Add( p15 );
				da.SelectCommand.Parameters.Add( p16 );

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Gets all of the MarkupRuleSets.
		/// </summary>
		/// <returns></returns>
		public static DataSet MarkupRuleSetGetAll()
		{
			string SQL = "usp_ProductMarkupRuleSetGetAll";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Gets the MarkupRuleSet by Id
		/// </summary>
		/// <param name="markupRuleSetID">The cost rule set ID.</param>
		/// <returns></returns>
		public static DataSet MarkupRuleSetGetById( int markupRuleSetID )
		{
			string SQL = "usp_ProductMarkupRuleSetGetById";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductMarkupRuleSetID", markupRuleSetID );

				da.SelectCommand.Parameters.Add( p1 );

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Gets the current CostsRuleSet.
		/// </summary>
		/// <returns></returns>
		public static DataSet MarkupRuleSetGetCurrent()
		{
			string SQL = "usp_ProductMarkupRuleSetGetCurrent";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;

				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Inserts the cost rule set.
		/// </summary>
		/// <param name="effectiveDate">The effective date.</param>
		/// <param name="sourceFileGuid">The source file GUID.</param>
		/// <param name="UploadedBy">The uploaded by.</param>
		/// <param name="uploadStatus">Upload status.</param>
		/// <returns></returns>
		public static DataSet MarkupRuleSetInsert( DateTime effectiveDate, Guid sourceFileGuid, int UploadedBy, int uploadStatus )
		{
			string SQL = "usp_ProductMarkupRuleSetInsert";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@EffectiveDate", effectiveDate );
				SqlParameter p2 = new SqlParameter( "@FileGuid", sourceFileGuid.ToString() );
				SqlParameter p3 = new SqlParameter( "@UploadedBy", UploadedBy );
				SqlParameter p4 = new SqlParameter( "@UploadStatus", uploadStatus );

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Updates the MarkupRuleSet.
		/// </summary>
		/// <param name="costSetId">The cost set id.</param>
		/// <param name="effectiveDate">The effective date.</param>
		/// <param name="uploadStatus">Upload status.</param>
		/// <returns></returns>
		public static DataSet MarkupRuleSetUpdate( int costSetId, DateTime effectiveDate, int uploadStatus )
		{
			string SQL = "usp_ProductMarkupRuleSetUpdate";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductMarkupRuleSetID", costSetId );
				SqlParameter p2 = new SqlParameter( "@EffectiveDate", effectiveDate );
				SqlParameter p3 = new SqlParameter( "@UploadStatus", uploadStatus );

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Deletes the CostSet.
		/// </summary>
		/// <param name="costSetID">The cost set ID.</param>
		/// <returns></returns>
		public static bool MarkupRuleSetDelete( int costSetID )
		{
			string SQL = "usp_ProductMarkupRuleSetDelete";
			string connStr = Helper.ConnectionString;
			int rowsAffected = 0;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				SqlCommand command = new SqlCommand( SQL, connection );
				command.CommandType = CommandType.StoredProcedure;

				SqlParameter p1 = new SqlParameter( "@ProductMarkupRuleSetID", costSetID );
				command.Parameters.Add( p1 );

				connection.Open();

				rowsAffected = command.ExecuteNonQuery();
			}
			return (rowsAffected > 0);
		}

		/// <summary>
		/// Gets the MarkupRuleRaw objects for the the give cost set.
		/// </summary>
		/// <param name="productMarkupRuleSetID">The product cost rule set ID.</param>
		/// <returns></returns>
		public static DataSet MarkupRuleRawGet( int productMarkupRuleSetID )
		{
			string SQL = "usp_ProductMarkupRuleRawGetBySetId";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductMarkupRuleSetID", productMarkupRuleSetID );

				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}
			return ds;

		}

		/// <summary>
		/// Inserts a CostsRuleRaw record.
		/// </summary>
		/// <param name="productMarkupRuleSetID">The product cost rule set ID.</param>
		/// <param name="channelType">Type of the channel.</param>
		/// <param name="channelGroup">The channel group.</param>
		/// <param name="segment">The segment.</param>
		/// <param name="market">The market.</param>
		/// <param name="utility">The utility.</param>
		/// <param name="utilityServiceClass">The utility service class.</param>
		/// <param name="zone">The zone.</param>
		/// <param name="product">The product.</param>
		/// <param name="minTerm">The min term.</param>
		/// <param name="maxTerm">The max term.</param>
		/// <param name="rate">The rate.</param>
		/// <param name="createdBy">The created by.</param>
		/// <param name="priceTier">Price tier</param>
		/// <param name="productTerm">Product term</param>
		/// <param name="productBrandID">Product brand recordd identifier</param>
		/// <returns></returns>
		public static DataSet MarkupRuleRawInsert( int productMarkupRuleSetID, string channelType, string channelGroup,
			string segment, string market, string utility, string utilityServiceClass, string zone, string product,
			int? minTerm, int? maxTerm, decimal rate, int createdBy, int priceTier, int? productTerm, int productBrandID )
		{
			string SQL = "usp_ProductMarkupRuleRawInsert";
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ProductMarkupRuleSetID", productMarkupRuleSetID );
				SqlParameter p2 = new SqlParameter( "@ChannelType", channelType );
				SqlParameter p3 = new SqlParameter( "@Market", market );
				SqlParameter p4 = new SqlParameter( "@Utility", utility );
				SqlParameter p5 = new SqlParameter( "@ChannelGroup", channelGroup );
				SqlParameter p6 = new SqlParameter( "@Segment", segment );
				SqlParameter p7 = new SqlParameter( "@Product", product );
				SqlParameter p8 = new SqlParameter( "@Zone", zone );
				SqlParameter p9 = new SqlParameter( "@UtilityServiceClass", utilityServiceClass );
				SqlParameter p10 = new SqlParameter( "@MinTerm", (object) minTerm ?? (object) DBNull.Value );
				SqlParameter p11 = new SqlParameter( "@MaxTerm", (object) maxTerm ?? (object) DBNull.Value );
				SqlParameter p12 = new SqlParameter( "@Rate", rate );
				SqlParameter p13 = new SqlParameter( "@CreatedBy", createdBy );
				SqlParameter p14 = new SqlParameter( "@PriceTier", priceTier );
				SqlParameter p15 = new SqlParameter( "@ProductTerm", (object) productTerm ?? (object) DBNull.Value );
				SqlParameter p16 = new SqlParameter( "@ProductBrandID", productBrandID );

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.SelectCommand.Parameters.Add( p5 );
				da.SelectCommand.Parameters.Add( p6 );
				da.SelectCommand.Parameters.Add( p7 );
				da.SelectCommand.Parameters.Add( p8 );
				da.SelectCommand.Parameters.Add( p9 );
				da.SelectCommand.Parameters.Add( p10 );
				da.SelectCommand.Parameters.Add( p11 );
				da.SelectCommand.Parameters.Add( p12 );
				da.SelectCommand.Parameters.Add( p13 );
				da.SelectCommand.Parameters.Add( p14 );
				da.SelectCommand.Parameters.Add( p15 );
				da.SelectCommand.Parameters.Add( p16 );

				da.Fill( ds );
			}
			return ds;
		}

		#endregion MarkupRule Methods


		#region Product Configuration Methods

		/// <summary>
		/// Inserts template text field data
		/// </summary>
		/// <param name="channelGroupID">Channel group record identifier</param>
		/// <param name="segmentID">Segment record identifier</param>
		/// <param name="channelTypeID">Channel type record identifier</param>
		/// <param name="marketID">Market record identifier</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="headerStatement">Header statement</param>
		/// <param name="sizeRequirement">Size requirement</param>
		/// <param name="submissionStatement">Submission statement</param>
		/// <param name="customerClassStatement">Customer class statement</param>
		/// <param name="productTaxStatement">Product tax statement</param>
		/// <param name="confidentialityStatement">Confidentiality statement</param>
		/// <param name="header">Header text</param>
		/// <param name="footer1">Footer 1 text</param>
		/// <param name="footer2">Footer 2 text</param>
		/// <param name="promoMessage">Promotional text</param>
		/// <param name="promoImageFileGuid">Promotional image file GUID</param>
		/// <returns>Returns a dataset containing template text field data</returns>
		public static DataSet InsertTemplateTextFields( int channelGroupID, int segmentID, int channelTypeID, int marketID, int utilityID,
			string headerStatement, string sizeRequirement, string submissionStatement, string customerClassStatement, string productTaxStatement,
			string confidentialityStatement, string header, string footer1, string footer2, string promoMessage, string promoImageFileGuid,
			int productTypeID, int productBrandID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingTemplateConfigurationUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@HeaderStatement", headerStatement ) );
					cmd.Parameters.Add( new SqlParameter( "@SizeRequirement", sizeRequirement ) );
					cmd.Parameters.Add( new SqlParameter( "@SubmissionStatement", submissionStatement ) );
					cmd.Parameters.Add( new SqlParameter( "@CustomerClassStatement", customerClassStatement ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTaxStatement", productTaxStatement ) );
					cmd.Parameters.Add( new SqlParameter( "@ConfidentialityStatement", confidentialityStatement ) );
					cmd.Parameters.Add( new SqlParameter( "@Header", header ) );
					cmd.Parameters.Add( new SqlParameter( "@Footer1", footer1 ) );
					cmd.Parameters.Add( new SqlParameter( "@Footer2", footer2 ) );
					cmd.Parameters.Add( new SqlParameter( "@PromoMessage", promoMessage ) );
					cmd.Parameters.Add( new SqlParameter( "@PromoImageFileGuid", promoImageFileGuid ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets product configurations
		/// </summary>
		/// <returns>Returns a dataset containing product configurations.</returns> 
		public static DataSet GetProductConfigurations( int rowStart, int rowEnd, string sortBy, string sortDirection, string configName, int marketID, int utilityID, int zoneID,
			int serviceClassID, int channelTypeID, int productTypeID, string productName, int segmentID, int isTermRange, int relativeStartMonth, DateTime dateCreated, out int rowCount )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationsSelect";

					SqlParameter paramRowCount = new SqlParameter( "@RowCount", 0 );
					paramRowCount.Direction = ParameterDirection.Output;

					cmd.Parameters.Add( new SqlParameter( "@RowStart", rowStart ) );
					cmd.Parameters.Add( new SqlParameter( "@RowEnd", rowEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@SortBy", sortBy ) );
					cmd.Parameters.Add( new SqlParameter( "@SortDirection", sortDirection ) );
					cmd.Parameters.Add( new SqlParameter( "@ConfigName", configName ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductName", productName ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsTermRange", isTermRange ) );
					cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeStartMonth ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( paramRowCount );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );

					rowCount = Convert.ToInt32( paramRowCount.Value );
				}
			}
			return ds;
		}

		/// Gets product configurations
		/// </summary>
		/// <returns>Returns a dataset containing product configurations.</returns> 
		public static DataSet GetProductConfigurations( int rowStart, int rowEnd, string sortBy, string sortDirection, string configName, int marketID, int utilityID, int zoneID,
			int serviceClassID, int channelTypeID, int productTypeID, string productName, int segmentID, int isTermRange, int relativeStartMonth, DateTime dateCreated,
            out int rowCount, int productBrandID, int channelID)
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationsSelect";

					SqlParameter paramRowCount = new SqlParameter( "@RowCount", 0 );
					paramRowCount.Direction = ParameterDirection.Output;

					cmd.Parameters.Add( new SqlParameter( "@RowStart", rowStart ) );
					cmd.Parameters.Add( new SqlParameter( "@RowEnd", rowEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@SortBy", sortBy ) );
					cmd.Parameters.Add( new SqlParameter( "@SortDirection", sortDirection ) );
					cmd.Parameters.Add( new SqlParameter( "@ConfigName", configName ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
                    cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID));
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductName", productName ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsTermRange", isTermRange ) );
					cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeStartMonth ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( paramRowCount );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );

					rowCount = Convert.ToInt32( paramRowCount.Value );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets product configurations that include the respective names.
		/// </summary>
		/// <returns>Returns a dataset of product configurations that include the respective names.</returns>
		public static DataSet GetProductConfigurationsTranslated()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationsTranslatedSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets product configuration for specified ID
		/// </summary>
		/// <param name="productConfigurationID">Record identifier</param>
		/// <returns>Returns a dataset containing a product configuration for specified ID.</returns>
		public static DataSet GetProductConfiguration( int productConfigurationID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationSelect";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Deletes product configuration for specified ID
		/// </summary>
		/// <param name="productConfigurationID">Record identifier</param>
		/// <returns>Returns a dataset containing nothing.</returns>
		public static DataSet DeleteProductConfiguration( int productConfigurationID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationDelete";
					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets product configuration price tiers for specified ID
		/// </summary>
		/// <param name="productConfigurationID">Record identifier</param>
		/// <returns>Returns a dataset containing product configuration price tiers for specified ID.</returns>
		public static DataSet GetProductConfigurationPriceTiers( int productConfigurationID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationPriceTiersSelect";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Deletes product configuration price tiers for specified ID
		/// </summary>
		/// <param name="productConfigurationID">Record identifier</param>
		public static void DeleteProductConfigurationPriceTiers( int productConfigurationID )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationPriceTiersDelete";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Deletes product configuration price tiers for specified ID
		/// </summary>
		/// <param name="productConfigurationID">Record identifier</param>
		/// <param name="priceTierID">Price tier record identifier</param>
		public static void InsertProductConfigurationPriceTier( int productConfigurationID, int priceTierID )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationPriceTierInsert";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceTierID", priceTierID ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Deletes offer activation fpr specified product configuration ID
		/// </summary>
		/// <param name="productConfigurationID">Record identifier</param>
		/// <returns>Returns a dataset containing nothing.</returns>
		public static DataSet DeleteOfferActivation( int productConfigurationID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_OfferActivationByProductConfigurationIDDelete";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts/updates product configuration
		/// </summary>
		/// <param name="productConfigurationID">Product configuration record identifier</param>
		/// <param name="name">Product configuration name</param>
		/// <param name="marketIdentity">Market record identifier</param>
		/// <param name="utilityIdentity">Utility record identifier</param>
		/// <param name="zoneIdentity">Zone record identifier</param>
		/// <param name="serviceClassIdentity">Service class record identifier</param>
		/// <param name="channelTypeIdentity">Channel type record identifier</param>
		/// <param name="segmentIdentity">Segment record identifier</param>
		/// <param name="productTypeIdentity">Product type record identifier</param>
		/// <param name="productName">Product name</param>
		/// <param name="userId">User record identifier</param>
		/// <param name="dateCreated">Date created</param>
		/// <param name="isTermRange">Term range indicator</param>
		/// <param name="relativeStartMonth">Relative start month</param>
		/// <param name="productBrandID">Product brand record identifier</param>
		/// <returns>Returns a dataset containing the product configuration data with record identity.</returns>
		public static DataSet InsertProductConfiguration( int productConfigurationID, string name, int marketIdentity, int utilityIdentity,
			int zoneIdentity, int serviceClassIdentity, int channelTypeIdentity, int segmentIdentity,
			int productTypeIdentity, string productName, int userId, DateTime dateCreated, int isTermRange,
			int relativeStartMonth, int productBrandID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationInsert";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );
					cmd.Parameters.Add( new SqlParameter( "@Name", name ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketIdentity ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityIdentity ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneIdentity ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassIdentity ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeIdentity ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentIdentity ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeIdentity ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductName", productName ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", userId ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@IsTermRange", isTermRange ) );
					cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeStartMonth ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts offer term
		/// </summary>
		/// <param name="productConfigurationID">Product configuration record identifier</param>
		/// <param name="term">Term (in months)</param>
		/// <param name="isActive">Active indicator</param>
		/// <param name="lowerTerm">Lower term</param>
		/// <param name="upperTerm">Upper term</param>
		/// <param name="userID">User record identifier</param>
		/// <returns>Returns a dataset containing the offer term with identity.</returns>
		public static DataSet InsertOfferTerm( int productConfigurationID, int term, int isActive,
			int? lowerTerm, int? upperTerm, int userID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_OfferActivationInsert";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", isActive ) );
					cmd.Parameters.Add( new SqlParameter( "@UserID", userID ) );
					cmd.Parameters.Add( new SqlParameter( "@LowerTerm", lowerTerm ) );
					cmd.Parameters.Add( new SqlParameter( "@UpperTerm", upperTerm ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets offer terms for specified product configuration ID
		/// </summary>
		/// <param name="productConfigurationID">Product configuration record identifier</param>
		/// <returns>Returns a dataset conatining offer terms for specified product configuration ID.</returns>
		public static DataSet GetOfferTermsForProductConfiguration( int productConfigurationID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_OfferActivationByProductConfigurationIDSelect";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets offer terms
		/// </summary>
		/// <returns>Returns a dataset conatining offer terms.</returns>
		public static DataSet GetOfferTerms()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_OfferActivationsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct channel types in product configuration table
		/// </summary>
		/// <returns>Returns distinct channel types in product configuration table.</returns>
		public static DataSet GetProductConfigurationChannelTypes()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationChannelTypesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct markets in product configuration table
		/// </summary>
		/// <returns>Returns distinct markets in product configuration table.</returns>
		public static DataSet GetProductConfigurationMarkets()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationMarketsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct product types in product configuration table
		/// </summary>
		/// <returns>Returns distinct product types in product configuration table.</returns>
		public static DataSet GetProductConfigurationProductTypes()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationProductTypesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct product types in product configuration table
		/// </summary>
		/// <returns>Returns distinct product types in product configuration table.</returns>
		public static DataSet GetProductConfigurationProductNames()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationProductNamesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct product in product configuration table
		/// </summary>
		/// <returns>Returns distinct product in product configuration table.</returns>
		public static DataSet GetProductConfigurationProducts()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationProductsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct segments in product configuration table
		/// </summary>
		/// <returns>Returns distinct segments in product configuration table.</returns>
		public static DataSet GetProductConfigurationSegments()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationSegmentsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct service classes in product configuration table
		/// </summary>
		/// <returns>Returns distinct service classes in product configuration table.</returns>
		public static DataSet GetProductConfigurationServiceClasses()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationServiceClassesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct terms in offer activation table
		/// </summary>
		/// <returns>Returns distinct terms in offer activation table.</returns>
		public static DataSet GetProductConfigurationTerms()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationTermsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct utilities in product configuration table
		/// </summary>
		/// <returns>Returns distinct utilities in product configuration table.</returns>
		public static DataSet GetProductConfigurationUtilities()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationUtilitiesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct zones in product configuration table
		/// </summary>
		/// <returns>Returns distinct zones in product configuration table.</returns>
		public static DataSet GetProductConfigurationZones()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationZonesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct product names in product configuration table
		/// </summary>
		/// <returns>Returns distinct product names in product configuration table.</returns>
		public static DataSet GetProductConfigurationNames()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationNamesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct product names in product configuration table
		/// </summary>
		/// <returns>Returns distinct product names in product configuration table.</returns>
		public static DataSet GetProductConfigurationRelativeStartMonths()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationRelStartMonthsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets distinct created dates in product configuration table
		/// </summary>
		/// <returns>Returns distinct created dates in product configuration table.</returns>
		public static DataSet GetProductConfigurationDatesCreated()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationDatesCreatedSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the daily pricing template configuration data.
		/// </summary>
		/// <returns>Returns a dataset containing the daily pricing template configuration data.</returns>
		public static DataSet GetDailyPricingTemplateConfiguration()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingTemplateConfigurationSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the daily pricing template tag data.
		/// </summary>
		/// <returns>Returns a dataset containing the daily pricing template tag data.</returns>
		public static DataSet GetDailyPricingTemplateTags()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingTemplateTagsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the max term for specified parameters
		/// </summary>
		/// <param name="marketID">Market record identifier</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="zoneID">Zone record identifier</param>
		/// <param name="serviceClassID">Service class record identifier</param>
		/// <param name="segmentID">Segment record identifier</param>
		/// <param name="productTypeID">Product type record identifier</param>
		/// <returns>Returns a dataset containing the max term for specified parameters.</returns>
		public static DataSet GetMaxTerms( int marketID, int utilityID, int zoneID,
			int serviceClassID, int segmentID, int productTypeID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingMaxTermsSelect";

					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the max relative start month for specified parameters
		/// </summary>
		/// <param name="marketID">Market record identifier</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="zoneID">Zone record identifier</param>
		/// <param name="serviceClassID">Service class record identifier</param>
		/// <param name="segmentID">Segment record identifier</param>
		/// <param name="productTypeID">Product type record identifier</param>
		/// <returns>Returns a dataset containing the max relative start month for specified parameters.</returns>
		public static DataSet GetMaxRelativeStartMonth( int marketID, int utilityID, int zoneID,
			int serviceClassID, int segmentID, int productTypeID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingMaxRelativeStartMonthSelect";

					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		#endregion Product Configuration Methods


		#region Deal Capture

		/// <summary>
		/// Gets custom products for specified sales channel
		/// </summary>
		/// <param name="salesChannel">Sales channel</param>
		/// <returns>Returns a dataset containing custom products for specified sales channel.</returns>
		public static DataSet GetDealPricingBySalesChannel( string salesChannel )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DealPricingBySalesChannelSelect";

					cmd.Parameters.Add( new SqlParameter( "@SalesChannel", salesChannel ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets segment ID from legacy account type ID
		/// </summary>
		/// <param name="accountTypeID">Legacy account type ID</param>
		/// <param name="convertTo">Which way to convert (segment to legacy or vice versa)</param>
		/// <returns>Returns a dataset that conatins the segment ID from legacy account type ID.</returns>
		public static DataSet ConvertAccountTypeID( int accountTypeID, string convertTo )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ConvertAccountTypeID";

					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ConvertTo", convertTo ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetProductAndRateId( int marketID, int utilityID, int zoneID, int serviceClassID, int term, int accountTypeID, int productTypeID, int channelTypeID,
			int relativeStartMonth, int channelGroupID, int productBrandID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingProductAndRateIdSelect";

					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeStartMonth ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		#endregion Deal Capture


		#region Product Offer Methods

		/// <summary>
		/// Gets offer terms for specified offer activation ID
		/// </summary>
		/// <param name="offerActivationID">Offer activation record identifier</param>
		/// <returns>Returns a dataset conatining offer terms for specified offer activation ID.</returns>
		public static DataSet GetOfferTerms( int offerActivationID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_OfferActivationSelect";

					cmd.Parameters.Add( new SqlParameter( "@OfferActivationID", offerActivationID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets product offers
		/// </summary>
		/// <returns>Returns a dataset containing product offers.</returns>
		public static DataSet GetProductOffers()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductOffersSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetProductOffers( int rowStart, int rowEnd, string sortBy, string sortDirection, int marketID, int utilityID,
			int zoneID, int serviceClassID, int channelTypeID, int productTypeID, string productName, int segmentID, int isActive, out int rowCount )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductOffersSelect";

					SqlParameter paramRowCount = new SqlParameter( "@RowCount", 0 );
					paramRowCount.Direction = ParameterDirection.Output;

					cmd.Parameters.Add( new SqlParameter( "@RowStart", rowStart ) );
					cmd.Parameters.Add( new SqlParameter( "@RowEnd", rowEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@SortBy", sortBy ) );
					cmd.Parameters.Add( new SqlParameter( "@SortDirection", sortDirection ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductName", productName ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", isActive ) );

					cmd.Parameters.Add( paramRowCount );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );

					rowCount = Convert.ToInt32( paramRowCount.Value );
				}
			}
			return ds;
		}

		public static DataSet GetProductOffers( int rowStart, int rowEnd, string sortBy, string sortDirection, int marketID, int utilityID, int zoneID,
			int serviceClassID, int channelTypeID, int productTypeID, string productName, int segmentID, int isActive, out int rowCount, int productBrandID, int channelID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductOffersSelect";

					SqlParameter paramRowCount = new SqlParameter( "@RowCount", 0 );
					paramRowCount.Direction = ParameterDirection.Output;

					cmd.Parameters.Add( new SqlParameter( "@RowStart", rowStart ) );
					cmd.Parameters.Add( new SqlParameter( "@RowEnd", rowEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@SortBy", sortBy ) );
					cmd.Parameters.Add( new SqlParameter( "@SortDirection", sortDirection ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductName", productName ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", isActive ) );
                    cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID));

					cmd.Parameters.Add( paramRowCount );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );

					rowCount = Convert.ToInt32( paramRowCount.Value );
				}
			}
			return ds;
		}

        public static DataSet GetProductOffers(int rowStart, int rowEnd, string sortBy, string sortDirection, int marketID, int utilityID, int zoneID,
            int serviceClassID, int channelTypeID, int productTypeID, string productName, int segmentID, int isActive, out int rowCount, int productBrandID, int channelID, int term)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ProductOffersSelect";

                    SqlParameter paramRowCount = new SqlParameter("@RowCount", 0);
                    paramRowCount.Direction = ParameterDirection.Output;

                    cmd.Parameters.Add(new SqlParameter("@RowStart", rowStart));
                    cmd.Parameters.Add(new SqlParameter("@RowEnd", rowEnd));
                    cmd.Parameters.Add(new SqlParameter("@SortBy", sortBy));
                    cmd.Parameters.Add(new SqlParameter("@SortDirection", sortDirection));
                    cmd.Parameters.Add(new SqlParameter("@MarketID", marketID));
                    cmd.Parameters.Add(new SqlParameter("@UtilityID", utilityID));
                    cmd.Parameters.Add(new SqlParameter("@ZoneID", zoneID));
                    cmd.Parameters.Add(new SqlParameter("@ServiceClassID", serviceClassID));
                    cmd.Parameters.Add(new SqlParameter("@ChannelTypeID", channelTypeID));
                    cmd.Parameters.Add(new SqlParameter("@ProductTypeID", productTypeID));
                    cmd.Parameters.Add(new SqlParameter("@ProductBrandID", productBrandID));
                    cmd.Parameters.Add(new SqlParameter("@ProductName", productName));
                    cmd.Parameters.Add(new SqlParameter("@SegmentID", segmentID));
                    cmd.Parameters.Add(new SqlParameter("@IsActive", isActive));
                    cmd.Parameters.Add(new SqlParameter("@ChannelID", channelID));
                    cmd.Parameters.Add(new SqlParameter("@Term", term));

                    cmd.Parameters.Add(paramRowCount);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);

                    rowCount = Convert.ToInt32(paramRowCount.Value);
                }
            }
            return ds;
        }

		public static DataSet GetProductOffer( int marketID, int utilityID, int zoneID, int serviceClassID, int channelTypeID, int productTypeID, int productBrandID, int segmentID, int isActive )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductOfferSelect";

					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", isActive ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetProductOffersForValidation( int segmentID, int channelTypeID,
			int productTypeID, int marketID, int utilityID, int zoneID, int serviceClassID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductOffersForValidationSelect";

					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Updates active status for specified offer activation record
		/// </summary>
		/// <param name="offerActivationID">Offer activation record identifier</param>
		/// <param name="isActive">Active indicator</param>
		/// <param name="userID">User record identifier</param>
		/// <returns>Returns a dataset containing the offer activation record that was updated.</returns>
		public static DataSet UpdateProductOfferStatus( int offerActivationID, int isActive, int userID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductOfferStatusUpdate";

					cmd.Parameters.Add( new SqlParameter( "@OfferActivationID", offerActivationID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", isActive ) );
					cmd.Parameters.Add( new SqlParameter( "@UserID", userID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets active offer prices
		/// </summary>
		/// <returns>Returns a dataset containing active offer prices.</returns>
		public static DataSet GetActiveProductOffers()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 3600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductOffersActiveSelect";
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets active offer prices for specified market ID
		/// </summary>
		/// <param name="marketID">Market record identifier</param>
		/// <returns>Returns a dataset containing active offer prices for specified market ID.</returns>
		public static DataSet GetActiveProductOffersByMarket( int marketID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductOffersActiveByMarketSelect";

					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets product cross prices for active offers
		/// </summary>
		/// <param name="productCrossPriceSetId">The product cross price set id.</param>
		/// <returns>Returns a dataset containing product cross prices for active offers.</returns>
		public static DataSet GetProductCrossPricesForActiveOffers( int productCrossPriceSetId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceForActiveOffersSelect";

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetId", productCrossPriceSetId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts daily pricing sheet file data
		/// </summary>
		/// <param name="fileGuid">File identifier in managed storage</param>
		/// <param name="file">File</param>
		/// <param name="originalFileName">Original file name</param>
		/// <param name="salesChannelID">Sales channel ID</param>
		/// <param name="fileDate">File date</param>
		/// <returns>Returns a dataset containing daily pricing sheet file data with record identifier.</returns>
		public static DataSet InsertDailyPricingSheetFile( string fileGuid, string file, string originalFileName, int salesChannelID, DateTime fileDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetFileInsert";

					cmd.Parameters.Add( new SqlParameter( "@FileGuid", fileGuid ) );
					cmd.Parameters.Add( new SqlParameter( "@File", file ) );
					cmd.Parameters.Add( new SqlParameter( "@OriginalFileName", originalFileName ) );
					cmd.Parameters.Add( new SqlParameter( "@SalesChannelID", salesChannelID ) );
					cmd.Parameters.Add( new SqlParameter( "@FileDate", fileDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily pricing sheet file data for specified daily pricing sheet file ID.
		/// </summary>
		/// <param name="dailyPricingSheetFileID">Daily pricing sheet file ID</param>
		/// <returns>Returns a dataset containing daily pricing sheet file data for specified daily pricing sheet file ID.</returns>
		public static DataSet GetDailyPricingSheetFileById( int dailyPricingSheetFileID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetFileByIdSelect";

					cmd.Parameters.Add( new SqlParameter( "@DailyPricingSheetFileID", dailyPricingSheetFileID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily pricing sheet file data for specified file date
		/// </summary>
		/// <param name="fileDate">File date</param>
		/// <returns>Returns a dataset containing daily pricing sheet file data for specified file date.</returns>
		public static DataSet GetDailyPricingSheetFiles( DateTime fileDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetFilesSelect";

					cmd.Parameters.Add( new SqlParameter( "@FileDate", fileDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily pricing sheet file data for specified file date and sales channel
		/// </summary>
		/// <param name="salesChannelId">The sales channel id.</param>
		/// <returns>
		/// Returns a dataset containing daily pricing sheet file data for specified file date.
		/// </returns>
		public static DataSet GetDailyPricingSheetFiles( int salesChannelId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetFilesSelectByChannelID";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", salesChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily pricing sheet file data for specified file date and sales channel
		/// </summary>
		/// <param name="salesChannelId">The sales channel id.</param>
		/// <param name="priceSheetDate">The date the pricesheet was generated for the given channel.</param>
		/// <returns>
		/// Returns a dataset containing daily pricing sheet file data for specified file date.
		/// </returns>
		public static DataSet GetDailyPricingSheetFilesByDate( int salesChannelId, DateTime priceSheetDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetFilesSelectByChannelIDByDate";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", salesChannelId ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceSheetDate", priceSheetDate.Date ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily pricing sheet file data generated on demand for specified sales channel
		/// </summary>
		/// <param name="salesChannelId">The sales channel id.</param>
		/// <returns>
		/// Returns a dataset containing daily pricing sheet file data generated on demand 
		/// for specified sales channel.
		/// </returns>
		public static DataSet GetDailyPricingSheetFilesOnDemand( int salesChannelId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetFilesOnDemandSelectByChannelID";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", salesChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily pricing sheet file queue records for specified file sent indicator
		/// </summary>
		/// <param name="fileSent">File sent status (0 = not sent, 1= sent)</param>
		/// <returns>Returns a dataset containing daily pricing sheet file queue records for specified file sent indicator.</returns>
		public static DataSet GetDailyPricingSheetFileQueue( int fileSent )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetFileQueueSelect";

					cmd.Parameters.Add( new SqlParameter( "@FileSent", fileSent ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Clears the daily pricing sheet file queue records of unsent records
		/// </summary>
		public static int ClearDailyPricingSheetFileQueue()
		{
			int recordsAffected = 0;
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetFileQueueClearUnsent";

					cn.Open();
					recordsAffected = cmd.ExecuteNonQuery();
				}
			}
			return recordsAffected;
		}

		/// <summary>
		/// Inserts daily pricing sheet file record identifier and file sent status in to queue
		/// </summary>
		/// <param name="dailyPricingSheetFileID">Daily pricing sheet file record identifier</param>
		/// <param name="fileSent">File sent status (0 = not sent, 1= sent)</param>
		/// <returns></returns>
		public static DataSet InsertDailyPricingSheetFileQueue( int dailyPricingSheetFileID, int fileSent )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetFileQueueInsert";

					cmd.Parameters.Add( new SqlParameter( "@DailyPricingSheetFileID", dailyPricingSheetFileID ) );
					cmd.Parameters.Add( new SqlParameter( "@FileSent", fileSent ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Updates daily pricing sheet file queue
		/// </summary>
		/// <param name="dailyPricingSheetFileQueueID">daily pricing sheet file queue record identifier</param>
		/// <param name="fileSent">File sent status (0 = not sent, 1= sent)</param>
		/// <param name="dateSent">Date sent</param>
		/// <returns>Returns a dataset containing daily pricing sheet file queue data for specified queue record identifier.</returns>
		public static DataSet UpdateDailyPricingSheetFileQueue( int dailyPricingSheetFileQueueID, int fileSent, DateTime dateSent )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetFileQueueUpdate";

					cmd.Parameters.Add( new SqlParameter( "@DailyPricingSheetFileQueueID", dailyPricingSheetFileQueueID ) );
					cmd.Parameters.Add( new SqlParameter( "@FileSent", fileSent ) );
					cmd.Parameters.Add( new SqlParameter( "@DateSent", dateSent ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inesrts the daily pricing sheet history.
		/// </summary>
		/// <param name="fileCount">The file count.</param>
		/// <param name="generatedBy">The generated by.</param>
		/// <returns></returns>
		public static DataSet InesrtDailyPricingSheetHistory( int fileCount, int generatedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetHistoryInsert";

					cmd.Parameters.Add( new SqlParameter( "@Count", fileCount ) );
					cmd.Parameters.Add( new SqlParameter( "@GeneratedBy", generatedBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the daily pricing sheet history.
		/// </summary>
		/// <param name="dateFrom">The date from.</param>
		/// <param name="dateTo">The date to.</param>
		/// <returns></returns>
		public static DataSet GetDailyPricingSheetHistory( DateTime dateFrom, DateTime dateTo )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetHistorySelect";

					cmd.Parameters.Add( new SqlParameter( "@DateFrom", dateFrom ) );
					cmd.Parameters.Add( new SqlParameter( "@DateTo", dateTo ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}



		#endregion Product Offer Methods


		#region CrossProduct Methods

		/// <summary>
		/// Get CrossProductSet by crossProductSetID
		/// </summary>
		/// <param name="crossProductSetID">The crossProductSet ID.</param>
		/// <returns></returns>
		public static DataSet CrossProductSetGet( int crossProductSetID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceSetGetById";

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", crossProductSetID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Crosses the product set get by effective date.
		/// </summary>
		/// <param name="effectiveDate">The effective date.</param>
		/// <returns></returns>
		public static DataSet CrossProductSetGet( DateTime effectiveDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceSetGetByDate";

					cmd.Parameters.Add( new SqlParameter( "@EffectiveDate", effectiveDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Get the current CrossProductSet
		/// </summary>
		/// <returns></returns>
		public static DataSet CrossProductSetGetCurrent()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceSetGetCurrent";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts a CrossProductSet .
		/// </summary>
		/// <param name="effectiveDate">The effective date.</param>
		/// <param name="expirationDate">The expiration date.</param>
		/// <param name="createdBy">The created by.</param>
		/// <returns></returns>
		public static DataSet CrossProductSetInsert( DateTime effectiveDate, DateTime expirationDate, int createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceSetInsert";

					cmd.Parameters.Add( new SqlParameter( "@EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ExpirationDate", expirationDate ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );


					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;

		}

		/// <summary>
		/// Updates a CrossProductSet .
		/// </summary>
		/// <param name="productCrossPriceSetID">Product cross price set record identifier.</param>
		/// <param name="effectiveDate">The effective date.</param>
		/// <param name="expirationDate">The expiration date.</param>
		/// <returns></returns>
		public static DataSet CrossProductSetUpdate( int productCrossPriceSetID, DateTime effectiveDate, DateTime expirationDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceSetUpdate";
					cmd.CommandTimeout = 600; // Wait at least 600 Seconds (10 minutes) before timeout

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetID ) );
					cmd.Parameters.Add( new SqlParameter( "@EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ExpirationDate", expirationDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;

		}


		/// <summary>
		/// Archives all expired cross product prices to a history table and
		/// then deletes the expired records from the live table.
		/// </summary>
		public static void CrossProductArchive()
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceArchive";
					cmd.CommandTimeout = 600; // Wait at least 600 Seconds (10 minutes) before timeout

					cn.Open();
					cmd.ExecuteNonQuery();
					cn.Close();
				}
			}
		}

		/// <summary>
		/// Get CrossProduct records by Id.
		/// </summary>
		/// <param name="productCrossPriceId">The product cross price id.</param>
		/// <returns></returns>
		public static DataSet CrossProductGet( int productCrossPriceId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceGetById";

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceID", productCrossPriceId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Get CrossProduct records by setId.
		/// </summary>
		/// <param name="productCrossPriceSetId">The product cross price set id.</param>
		/// <returns></returns>
		public static DataSet CrossProductGetBySetId( int productCrossPriceSetId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceGetBySetId";
					cmd.CommandTimeout = 600; // Wait at least 600 Seconds (10 minutes) before timeout

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets current cross product prices for specified channel group.
		/// </summary>
		/// <param name="channelGroupId">Channel group ID.</param>
		/// <param name="productCrossPriceSetId">The product cross price set id.</param>
		/// <returns>Returns a dataset containing current cross product prices for specified channel group.</returns>
		public static DataSet GetCrossProductGetByChanelGroupId( int channelGroupId, int productCrossPriceSetId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceByChannelGroupIDSelect";
					cmd.CommandTimeout = 180; // Wait 3 minutes before timeout

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetId ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Insert a CrossProduct.
		/// </summary>
		/// <param name="productCrossPriceSetId">The product cross price set id.</param>
		/// <param name="productMarkupRuleId">The product markup rule id.</param>
		/// <param name="productCostRuleId">The product cost rule id.</param>
		/// <param name="productTypeID">The product id.</param>
		/// <param name="marketId">The market id.</param>
		/// <param name="utilityId">The utility id.</param>
		/// <param name="segmentId">Segment ID</param>
		/// <param name="zoneId">The zone id.</param>
		/// <param name="serviceClassId">The service class id.</param>
		/// <param name="channelTypeId">The channel type id.</param>
		/// <param name="channelGroupId">The channel group id.</param>
		/// <param name="costRateEffectiveDate">The cost rate effective date.</param>
		/// <param name="startDate">The start date.</param>
		/// <param name="term">The term.</param>
		/// <param name="costRateExpirationDate">The cost rate expiration date.</param>
		/// <param name="markupRate">The markup rate.</param>
		/// <param name="costRate">The cost rate.</param>
		/// <param name="commissionsRate">The commissions rate.</param>
		/// <param name="por">The por.</param>
		/// <param name="grt">The GRT.</param>
		/// <param name="sut">The sut.</param>
		/// <param name="price">The price.</param>
		/// <param name="rateCodeId">Rate code ID</param>
		/// <param name="createdBy">The created by.</param>
		/// <param name="priceTier">Price tier</param>
		/// <returns></returns>
		public static DataSet CrossProductInsert( int productCrossPriceSetId, int productMarkupRuleId, int productCostRuleId, int productTypeID, int marketId, int utilityId, int segmentId
					, int zoneId, int serviceClassId, int channelTypeId, int channelGroupId, DateTime costRateEffectiveDate, DateTime startDate, int term, DateTime costRateExpirationDate
					, decimal markupRate, decimal costRate, decimal commissionsRate, decimal por, decimal grt, decimal sut, decimal price, decimal rateCodeId, int createdBy, int priceTier )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceInsert";

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductMarkupRuleID", productMarkupRuleId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCostRuleID", productCostRuleId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketId ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentId ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneId ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassId ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupId ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateEffectiveDate", costRateEffectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@StartDate", startDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateExpirationDate", costRateExpirationDate ) );
					cmd.Parameters.Add( new SqlParameter( "@MarkupRate", markupRate ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRate", costRate ) );
					cmd.Parameters.Add( new SqlParameter( "@CommissionsRate", commissionsRate ) );
					cmd.Parameters.Add( new SqlParameter( "@POR", por ) );
					cmd.Parameters.Add( new SqlParameter( "@GRT", grt ) );
					cmd.Parameters.Add( new SqlParameter( "@SUT", sut ) );
					cmd.Parameters.Add( new SqlParameter( "@Price", price ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
					cmd.Parameters.Add( new SqlParameter( "@RateCodeID", (rateCodeId != 0) ? (object) rateCodeId : (object) DBNull.Value ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceTier", priceTier ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Insert a CrossProduct.
		/// </summary>
		/// <param name="productCrossPriceSetId">The product cross price set id.</param>
		/// <param name="productMarkupRuleId">The product markup rule id.</param>
		/// <param name="productCostRuleId">The product cost rule id.</param>
		/// <param name="productTypeID">The product id.</param>
		/// <param name="marketId">The market id.</param>
		/// <param name="utilityId">The utility id.</param>
		/// <param name="segmentId">Segment ID</param>
		/// <param name="zoneId">The zone id.</param>
		/// <param name="serviceClassId">The service class id.</param>
		/// <param name="channelTypeId">The channel type id.</param>
		/// <param name="channelGroupId">The channel group id.</param>
		/// <param name="costRateEffectiveDate">The cost rate effective date.</param>
		/// <param name="startDate">The start date.</param>
		/// <param name="term">The term.</param>
		/// <param name="costRateExpirationDate">The cost rate expiration date.</param>
		/// <param name="markupRate">The markup rate.</param>
		/// <param name="costRate">The cost rate.</param>
		/// <param name="commissionsRate">The commissions rate.</param>
		/// <param name="por">The por.</param>
		/// <param name="grt">The GRT.</param>
		/// <param name="sut">The sut.</param>
		/// <param name="price">The price.</param>
		/// <param name="rateCodeId">Rate code ID</param>
		/// <param name="createdBy">The created by.</param>
		/// <param name="priceTier">Price tier record identifier</param>
		/// <param name="productBrandID">Price brand record identifier</param>
		/// <returns></returns>
		public static DataSet CrossProductInsert( int productCrossPriceSetId, int productMarkupRuleId, int productCostRuleId, int productTypeID, int marketId, int utilityId, int segmentId
					, int zoneId, int serviceClassId, int channelTypeId, int channelGroupId, DateTime costRateEffectiveDate, DateTime startDate, int term, DateTime costRateExpirationDate
					, decimal markupRate, decimal costRate, decimal commissionsRate, decimal por, decimal grt, decimal sut, decimal price, decimal rateCodeId, int createdBy, int priceTier, int productBrandID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceInsert";

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductMarkupRuleID", productMarkupRuleId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCostRuleID", productCostRuleId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketId ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentId ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneId ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassId ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupId ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateEffectiveDate", costRateEffectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@StartDate", startDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateExpirationDate", costRateExpirationDate ) );
					cmd.Parameters.Add( new SqlParameter( "@MarkupRate", markupRate ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRate", costRate ) );
					cmd.Parameters.Add( new SqlParameter( "@CommissionsRate", commissionsRate ) );
					cmd.Parameters.Add( new SqlParameter( "@POR", por ) );
					cmd.Parameters.Add( new SqlParameter( "@GRT", grt ) );
					cmd.Parameters.Add( new SqlParameter( "@SUT", sut ) );
					cmd.Parameters.Add( new SqlParameter( "@Price", price ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
					cmd.Parameters.Add( new SqlParameter( "@RateCodeID", (rateCodeId != 0) ? (object) rateCodeId : (object) DBNull.Value ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceTier", priceTier ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Updates the CommonProductRate based on the Cross Product.
		/// </summary>
		public static void CommonProductRatePriceUpdate()
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingUpdateCommonProductRate";

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Commons the product rate active update.
		/// </summary>
		public static void CommonProductRateActiveUpdate( int offerActivationID, bool isInactive )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingUpdateCommonProductRateInactiveInd";

					cmd.Parameters.Add( new SqlParameter( "@OfferActivationID", offerActivationID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsInactive", isInactive ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Loads the Cross PRoduct table from stage table for given priceSet.
		/// </summary>
		/// <param name="priceSetId">The price set id.</param>
		public static void CrossProductListLoadFromStage( int priceSetId )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceBulkLoad";

					cmd.Parameters.Add( new SqlParameter( "@PriceSetId", priceSetId ) );
					cmd.CommandTimeout = 600; // Wait at least 600 Seconds (10 minutes) before timeout

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Clears out records from the Stage table by set id.
		/// </summary>
		/// <param name="priceSetId">The price set id.</param>
		public static void CrossProductStageClearBySetId( int priceSetId )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceStageClearSet";

					cmd.Parameters.Add( new SqlParameter( "@PriceSetId", priceSetId ) );
					cmd.CommandTimeout = 600; // Wait at least 600 Seconds (10 minutes) before timeout

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Clears the Cross Product Stage table of any outdated records.
		/// </summary>
		/// <param name="maxDateToKeep">The max date to keep.</param>
		public static void CrossProductStageClearOutdated( DateTime maxDateToKeep )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceStageClearOutdated";

					cmd.Parameters.Add( new SqlParameter( "@MaxCreatedDate", maxDateToKeep ) );
					cmd.CommandTimeout = 600; // Wait at least 600 Seconds (10 minutes) before timeout

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}


		/// <summary>
		/// Performs a bulk insert of CrossProductPrices into the database.
		/// </summary>
		/// <param name="dt">The data table.</param>
		public static void CrossProductListInsert( DataTable dt )
		{
			string connStr = Helper.ConnectionString;
			int batchSize = dt.Rows.Count;

			using( SqlConnection connection = new SqlConnection( connStr ) )
			{
				connection.Open();

				// Set up the bulk copy object. 
				// Note that the column positions in the source data reader match the column positions in 
				// the destination table so there is no need to map columns.
				using( SqlBulkCopy bulkCopy = new SqlBulkCopy( connection ) )
				{
					#region Column Mappings
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ProductCrossPriceSetID", "ProductCrossPriceSetID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ProductMarkupRuleID", "ProductMarkupRuleID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ProductCostRuleID", "ProductCostRuleID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ProductTypeID", "ProductTypeID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "MarketID", "MarketID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "UtilityID", "UtilityID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "SegmentID", "SegmentID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ZoneID", "ZoneID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ServiceClassID", "ServiceClassID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ChannelTypeID", "ChannelTypeID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ChannelGroupID", "ChannelGroupID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "CostRateEffectiveDate", "CostRateEffectiveDate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "StartDate", "StartDate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Term", "Term" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "CostRateExpirationDate", "CostRateExpirationDate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "MarkupRate", "MarkupRate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "CostRate", "CostRate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "CommissionsRate", "CommissionsRate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "POR", "POR" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "GRT", "GRT" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "SUT", "SUT" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Price", "Price" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "CreatedBy", "CreatedBy" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "DateCreated", "DateCreated" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "RateCodeID", "RateCodeID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "PriceTier", "PriceTier" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ProductBrandID", "ProductBrandID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "GreenRate", "GreenRate" ) );
					#endregion

					bulkCopy.BulkCopyTimeout = 86400; // one day
					bulkCopy.BatchSize = batchSize;
					bulkCopy.DestinationTableName = "dbo.ProductCrossPrice";
					bulkCopy.WriteToServer( dt );
				}
			}
		}

		#endregion CrossProduct Methods


		#region DailyPricingLog Methods

		/// <summary>
		/// Inserts a DailyPricingLog record.
		/// </summary>
		/// <param name="messageType">Type of the message.</param>
		/// <param name="dailyPricingModule">The daily pricing module.</param>
		/// <param name="message">The message.</param>
		/// <param name="stackTrace">The stack trace of error.</param>
		/// <param name="userID">User record identifier</param>
		/// <returns></returns>
		public static DataSet DailyPricingLogInsert( int messageType, int dailyPricingModule,
			string message, string stackTrace, int userID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingLogInsert";

					cmd.Parameters.Add( new SqlParameter( "@MessageType", messageType ) );
					cmd.Parameters.Add( new SqlParameter( "@DailyPricingModule", dailyPricingModule ) );
					cmd.Parameters.Add( new SqlParameter( "@Message", message ) );
					cmd.Parameters.Add( new SqlParameter( "@StackTrace", stackTrace ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", userID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts a DailyPricingLog record.
		/// </summary>
		/// <param name="messageType">Type of the message.</param>
		/// <param name="dailyPricingModule">The daily pricing module.</param>
		/// <param name="message">The message.</param>
		/// <param name="stackTrace">The stack trace of error.</param>
		/// <param name="userID">User record identifier</param>
		/// <returns></returns>
		public static DataSet DailyPricingLogInsert_New( int messageType, int dailyPricingModule,
			string message, string stackTrace, int userID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingLogInsert_New";

					cmd.Parameters.Add( new SqlParameter( "@MessageType", messageType ) );
					cmd.Parameters.Add( new SqlParameter( "@DailyPricingModule", dailyPricingModule ) );
					cmd.Parameters.Add( new SqlParameter( "@Message", message ) );
					cmd.Parameters.Add( new SqlParameter( "@StackTrace", stackTrace ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", userID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the DailyPricing Log for a specified date.
		/// </summary>
		/// <param name="logDate">The log date.</param>
		/// <returns></returns>
		public static DataSet DailyPricingLogGet( DateTime logDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingLogByDate";

					cmd.Parameters.Add( new SqlParameter( "@LogDate", logDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the DailyPricing Log for a specified date.
		/// </summary>
		/// <param name="logDate">The log date.</param>
		/// <returns></returns>
		public static DataSet DailyPricingLogGet_New( DateTime logDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingLogByDate_New";

					cmd.Parameters.Add( new SqlParameter( "@LogDate", logDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the DailyPricing Log for a specified date range.
		/// </summary>
		/// <param name="logStartDate">The log start date.</param>
		/// <param name="logEndDate">The log end date.</param>
		/// <returns></returns>
		public static DataSet DailyPricingLogGet( DateTime logStartDate, DateTime logEndDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingLogByDateRange";

					cmd.Parameters.Add( new SqlParameter( "@LogStartDate", logStartDate ) );
					cmd.Parameters.Add( new SqlParameter( "@LogEndDate", logEndDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the DailyPricing Log for a specified date range.
		/// </summary>
		/// <param name="logStartDate">The log start date.</param>
		/// <param name="logEndDate">The log end date.</param>
		/// <returns></returns>
		public static DataSet DailyPricingLogGet_New( DateTime logStartDate, DateTime logEndDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingLogByDateRange_New";

					cmd.Parameters.Add( new SqlParameter( "@LogStartDate", logStartDate ) );
					cmd.Parameters.Add( new SqlParameter( "@LogEndDate", logEndDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		#endregion DailyPricingLog Methods

		#region DailyPricingConfig Methods

		/// <summary>
		/// Inserts a DailyPricingConfiguration record.
		/// </summary>
		/// <param name="autoGeneratePrices">if set to <c>true</c> [auto generate prices].</param>
		/// <param name="autoGeneratePriceSheets">if set to <c>true</c> [auto generate price sheets].</param>
		/// <param name="createdBy">The created by.</param>
		/// <returns></returns>
		public static DataSet DailyPricingConfigurationInsert( bool autoGeneratePrices, bool autoGeneratePriceSheets, int createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingConfigurationInsert";

					cmd.Parameters.Add( new SqlParameter( "@AutoGeneratePrices", autoGeneratePrices ) );
					cmd.Parameters.Add( new SqlParameter( "@AutoGeneratePriceSheets", autoGeneratePriceSheets ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the current DailyPricing Configuration.
		/// </summary>
		/// <returns></returns>
		public static DataSet DailyPricingConfigurationGet()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingConfigurationGetCurrent";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
		#endregion DailyPricingConfig Methods

		#region Legacy Prices

		/// <summary>
		/// Gets all the rate records from the Legacy table.
		/// </summary>
		/// <returns></returns>
		public static void LegacyPricesGet()
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 1800; // wait up to 30 minutes as this proc does significant work.
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricing_GetLegacyRates";

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets the rate records from the Legacy table for specified market.
		/// </summary>
		/// <param name="marketID">Market record identifier.</param>
		/// <returns></returns>
		public static DataSet GetLegacyPricesByMarket( int marketID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricing_GetLegacyRatesByMarket";

					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="marketID"></param>
		/// <param name="utilityID"></param>
		/// <param name="zoneID"></param>
		/// <param name="serviceClassID"></param>
		/// <param name="channelGroupID"></param>
		/// <param name="segmentID"></param>
		/// <param name="channelTypeID"></param>
		/// <param name="productTypeID"></param>
		/// <returns></returns>
		public static DataSet GetMatchingLegacyRates( int marketID, int utilityID, int zoneID, int serviceClassID,
			int channelGroupID, int segmentID, int channelTypeID, int productTypeID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingLegacyRatesTempSelect";

					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Updates the Legacy prices.
		/// </summary>
		/// <param name="productIdentifier">The product identifier.</param>
		/// <param name="rateId">The rate id.</param>
		/// <param name="rate">The rate.</param>
		/// <param name="terms">The terms.</param>
		/// <param name="effectiveDate">The effective date.</param>
		/// <param name="expirationDate">The experation date.</param>
		/// <param name="markup">The markup.</param>
		/// <param name="rateDescription">Rate description</param>
		/// <returns>Count of records affected</returns>
		public static int LegacyPricesUpdate( string productIdentifier, int rateId, decimal rate, int terms,
			DateTime effectiveDate, DateTime expirationDate, Decimal markup, string rateDescription )
		{
			int recordsAffected;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricing_UpdateLegacyRates";
					cmd.CommandTimeout = 360;

					cmd.Parameters.Add( new SqlParameter( "@ProductId", productIdentifier ) );
					cmd.Parameters.Add( new SqlParameter( "@RateId", rateId ) );
					cmd.Parameters.Add( new SqlParameter( "@Rate", rate ) );
					cmd.Parameters.Add( new SqlParameter( "@Terms", terms ) );
					cmd.Parameters.Add( new SqlParameter( "@EffDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@DueDate", expirationDate ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMargin", markup ) );
					cmd.Parameters.Add( new SqlParameter( "@RateDescription", rateDescription ) );

					cn.Open();
					recordsAffected = cmd.ExecuteNonQuery();
				}
			}
			return recordsAffected;
		}

		/// <summary>
		/// Updates the ContractEffectiveDates for all Legacy rates where  the prices update.
		/// </summary>
		/// <returns></returns>
		public static void LegacyPricesUpdateContractEffectiveDate()
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricing_UpdateLegacyRatesContractEffectiveDate_Job";
					cmd.CommandTimeout = 1200; // Wait at least 1200 Seconds (20 minutes) before timeout

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Marks all non custum rates in legacy tables as inactive.
		/// </summary>
		/// <returns>Count of records affected</returns>
		public static int LegacyPricesMarkAllInactive()
		{
			int recordsAffected;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricing_LegacyRatesMarkAllInactive";
					cmd.CommandTimeout = 600; // Wait at least 600 Seconds (10 minutes) before timeout

					cn.Open();
					recordsAffected = cmd.ExecuteNonQuery();
				}
			}
			return recordsAffected;
		}

		/// <summary>
		/// Creates the legacy rate ids for product.
		/// </summary>
		/// <param name="marketId">The market id.</param>
		/// <param name="utilityId">The utility id.</param>
		/// <param name="segmentId">The segment id.</param>
		/// <param name="productTypeId">The product type id.</param>
		/// <param name="zoneId">The zone id.</param>
		/// <param name="serviceClassId">The service class id.</param>
		/// <param name="channelTypeId">The channel type id.</param>
		public static int CreateLegacyRateIdsForProduct( int marketId, int utilityId, int? segmentId, int? productTypeId, int? zoneId, int? serviceClassId, int? channelTypeId )
		{
			int recordsAffected;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingAddLegacyRateIdsForMissingProducts";

					cmd.Parameters.Add( new SqlParameter( "@Market", marketId ) );
					cmd.Parameters.Add( new SqlParameter( "@Utility", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "@Segment", (object) segmentId ?? (object) DBNull.Value ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductType", (object) productTypeId ?? (object) DBNull.Value ) );
					cmd.Parameters.Add( new SqlParameter( "@Zone", (object) zoneId ?? (object) DBNull.Value ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClass", (object) serviceClassId ?? (object) DBNull.Value ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelType", (object) channelTypeId ?? (object) DBNull.Value ) );

					cmd.CommandTimeout = 600; // Wait at least 600 Seconds (10 minutes) before timeout

					cn.Open();
					recordsAffected = cmd.ExecuteNonQuery();
				}
			}
			return recordsAffected;
		}

		/// <summary>
		/// Inserts data specified in parameter
		/// </summary>
		/// <param name="insertStatement">Insert statement containing data</param>
		public static void InsertDailyPricingUpdateLegacyRatesStageData( string insertStatement )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.Text;
					cmd.CommandText = insertStatement;

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Truncates stage table
		/// </summary>
		/// <param name="tableName">Name of stage table</param>
		public static void TruncateDailyPricingUpdateLegacyRatesStage( string tableName )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.Text;
					cmd.CommandText = "TRUNCATE TABLE " + tableName;

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Kicks off a job that will update legacy rates
		/// </summary>
		public static void LegacyPricesUpdateJobStart()
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingUpdateLegacyRatesJobCall";

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}


		#endregion


		#region Workflow

		/// <summary>
		/// Gets daily pricing calendar data up to and including specified date
		/// </summary>
		/// <param name="date">Date</param>
		/// <returns>Returns a dataset containing daily pricing calendar 
		/// data up to and including specified date.</returns>
		public static DataSet GetDailyPricingCalendarUpToDate( DateTime date )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingCalendarUpToDateSelect";

					cmd.Parameters.Add( new SqlParameter( "@Date", date ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Updates "is in queue" flag for specified calendar identity
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <param name="isInQueue">Is in queue indicator</param>
		public static void UpdateDailyPricingCalendarIsInQueue( int identity, int isInQueue )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingCalendarIsInQueueUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ID", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@IsInQueue", isInQueue ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Updates "is work day" flag for specified date
		/// </summary>
		/// <param name="date">Calendar date</param>
		/// <param name="isWorkDay">Is work day indicator</param>
		public static void UpdateDailyPricingCalendarIsWorkDayByDate( DateTime date, int isWorkDay )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingCalendarIsWorkDayUpdate";

					cmd.Parameters.Add( new SqlParameter( "@Date", date ) );
					cmd.Parameters.Add( new SqlParameter( "@IsWorkDay", isWorkDay ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets pricing calendar day for specified date
		/// </summary>
		/// <param name="date">Date</param>
		/// <returns>Returns a dataset containing pricing calendar day for specified date.</returns>
		public static DataSet GetDailyPricingCalendarDay( DateTime date )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingCalendarDaySelect";

					cmd.Parameters.Add( new SqlParameter( "@Date", date ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily calendar work days
		/// </summary>
		/// <returns>Returns a dataset containing daily calendar work days.</returns>
		public static DataSet GetDailyPricingCalendarWorkDays()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingCalendarWorkDaysSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the next daily pricing calendar day after specified date
		/// </summary>
		/// <param name="workDay">Work day to get expiration date for</param>
		/// <returns>Returns a dataset containing the next daily pricing calendar day after specified date.</returns>
		public static DataSet GetDailyPricingCalendarNextWorkDay( DateTime workDay )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingCalendarNextWorkDaySelect";

					cmd.Parameters.Add( new SqlParameter( "@Date", workDay ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily pricing workflow configuration data
		/// </summary>
		/// <returns>Returns a datset containing daily pricing workflow configuration data.</returns>
		public static DataSet GetDailyPricingWorkflowConfigurations()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowConfigurationsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily pricing workflow configuration data for specified key
		/// </summary>
		/// <param name="key">Key</param>
		/// <returns>Returns a datset containing daily pricing workflow configuration data for specified key.</returns>
		public static DataSet GetDailyPricingWorkflowConfigurationByKey( int key )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowConfigurationByKeySelect";

					cmd.Parameters.Add( new SqlParameter( "@Key", key ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Updates daily pricing workflow configuration data for specified key
		/// </summary>
		/// <param name="key">Key</param>
		/// <param name="value">Value</param>
		public static void UpdateDailyPricingWorkflowConfiguration( int key, string value )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowConfigurationUpdate";

					cmd.Parameters.Add( new SqlParameter( "@Key", key ) );
					cmd.Parameters.Add( new SqlParameter( "@Value", value ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets daily pricing process configurations
		/// </summary>
		/// <returns>Returns a dataset containing daily pricing process configurations.</returns>
		public static DataSet GetDailyPricingProcessConfigurations()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingProcessConfigurationsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Updates daily pricing process configuration for specified process ID
		/// </summary>
		/// <param name="processId">Process ID</param>
		/// <param name="scheduledRunTime">Scheduled run time</param>
		public static void UpdateDailyPricingProcessConfiguration( int processId, string scheduledRunTime )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingProcessConfigurationUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ProcessId", processId ) );
					cmd.Parameters.Add( new SqlParameter( "@ScheduledRunTime", scheduledRunTime ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets workflows that are in queue but have not been completed
		/// </summary>
		/// <returns>Returns a dataset containing workflows that have not been completed.</returns>
		public static DataSet GetActiveWorkflows()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ActiveWorkflowsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts daily pricing workflow queue header record
		/// </summary>
		/// <param name="calendarIdentity">Daily pricing calendar record identifier</param>
		/// <param name="effectiveDate">Effective date</param>
		/// <param name="expirationDate">Expiration date</param>
		/// <param name="workDay">Work day</param>
		/// <param name="dateCreated">Date created</param>
		/// <param name="createdBy">Created by</param>
		/// <returns>Returns a dataset containing inserted daily pricing workflow queue header data with record identity.</returns>
		public static DataSet InsertDailyPricingWorkflowQueueHeader( int calendarIdentity, DateTime effectiveDate, DateTime expirationDate,
			DateTime workDay, DateTime dateCreated, int createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueHeaderInsert";

					cmd.Parameters.Add( new SqlParameter( "@DailyPricingCalendarIdentity", calendarIdentity ) );
					cmd.Parameters.Add( new SqlParameter( "@EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ExpirationDate", expirationDate ) );
					cmd.Parameters.Add( new SqlParameter( "@WorkDay", workDay ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Sets daily pricing workflow header queue to a running state with date started
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <param name="status">Status indicator (workflow state type enum)</param>
		/// <param name="dateStarted">Date started</param>
		public static void SetDailyPricingWorkflowQueueHeaderStarted( int identity, int status, DateTime dateStarted )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueHeaderSetStarted";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );
					cmd.Parameters.Add( new SqlParameter( "@DateStarted", dateStarted ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Updates the daily pricing workflow queue header record
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <param name="status">Status indicator (workflow state type enum)</param>
		public static void UpdateDailyPricingWorkflowQueueHeader( int identity, int status )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueHeaderUpdate";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Sets the daily pricing workflow queue header record to completed with time stamp
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <param name="status">Status indicator (workflow state type enum)</param>
		/// <param name="dateCompleted">Date completed</param>
		public static void SetDailyPricingWorkflowQueueHeaderCompleted( int identity, int status, DateTime dateCompleted )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueHeaderSetCompleted";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCompleted", dateCompleted ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Inserts daily pricing workflow queue detail record
		/// </summary>
		/// <param name="workflowHeaderID">Daily pricing workflow queue header record identifier</param>
		/// <param name="processId">Process enum identifier</param>
		/// <param name="scheduledRunTime">Scheduled run time</param>
		/// <returns>Returns a dataset containing inserted daily pricing workflow queue detail data with record identity.</returns>
		public static DataSet InsertDailyPricingWorkflowQueueDetail( int workflowHeaderID,
			int processId, DateTime scheduledRunTime )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueDetailInsert";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowHeaderID", workflowHeaderID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProcessId", processId ) );
					cmd.Parameters.Add( new SqlParameter( "@ScheduledRunTime", scheduledRunTime ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Sets daily pricing workflow detail queue date started
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <param name="status">Status</param>
		/// <param name="dateStarted">Date started</param>
		public static void SetDailyPricingWorkflowQueueDetailStarted( int identity, int status, DateTime dateStarted )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueDetailSetStarted";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );
					cmd.Parameters.Add( new SqlParameter( "@DateStarted", dateStarted ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Sets daily pricing workflow detail queue to completed with time stamp
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <param name="isCompleted">Completed indicator</param>
		/// <param name="dateCompleted">Date completed</param>
		public static void SetDailyPricingWorkflowQueueDetailCompleted( int identity, int isCompleted, DateTime dateCompleted )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 1800;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueDetailSetCompleted";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", isCompleted ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCompleted", dateCompleted ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets all workflow queue header records
		/// </summary>
		/// <returns>Returns a dataset containing all workflow queue header records.</returns>
		public static DataSet GetWorkflowQueueHeaders()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueHeaderSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets header record for specified work day
		/// </summary>
		/// <param name="workDay">Work day</param>
		/// <returns>Returns a dataset containing the header record for specified work day.</returns>
		public static DataSet GetWorkflowQueueHeaderByWorkDay( DateTime workDay )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueHeaderByWorkDaySelect";

					cmd.Parameters.Add( new SqlParameter( "@WorkDay", workDay ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets header record for specified detail record identifier
		/// </summary>
		/// <param name="workflowQueueDetailIdentity">Detail record identifier</param>
		/// <returns>Returns a dataset containing the header record for specified detail record identifier.</returns>
		public static DataSet GetWorkflowQueueHeaderByDetailID( int workflowQueueDetailIdentity )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueHeaderByDetailIDSelect";

					cmd.Parameters.Add( new SqlParameter( "@DetailIdentity", workflowQueueDetailIdentity ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets latest workflow from queue
		/// </summary>
		public static DataSet GetLatestWorkflow()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueHeaderLatestSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets all workflow queue detail records for specified header ID
		/// </summary>
		/// <param name="workflowQueueHeaderIdentity">Workflow queue header record identifier</param>
		/// <returns>Returns a dataset containing all workflow queue detail records for specified header ID.</returns>
		public static DataSet GetWorkflowQueueDetails( int workflowQueueHeaderIdentity )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueDetailByHeaderIDSelect";

					cmd.Parameters.Add( new SqlParameter( "@WorkflowHeaderID", workflowQueueHeaderIdentity ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets detail record for specified record identifier
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <returns>Returns a dataset containing a detail record for specified record identifier.</returns>
		public static DataSet GetWorkflowQueueDetail( int identity )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueDetailSelect";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Updates workflow queue detail status
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <param name="status">Status</param>
		public static void UpdateDailyPricingWorkflowQueueDetailStatus( int identity, int status )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueDetailStatusUpdate";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Resets daily pricing workflow detail record for re-run
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <param name="status">Status</param>
		public static void ResetDailyPricingWorkflowQueueDetail( int identity, int status )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueDetailReset";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Updates workflow queue detail items processed
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <param name="itemsProcessed">Items processed</param>
		public static void UpdateDailyPricingWorkflowQueueDetailItemsProcessed( int identity, int itemsProcessed )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueDetailItemsProcessedUpdate";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@ItemsProcessed", itemsProcessed ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Updates workflow queue detail total items
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <param name="totalItems">Total items</param>
		public static void UpdateDailyPricingWorkflowQueueDetailTotalItems( int identity, int totalItems )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingWorkflowQueueDetailTotalItemsUpdate";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@TotalItems", totalItems ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets daily pricing notification list
		/// </summary>
		/// <returns>Returns a dataset containing the daily pricing notification list</returns>
		public static DataSet GetDailyPricingNotificationList()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingNotificationsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily pricing notification for specified record identifier
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <returns>Returns a dataset containing the daily pricing notification for specified record identifier.</returns>
		public static DataSet GetDailyPricingNotification( int identity )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingNotificationSelect";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts a daily pricing notification record
		/// </summary>
		/// <param name="name">Name</param>
		/// <param name="email">Email</param>
		/// <param name="phone">Phone</param>
		/// <param name="notifyProcessComplete">Notification indicator when each process has completed</param>
		/// <param name="notifyAllProcessesComplete">Notification indicator when all processes have completed</param>
		/// <returns>Returns a dataset containing the inserted data with record identifier.</returns>
		public static DataSet InsertDailyPricingNotification( string name, string email, string phone,
            int notifyProcessComplete, int notifyAllProcessesComplete, int notifyProcessStarts, string emailSubject, string emailMessage)
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingNotificationInsert";

					cmd.Parameters.Add( new SqlParameter( "@Name", name ) );
					cmd.Parameters.Add( new SqlParameter( "@Email", email ) );
					cmd.Parameters.Add( new SqlParameter( "@Phone", phone ) );
					cmd.Parameters.Add( new SqlParameter( "@NotifyProcessComplete", notifyProcessComplete ) );
					cmd.Parameters.Add( new SqlParameter( "@NotifyAllProcessesComplete", notifyAllProcessesComplete ) );
                    cmd.Parameters.Add( new SqlParameter( "@NotifyProcessStarts", notifyProcessStarts));
                    cmd.Parameters.Add( new SqlParameter( "@EmailSubject", emailSubject));
                    cmd.Parameters.Add( new SqlParameter( "@EmailMessage", emailMessage));

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Updates daily pricing notification record
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <param name="name">Name</param>
		/// <param name="email">Email</param>
		/// <param name="phone">Phone</param>
		/// <param name="notifyProcessComplete">Notification indicator when each process has completed</param>
		/// <param name="notifyAllProcessesComplete">Notification indicator when all processes have completed</param>
		public static void UpdateDailyPricingNotification( int identity, string name, string email, string phone,
            int notifyProcessComplete, int notifyAllProcessesComplete, int notifyProcessStarts, string emailSubject, string emailMessage)
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingNotificationUpdate";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@Name", name ) );
					cmd.Parameters.Add( new SqlParameter( "@Email", email ) );
					cmd.Parameters.Add( new SqlParameter( "@Phone", phone ) );
					cmd.Parameters.Add( new SqlParameter( "@NotifyProcessComplete", notifyProcessComplete ) );
					cmd.Parameters.Add( new SqlParameter( "@NotifyAllProcessesComplete", notifyAllProcessesComplete ) );
                    cmd.Parameters.Add( new SqlParameter( "@NotifyProcessStarts", notifyProcessStarts));
                    cmd.Parameters.Add( new SqlParameter( "@EmailSubject", emailSubject));
                    cmd.Parameters.Add( new SqlParameter( "@EmailMessage", emailMessage));

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Deletes daily pricing notification record for specified record identifier
		/// </summary>
		/// <param name="identity">Record identifier</param>
		public static void DeleteDailyPricingNotification( int identity )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingNotificationDelete";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets daily pricing email notification list
		/// </summary>
		/// <returns>Returns a dataset containing the daily pricing email notification list</returns>
		public static DataSet GetDailyPricingNotificationEmailList()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingNotificationEmailsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily pricing phone notification list
		/// </summary>
		/// <returns>Returns a dataset containing the daily pricing phone notification list</returns>
		public static DataSet GetDailyPricingNotificationPhoneList()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingNotificationPhonesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts record for sales channel that has pricing sheets generated
		/// </summary>
		/// <param name="salesChannelID">Sales channel record identifier</param>
		/// <param name="dateCreated">Date created</param>
		/// <param name="createdBy">User record identifier</param>
		/// <returns>Returns a dataset containing inserted record with record identifier.</returns>
		public static DataSet InsertDailyPricingSalesChannelProcessedForSheets( int salesChannelID, DateTime dateCreated, int createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSalesChannelProcessedForSheetsTempInsert";

					cmd.Parameters.Add( new SqlParameter( "@SalesChannelID", salesChannelID ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );


					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets records for sales channels that has pricing sheets generated
		/// </summary>
		/// <returns>Returns a dataset containing records for sales channels that have pricing sheets generated.</returns>
		public static DataSet GetDailyPricingSalesChannelProcessedForSheets()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSalesChannelProcessedForSheetsTempSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Truncates DailyPricingSalesChannelProcessedForSheetsTemp table
		/// </summary>
		public static void TruncateDailyPricingSalesChannelProcessedForSheetsTemp()
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSalesChannelProcessedForSheetsTempTruncate";

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Inserts daily pricing event record
		/// </summary>
		/// <param name="message">Message</param>
		/// <returns>Returns a dataset conatining Inserted daily pricing event record with record identifier.</returns>
		public static DataSet InsertDailyPricingLog_Event( string message )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingLogInsert_Event";

					cmd.Parameters.Add( new SqlParameter( "@Message", message ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets daily pricing event records
		/// </summary>
		/// <returns>Returns a dataset conatining Inserted daily pricing event records.</returns>
		public static DataSet GetDailyPricingLog_Event()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingLogSelect_Event";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Resets latest workflow (for testing only)
		/// </summary>
		public static void ResetLatestWorkflow()
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ResetLatestWorkflow";
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static DataSet InsertPrice( int channelID, int channelGroupID, int channelTypeID, int productCrossPriceSetID,
			int productTypeID, int marketID, int utilityID, int segmentID, int zoneID, int serviceClassID, DateTime startDate, int term,
			decimal price, DateTime effectiveDate, DateTime expirationDate, int isTermRange, DateTime dateCreated, int priceTier,
			int productBrandID, decimal grossMargin )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceInsert";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@StartDate", startDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@Price", price ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateEffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateExpirationDate", expirationDate ) );
					cmd.Parameters.Add( new SqlParameter( "@IsTermRange", isTermRange ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceTier", priceTier ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMargin", grossMargin ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet InsertPrice( int channelID, int channelGroupID, int channelTypeID, int productCrossPriceSetID,
			int productTypeID, int marketID, int utilityID, int segmentID, int zoneID, int serviceClassID, DateTime startDate, int term,
			decimal price, DateTime effectiveDate, DateTime expirationDate, int isTermRange, DateTime dateCreated, int priceTier,
			int productBrandID, decimal grossMargin, int productCrossPriceID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceInsert";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@StartDate", startDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@Price", price ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateEffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateExpirationDate", expirationDate ) );
					cmd.Parameters.Add( new SqlParameter( "@IsTermRange", isTermRange ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceTier", priceTier ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMargin", grossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceID", productCrossPriceID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet InsertPriceForDailyPricing( int channelID, int channelGroupID, int channelTypeID, int productCrossPriceSetID,
			int productTypeID, int marketID, int utilityID, int segmentID, int zoneID, int serviceClassID, DateTime startDate, int term,
			decimal price, DateTime effectiveDate, DateTime expirationDate, int isTermRange, DateTime dateCreated, int priceTier,
			int productBrandID, decimal grossMargin, int productCrossPriceID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceInsert2";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@StartDate", startDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@Price", price ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateEffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateExpirationDate", expirationDate ) );
					cmd.Parameters.Add( new SqlParameter( "@IsTermRange", isTermRange ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceTier", priceTier ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMargin", grossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceID", productCrossPriceID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet UpdatePrice( int channelID, int channelGroupID, int channelTypeID, int productCrossPriceSetID,
			int productTypeID, int marketID, int utilityID, int segmentID, int zoneID, int serviceClassID, DateTime startDate, int term,
			decimal price, DateTime effectiveDate, DateTime expirationDate, int isTermRange, DateTime dateCreated, int priceTier,
			int productBrandID, decimal grossMargin, Int64 PriceID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@StartDate", startDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@Price", price ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateEffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateExpirationDate", expirationDate ) );
					cmd.Parameters.Add( new SqlParameter( "@IsTermRange", isTermRange ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceTier", priceTier ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMargin", grossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@ID", PriceID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet UpdatePrice( int channelID, int channelGroupID, int channelTypeID, int productCrossPriceSetID,
			int productTypeID, int marketID, int utilityID, int segmentID, int zoneID, int serviceClassID, DateTime startDate, int term,
			decimal price, DateTime effectiveDate, DateTime expirationDate, int isTermRange, DateTime dateCreated, int priceTier,
			int productBrandID, decimal grossMargin, Int64? priceID, int productCrossPriceID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@StartDate", startDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@Price", price ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateEffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@CostRateExpirationDate", expirationDate ) );
					cmd.Parameters.Add( new SqlParameter( "@IsTermRange", isTermRange ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceTier", priceTier ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMargin", grossMargin ) );
					if( priceID != null )
						cmd.Parameters.Add( new SqlParameter( "@ID", priceID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceID", productCrossPriceID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetCurrentPrices( int channelID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesCurrentSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetCurrentPrices( int channelId, string marketCode, string utilityCode, int productBrandId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesCurrentSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelId ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketCode", marketCode ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandId", productBrandId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static DataSet GetCurrentPriceTerms( int channelID, int marketID, int utilityID, int productBrandID, int accountTypeID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceTermsCurrentSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetCustomMultiTermPrices( int channelId, DateTime priceDate, int marketId, int utilityId, int productBrandId, int accountTypeId )
		{
			var ds = new DataSet();

			using( var cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( var cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetCustomMultiTermPrices";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelId ) );
					cmd.Parameters.Add( new SqlParameter( "@ContractSignDate", priceDate ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandId ) );
					cmd.Parameters.Add( new SqlParameter( "@accountTypeID", accountTypeId ) );

					using( var da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetPrices( int channelID, DateTime priceDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@Date", priceDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetPrices( int channelID, DateTime priceDate, int productBrandId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@Date", priceDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandId", productBrandId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetPrices( int channelID, DateTime priceDate, int MarketID, int UtilityID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@Date", priceDate ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", UtilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", MarketID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetPrices( int channelID, DateTime priceDate, int MarketID, int UtilityID, int ProductBrandId, int accountTypeId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@Date", priceDate ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", UtilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", MarketID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", ProductBrandId ) );
					cmd.Parameters.Add( new SqlParameter( "@accountTypeID", accountTypeId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetPrices( int channelID, DateTime priceDate, int marketID, int utilityID, int productBrandID, int? accountTypeID, int? productAccountTypeID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@Date", priceDate ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductAccountTypeID", productAccountTypeID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the prices based on the different filter criteria.
		/// </summary>
		/// <param name="channelID"></param>
		/// <param name="priceDate"></param>
		/// <param name="productAccountTypeID"></param>
		/// <param name="utilityID"></param>
		/// <param name="marketID"></param>
		/// <param name="accountTypeID"></param>
		/// <param name="productBrandID"></param>
		/// <param name="productTypeId"></param>
		/// <returns></returns>
		public static DataSet GetFilteredPrices( int channelID, DateTime priceDate,
			int? productAccountTypeID = null, int? utilityID = null, int? marketID = null,
			int? accountTypeID = null, int? productBrandID = null, int? productTypeId = null )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@Date", priceDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductAccountTypeID", productAccountTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}



		public static DataSet GetPricesForDailyPricing( int channelID, DateTime priceDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesForDailyPricingSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@Date", priceDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetPrice( Int64 identity )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceSelect";

					cmd.Parameters.Add( new SqlParameter( "@ID", identity ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static DataSet GetPriceDetail( Int64 identity )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceDetailSelect";

					cmd.Parameters.Add( new SqlParameter( "@PriceID", identity ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static DataSet SubTermsSelect( Int64 priceId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 300;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SubtermsSelect";

					cmd.Parameters.Add( new SqlParameter( "@PriceID", priceId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Clears the current sales channel prices 
		/// </summary>
		public static void ClearCurrentPrices()
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 1800;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesDelete";

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static DataSet GetDailyPricingTemplateCellData()
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingTemplateCellsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Performs a bulk insert of CrossProductPrices into the database.
		/// </summary>
		/// <param name="dt">The data table.</param>
		/// <param name="batchInsertSize">Batch insert size</param>
		public static void InsertSalesChannelPrices( DataTable dt, int batchInsertSize )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				// Set up the bulk copy object. 
				// Note that the column positions in the source data reader match the column positions in 
				// the destination table so there is no need to map columns.
				using( SqlBulkCopy bulkCopy = new SqlBulkCopy( cn ) )
				{

					#region Column Mappings
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ChannelID", "ChannelID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ChannelGroupID", "ChannelGroupID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ChannelTypeID", "ChannelTypeID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ProductCrossPriceSetID", "ProductCrossPriceSetID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ProductTypeID", "ProductTypeID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "MarketID", "MarketID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "UtilityID", "UtilityID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "SegmentID", "SegmentID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ZoneID", "ZoneID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ServiceClassID", "ServiceClassID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "StartDate", "StartDate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Term", "Term" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Price", "Price" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "CostRateEffectiveDate", "CostRateEffectiveDate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "CostRateExpirationDate", "CostRateExpirationDate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "IsTermRange", "IsTermRange" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "DateCreated", "DateCreated" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "PriceTier", "PriceTier" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ProductBrandID", "ProductBrandID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "GrossMargin", "GrossMargin" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ProductCrossPriceID", "ProductCrossPriceID" ) );
					#endregion

					bulkCopy.BulkCopyTimeout = 86400; // one day
					bulkCopy.BatchSize = batchInsertSize;
					bulkCopy.DestinationTableName = "dbo.Price";
					bulkCopy.WriteToServer( dt );
				}
			}
		}

		public static void InsertCostRuleRawImport( DataTable dt, int batchInsertSize )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				cn.Open();

				// Set up the bulk copy object. 
				// Note that the column positions in the source data reader match the column positions in 
				// the destination table so there is no need to map columns.
				using( SqlBulkCopy bulkCopy = new SqlBulkCopy( cn ) )
				{
					#region Column Mappings

					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ProductCostRuleSetID", "ProductCostRuleSetID" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ProspectCustomerType", "ProspectCustomerType" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Product", "Product" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "MarketCode", "MarketCode" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "UtilityCode", "UtilityCode" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Zone", "Zone" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "UtilityServiceClass", "UtilityServiceClass" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "ServiceClassName", "ServiceClassName" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "StartDate", "StartDate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Term", "Term" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "Rate", "Rate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "CreatedBy", "CreatedBy" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "CreatedDate", "CreatedDate" ) );
					bulkCopy.ColumnMappings.Add( new SqlBulkCopyColumnMapping( "PriceTier", "PriceTier" ) );

					#endregion

					bulkCopy.BulkCopyTimeout = 86400; // one day
					bulkCopy.BatchSize = batchInsertSize;

					bulkCopy.DestinationTableName = "dbo.ProductCostRuleRaw";

					bulkCopy.WriteToServer( dt );
				}
			}
		}


		//******************************************************************************************************************************************************************
		//**********************************************    FOR CREATING SALES CHANNEL PRICES FOR SPECIFIC DATES  (I never heard of regions)   ********************************************************
		//******************************************************************************************************************************************************************

		public static DataSet GetActiveProductOffersForDate( DateTime date )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductOffersActiveForDateSelect";

					cmd.Parameters.Add( new SqlParameter( "@Date", date ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetSalesChannelChannelGroupIDByDate( int channelID, DateTime date )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelChannelGroupIDByDateSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@Date", date ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetPriceTiers()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceTiersSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetPriceTier( int priceTierID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceTierSelect";

					cmd.Parameters.Add( new SqlParameter( "@PriceTierID", priceTierID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet InsertPriceTier( string name, string description, int minMwh, int maxMwh, int isActive )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceTierInsert";

					cmd.Parameters.Add( new SqlParameter( "@Name", name ) );
					cmd.Parameters.Add( new SqlParameter( "@Description", description ) );
					cmd.Parameters.Add( new SqlParameter( "@MinMwh", minMwh ) );
					cmd.Parameters.Add( new SqlParameter( "@MaxMwh", maxMwh ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", isActive ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static void UpdatePriceTier( int priceTierID, string name, string description, int minMwh, int maxMwh, int isActive )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceTierUpdate";

					cmd.Parameters.Add( new SqlParameter( "@PriceTierID", priceTierID ) );
					cmd.Parameters.Add( new SqlParameter( "@Name", name ) );
					cmd.Parameters.Add( new SqlParameter( "@Description", description ) );
					cmd.Parameters.Add( new SqlParameter( "@MinMwh", minMwh ) );
					cmd.Parameters.Add( new SqlParameter( "@MaxMwh", maxMwh ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", isActive ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static void UpdatePriceTierSortOrder( int priceTierID, int sortOrder )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceTierSortOrderUpdate";

					cmd.Parameters.Add( new SqlParameter( "@PriceTierID", priceTierID ) );
					cmd.Parameters.Add( new SqlParameter( "@SortOrder", sortOrder ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets product cross price set ids that are ready for archiving
		/// </summary>
		public static DataSet GetProductCrossPriceSetIdForArchiving()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceSetIdForArchivingSelect";
					cmd.CommandTimeout = 36000; // 10 hours

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Deletes cross price set for specified ID
		/// </summary>
		public static void DeleteProductCrossPriceSet( int productCrossPriceSetID )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceSetDelete";
					cmd.CommandTimeout = 14400; // 4 hours

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetID ) );

					cn.Open();
					cmd.ExecuteNonQuery();
					cn.Close();
				}
			}
		}

		public static DataSet GetPricesBySetId( int productCrossPriceSetID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 3600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesBySetIdSelect";

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetPricesByCurrentSetId()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 7200;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PricesByCurrentSetIdSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet InsertProductConfigurationPrice( int productConfigurationID, Int64 priceID )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductConfigurationPricesInsert";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceID", priceID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet InsertProductCrossPriceMulti( int productCrossPriceID, DateTime startDate, int term, decimal markupRate, decimal price )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceMultiInsert";

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceID", productCrossPriceID ) );
					cmd.Parameters.Add( new SqlParameter( "@StartDate", startDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@MarkupRate", markupRate ) );
					cmd.Parameters.Add( new SqlParameter( "@Price", price ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetProductCrossPriceMultiTerm( int productCrossPriceID )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceMultiSelect";

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceID", productCrossPriceID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetProductCrossPriceMultiTermByProductCrossPriceMultiID( Int64 productCrossPriceMultiID )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceMultiSelectByProductCrossPriceMultiID";

					cmd.Parameters.Add( new SqlParameter( "@productCrossPriceMultiID", productCrossPriceMultiID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetProductCrossPriceMultiTermCurrent()
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 3600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceMultiCurrentSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Get CrossProduct records by setId for multi-term.
		/// </summary>
		/// <param name="productCrossPriceSetId">The product cross price set id.</param>
		/// <returns>Returns a dataset containing CrossProduct records by setId for multi-term.</returns>
		public static DataSet GetProductCrossPriceForMultiTerm( int productCrossPriceSetId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceForMultiTermSelect";
					cmd.CommandTimeout = 600; // Wait at least 600 Seconds (10 minutes) before timeout

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceSetID", productCrossPriceSetId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetProductCrossPriceCurrent( int channelGroupID, int segmentID, int channelTypeID, int productTypeID, int marketID,
			int utilityID, int zoneID, int serviceClassID, int productBrandID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCrossPriceCurrentSelect";
					cmd.CommandTimeout = 600; // Wait at least 600 Seconds (10 minutes) before timeout

					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@SegmentID", segmentID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductBrandID", productBrandID ) );


					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets product configuration data for multi-term in markup file format.
		/// </summary>
		/// <returns>Returns a dataset containing product configuration data for multi-term in markup file format.</returns>
		public static DataSet GetProdConfigMultiTermForMarkup()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProdConfigMultiTermForMarkupSelect";
					cmd.CommandTimeout = 600; // Wait at least 600 Seconds (10 minutes) before timeout

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static void InsertProdConfigChannelAccess( int prodConfig, int channelID )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProdConfigChannelAccessInsert";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", prodConfig ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static DataSet GetProdConfigChannelAccess( int prodConfig )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProdConfigChannelAccessSelect";
					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", prodConfig ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static void DeleteProdConfigChannelAccess( int prodConfig )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProdConfigChannelAccessDelete";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", prodConfig ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets multi-term .
		/// </summary>
		/// <param name="productCrossPriceId">The product cross price set id.</param>
		/// <returns>Returns a dataset containing CrossProduct records by setId for multi-term.</returns>
		public static DataSet GetMultiTermByProductCrossPriceId( int productCrossPriceId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetMultiTermsByProductCrossPriceID";
					cmd.CommandTimeout = 60;

					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceID", productCrossPriceId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets multi-term .
		/// </summary>
		/// <param name="priceID">The product cross price set id.</param>
		/// <returns>Returns a dataset containing CrossProduct records by setId for multi-term.</returns>
		public static DataSet GetMultiTermByPriceID( Int64 priceID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_MultiTermByPriceIDSelect";
					cmd.CommandTimeout = 60;

					cmd.Parameters.Add( new SqlParameter( "@PriceID", priceID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets multi-term .
		/// </summary>
		/// <param name="priceId">priceid.</param>
		/// /// <param name="rate">assigned rate for abc channel</param>
		/// <returns>Returns a dataset containing CrossProduct records by setId for multi-term.</returns>
		public static DataSet GetMultiTermByPriceIdAndRate( long priceId, float rate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetMultiTermByPriceIdAndRate";
					cmd.CommandTimeout = 60;

					cmd.Parameters.Add( new SqlParameter( "@PriceID", priceId ) );
					cmd.Parameters.Add( new SqlParameter( "@Rate", rate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetProductGreenRuleSetCurrent()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductGreenRuleSetGetCurrent";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetProductGreenRuleSetAll()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductGreenRuleSetGetAll";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetProductGreenRuleBySetID( int setID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductGreenRuleGetBySetID";
					cmd.CommandTimeout = 3600;

					cmd.Parameters.Add( new SqlParameter( "@ProductGreenRuleSetID", setID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet InsertProductGreenRuleSet( string fileGuid, int uploadedBy, int uploadStatus )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductGreenRuleSetInsert";

					cmd.Parameters.Add( new SqlParameter( "@FileGuid", fileGuid ) );
					cmd.Parameters.Add( new SqlParameter( "@UploadedBy", uploadedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@UploadStatus", uploadStatus ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet UpdateProductGreenRuleSet( int setID, string fileGuid, int uploadedBy, int uploadStatus )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductGreenRuleSetUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ProductGreenRuleSetID", setID ) );
					cmd.Parameters.Add( new SqlParameter( "@FileGuid", fileGuid ) );
					cmd.Parameters.Add( new SqlParameter( "@UploadedBy", uploadedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@UploadStatus", uploadStatus ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static bool DeleteProductGreenRuleSet( int setID )
		{
			int rowsAffected = 0;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductGreenRuleSetDelete";

					cmd.Parameters.Add( new SqlParameter( "@ProductGreenRuleSetID", setID ) );

					cn.Open();
					rowsAffected = cmd.ExecuteNonQuery();
				}
			}
			return (rowsAffected > 0);
		}

		/// <summary>
		/// Performs a bulk insert of GreenRules into the database.
		/// </summary>
		/// <param name="dataTable">The data table.</param>
		public static void GreenRuleListInsert( DataTable dataTable )
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
					bulkCopy.BulkCopyTimeout = 86400; // one day
					bulkCopy.BatchSize = 100000;
					bulkCopy.DestinationTableName = "dbo.ProductGreenRule";
					bulkCopy.WriteToServer( dataTable );
				}
			}
		}

		/// <summary>
		/// Performs a bulk insert of markup rules into the database.
		/// </summary>
		/// <param name="dataTable">The data table.</param>
		public static void MarkupRuleListInsert( DataTable dataTable )
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
					bulkCopy.BulkCopyTimeout = 86400; // one day
					bulkCopy.BatchSize = 100000;
					bulkCopy.DestinationTableName = "dbo.ProductMarkupRule";
					bulkCopy.WriteToServer( dataTable );
				}
			}
		}

		#endregion

		[Obsolete( "Please use method in CustomSql class" )]
		public static DataSet GetCustomProductPriceById( int dealPricingDetailId )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.DCConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_deal_pricing_tables_sel";

					cmd.Parameters.Add( new SqlParameter( "@p_deal_pricing_detail_id", dealPricingDetailId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetGreenLocationMarkets()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GreenLocationMarketSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetGreenLocations()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GreenLocationsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetGreenRecTypes()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GreenRecTypesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetGreenPercentages()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GreenPercentagesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static void InsertProdConfigGreenAttributes( int productConfigurationID, int percentageID, int locationID, int recTypeID )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProdConfigGreenAttributesInsert";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );
					cmd.Parameters.Add( new SqlParameter( "@PercentageID", percentageID ) );
					cmd.Parameters.Add( new SqlParameter( "@LocationID", locationID ) );
					cmd.Parameters.Add( new SqlParameter( "@RecTypeID", recTypeID ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static DataSet GetProdConfigGreenAttributes( int productConfigurationID )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProdConfigGreenAttributesSelect";
					cmd.CommandTimeout = 3600;

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet DeleteProdConfigGreenAttributes( int productConfigurationID )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProdConfigGreenAttributesDelete";

					cmd.Parameters.Add( new SqlParameter( "@ProductConfigurationID", productConfigurationID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		//Added on Sept 25 2013
		//For getting the priceTierID from the PriceId
		public static DataSet GetPriceTierID( long PriceID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PriceTierIdGet";

					cmd.Parameters.Add( new SqlParameter( "@PriceID", PriceID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static void InsertDefaultFixedResults( int accountID, int contractID, int isProcessed, string message, DateTime dateCreated, string parameters)
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountDefaultFixedInsert";

					cmd.Parameters.Add( new SqlParameter( "@AccountID", accountID ) );
					cmd.Parameters.Add( new SqlParameter( "@ContractID", contractID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsProcessed", isProcessed ) );
					cmd.Parameters.Add( new SqlParameter( "@Message", message ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@Parameters", parameters ) );
	
					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static DataSet GetAccountDefaultFixedDistribution()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountDefaultFixedDistributionSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetAccountDefaultFixed( DataTable accountNumbers, DateTime minDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountDefaultFixedSelect";

					SqlParameter parameter = new SqlParameter();
					//The parameter for the SP must be of SqlDbType.Structured 
					parameter.ParameterName = "@Accounts";
					parameter.SqlDbType = System.Data.SqlDbType.Structured;
					parameter.Value = accountNumbers;
					cmd.Parameters.Add( parameter );

					cmd.Parameters.Add( new SqlParameter( "@MinDate", minDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;

		}

		public static DataSet GetMarkupDefaultFixedCurrent()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductMarkupRuleDefaultFixedCurrentSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetCostDefaultFixedCurrent()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductCostRuleDefaultFixedCurrentSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static void InsertCustomDailyRate(int channelID, int channelGroupID, int channelTypeID, int productTypeID, int marketID, int utilityID, int segmentID,
			int zoneID, int serviceClassID, DateTime startDate, int term, decimal price, DateTime effectiveDate, DateTime expirationDate, int priceTier, int productBrandID, 
			decimal grossMargin, decimal commission, int createdBy, DateTime dateCreated)
		{
			using(SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
				using(SqlCommand cmd = new SqlCommand())
				{
					cn.Open();
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomDailyRateInsert";

					cmd.Parameters.Add(new SqlParameter("@ChannelID", channelID));
					cmd.Parameters.Add(new SqlParameter("@ChannelGroupID", channelGroupID));
					cmd.Parameters.Add(new SqlParameter("@ChannelTypeID", channelTypeID));
					cmd.Parameters.Add(new SqlParameter("@ProductTypeID", productTypeID));
					cmd.Parameters.Add(new SqlParameter("@MarketID", marketID));
					cmd.Parameters.Add(new SqlParameter("@UtilityID", utilityID));
					cmd.Parameters.Add(new SqlParameter("@SegmentID", segmentID));
					cmd.Parameters.Add(new SqlParameter("@ZoneID", zoneID));
					cmd.Parameters.Add(new SqlParameter("@ServiceClassID", serviceClassID));
					cmd.Parameters.Add(new SqlParameter("@StartDate", startDate));
					cmd.Parameters.Add(new SqlParameter("@Term", term));
					cmd.Parameters.Add(new SqlParameter("@Price", price));
					cmd.Parameters.Add(new SqlParameter("@EffectiveDate", effectiveDate));
					cmd.Parameters.Add(new SqlParameter("@ExpirationDate", expirationDate));
					cmd.Parameters.Add(new SqlParameter("@PriceTierID", priceTier));
					cmd.Parameters.Add(new SqlParameter("@ProductBrandID", productBrandID));
					cmd.Parameters.Add(new SqlParameter("@GrossMargin", grossMargin));
					cmd.Parameters.Add(new SqlParameter("@Commission", commission));
					cmd.Parameters.Add(new SqlParameter("@CreatedBy", createdBy));
					cmd.Parameters.Add(new SqlParameter("@DateCreated", dateCreated));

					cmd.ExecuteNonQuery();
				}
			}
		}

		public static DataSet GetCustomDailyRate(DateTime beginDate, DateTime endDate)
		{
			DataSet ds = new DataSet();

			using(SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
				using(SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomDailyRateSelect";

					cmd.Parameters.Add(new SqlParameter("@BeginDate", beginDate));
					cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));

					using(SqlDataAdapter da = new SqlDataAdapter(cmd))
						da.Fill(ds);
				}
			}
			return ds;
		}

		public static DataSet GetDailyPricingSheetTemplates()
		{
			DataSet ds = new DataSet();

			using(SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
				using(SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingSheetTemplatesSelect";

					using(SqlDataAdapter da = new SqlDataAdapter(cmd))
						da.Fill(ds);
				}
			}
			return ds;
		}

		public static DataSet GetApplicationConfiguration( string application )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ApplicationConfigurationSelect";

					cmd.Parameters.Add( new SqlParameter( "@Application", application ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static void StartSqlJob( string jobName )
		{
			using( SqlConnection cn = new SqlConnection( Helper.MsdbConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cn.Open();
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "sp_start_job";

					cmd.Parameters.Add( new SqlParameter( "@job_name", jobName ) );

					cmd.ExecuteNonQuery();
				}
			}
		}
	}
}
