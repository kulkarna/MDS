namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	using System;
	using System.Data;
    using System.Data.SqlClient;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

	/// <summary>
    /// Sql class for Products
    /// </summary>
    public static class ProductSql
    {
        #region Methods

        /// <summary>
        /// Gets the Product by ID.
        /// </summary>
		/// <param name="productTypeId">The product ID.</param>
        /// <returns></returns>
		public static DataSet ProductTypeGet( int productTypeId)
        {
            string SQL = "usp_ProductTypeGetById";
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();
            using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter( "@ProductTypeID", productTypeId );

                da.SelectCommand.Parameters.Add( p1 );

                da.Fill( ds );
            }
            return ds;
        }

        /// <summary>
        /// Gets the Product by Name.
        /// </summary>
        /// <param name="productName">Name of the product.</param>
        /// <returns></returns>
        public static DataSet ProductTypeGet( string productName )
        {
            string SQL = "usp_ProductTypeGetByName";
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();
            using( SqlDataAdapter da = new SqlDataAdapter( SQL, connStr ) )
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter( "@Name", productName );

                da.SelectCommand.Parameters.Add( p1 );

                da.Fill( ds );
            }
            return ds;
        }

		/// <summary>
		/// Gets products
		/// </summary>
		/// <returns>Returns a dataset that contains products.</returns>
		public static DataSet GetProducts()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets product brands for specified product id
		/// </summary>
		/// <param name="productTypeId">Product type record identifier</param>
		/// <returns>Returns a dataset that contains product brands for specified product id.</returns>
		public static DataSet GetProductBrandsByProductTypeId( int productTypeId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductBrandByProductTypeIdSelect";

					cmd.Parameters.Add( new SqlParameter( "@ProductTypeId", productTypeId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets a product brand for specified product brand id.
		/// </summary>
		/// <param name="productBrandId">Product brand record identifier</param>
		/// <returns>Returns a dataset that contains a product brand for specified product brand id.</returns>
		public static DataSet GetProductBrand( int productBrandId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductBrandSelect";

					cmd.Parameters.Add( new SqlParameter( "@ProductBrandId", productBrandId ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

        /// <summary>
        /// Gets a product brand for specified product brand.
        /// </summary>
        /// <param name="productBrand">Product brand record identifier</param>
        /// <returns>Returns a dataset that contains a product brand for specified product brand.</returns>
        public static DataSet GetProductBrand(string productBrand)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ProductBrandByProductBrandSelect";

                    cmd.Parameters.Add(new SqlParameter("@ProductBrand", productBrand));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
		/// <summary>
		/// Gets product brands.
		/// </summary>
		/// <returns>Returns a dataset that contains all product brands.</returns>
		public static DataSet GetProductBrands()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductBrandsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

        public static DataSet GetProductBrandsWithCurrentProduct(int productBrandId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ProductBrandsSelectWithCurrentProduct";

                    cmd.Parameters.Add(new SqlParameter("@ProductBrandId", productBrandId));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

		/// <summary>
		/// Gets product brands for daily pricing.
		/// </summary>
		/// <returns>Returns a dataset that contains product brands for daily pricing.</returns>
		public static DataSet GetProductBrandsForPricing()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductBrandsForPricingSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet InsertProductBrand( string name, int productTypeID, int isCustom, int isDefaultRollover, 
			int rolloverBrandID, int isActive, string username, DateTime dateCreated )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductBrandInsert";

					cmd.Parameters.Add( new SqlParameter( "@Name", name ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsCustom", isCustom ) );
					cmd.Parameters.Add( new SqlParameter( "@IsDefaultRollover", isDefaultRollover ) );
					cmd.Parameters.Add( new SqlParameter( "@RolloverBrandID", rolloverBrandID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsActive", isActive ) );
					cmd.Parameters.Add( new SqlParameter( "@Username", username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets all product ID and rate ID mappings
		/// </summary>
		/// <returns>Returns a dataste containing all product ID and rate ID mappings.</returns>
		public static DataSet GetLegacyProductIdAndRateIdAll()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_LegacyProductIdAndRateIdAllSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets product ID and rate ID mapping for specified parameters
		/// </summary>
		/// <param name="channelGroupID">Channel group record identifier</param>
		/// <param name="channelTypeID">Channel type record identifier</param>
		/// <param name="accountTypeID">Account type record identifier</param>
		/// <param name="productTypeID">Product type record identifier</param>
		/// <param name="marketID">Market record identifier</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="zoneID">Zone record identifier</param>
		/// <param name="serviceClassID">Service class record identifier</param>
		/// <param name="term">Term (in months)</param>
		/// <param name="price">Price</param>
		/// <returns>Returns a dataset containing product ID and rate ID mapping for specified parameters.</returns>
		public static DataSet GetLegacyProductIdAndRateId( int channelGroupID, int channelTypeID, int accountTypeID, 
			int productTypeID, int marketID, int utilityID, int zoneID, int serviceClassID, int term, decimal price)
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_LegacyProductIdAndRateIdSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@ZoneID", zoneID ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassID", serviceClassID ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@Price", price ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		/// <summary>
		/// get the product type ID for the price ID passed
		/// </summary>
		/// <param name="priceId">Price Id</param>
		/// <returns>ID of the product type</returns>
		public static int GetProductTypeId( long priceId )
		{
			object obj;
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductTypeIdGet";

					cmd.Parameters.Add( new SqlParameter( "@PriceID", priceId ) );
					conn.Open();
					obj = cmd.ExecuteScalar();
				}
			}
			if( obj != null )
				return (int) obj;
			return -1;
		}


        /// <summary>
        /// get the product Brand ID for the price ID passed
        /// </summary>
        /// <param name="priceId">Price Id</param>
        /// <returns>ID of the product Brand</returns>
     //28372: Change ProductType to Product Brand
        public static int GetProductBrandId(long priceId)
        {
            object obj;
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ProductBrandIdGet";

                    cmd.Parameters.Add(new SqlParameter("@PriceID", priceId));
                    conn.Open();
                    obj = cmd.ExecuteScalar();
                }
            }
            if (obj != null)
                return (int)obj;
            return -1;
        }


        #endregion Methods
    }
}
