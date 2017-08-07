namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
    using System;
    using System.Linq;
    using System.Data;
    using System.Collections.Generic;
    using System.Text;
    using lc = LibertyPower.DataAccess.SqlAccess.CommonSql;
    using LibertyPower.Business.CommonBusiness.CommonHelper;
    using lp = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    [Serializable]
    public static class ProductFactory
    {

        public enum eProductType { Fixed = 1, Variable, Index, BlockIndex, HeatRate, Hybrid, MultiTerm, Green };

        public static Product CreateProduct(string productId)
        {
            DataSet ds = lc.ProductSql.GetProduct(productId);

            return BuildProduct(ds, productId);
        }

        public static Product CreateProduct(string productId, bool ShowActiveOnly)
        {
            DataSet ds = lc.ProductSql.GetProduct(productId, ShowActiveOnly);

            return BuildProduct(ds, productId);
        }

        public static Product BuildProduct(DataSet ds, string productId)
        {
            Product product = null;
            if (ds.Tables[0].Rows.Count > 0)
            {
                // fixed products  ------------------------------------------------------------

                switch (ds.Tables[0].Rows[0]["Category"].ToString().Trim())
                {
                    case "FIXED":
                        FixedProduct fixedProduct = new FixedProduct();
                        fixedProduct.Category = ProductCategory.Fixed;
                        product = fixedProduct;
                        break;

                    case "VARIABLE":
                        // determine sub category
                        switch (ds.Tables[0].Rows[0]["SubCategory"].ToString().Trim())
                        {
                            case "CUSTOM":
                                {
                                    VariableProduct variableProduct = new VariableProduct();
                                    variableProduct.Category = ProductCategory.Variable;
                                    variableProduct.SubCategory = ProductSubCategory.Custom;
                                    product = variableProduct;
                                    break;
                                }
                            case "FIXED ADDER":
                                {
                                    IndexedProduct indexedProduct = new IndexedProduct();
                                    indexedProduct.Category = ProductCategory.Variable;
                                    indexedProduct.SubCategory = ProductSubCategory.Indexed;
                                    product = indexedProduct;
                                    break;
                                }
                            case "BLOCK-INDEXED":
                                {
                                    BlockIndexProduct blockIndexProduct = new BlockIndexProduct();
                                    blockIndexProduct.Category = ProductCategory.Variable;
                                    blockIndexProduct.SubCategory = ProductSubCategory.BlockIndexed;
                                    product = blockIndexProduct;
                                    break;
                                }
							case "HYBRID":
								{
									VariableProduct variableProduct = new VariableProduct();
									variableProduct.Category = ProductCategory.Variable;
									variableProduct.SubCategory = ProductSubCategory.Hybrid;
									product = variableProduct;
									break;
								}
                            default: // indexed
                                {
                                    VariableProduct variableProduct = new VariableProduct();
                                    variableProduct.Category = ProductCategory.Variable;
                                    variableProduct.SubCategory = ProductSubCategory.Portfolio;
                                    product = variableProduct;
                                    break;
                                }
                        }
                        break;

                    default:
                        throw new Exception();
                }
            }

            if (product != null)
            {
                product.ProductId = productId;
                product.IsCustom = Convert.ToBoolean(ds.Tables[0].Rows[0]["IsCustom"]);
                product.IsFlexible = Convert.ToBoolean(ds.Tables[0].Rows[0]["IsFlexible"]);
                product.EtfDisabled = Convert.ToBoolean(ds.Tables[0].Rows[0]["EtfDisabled"]);
                product.Description = ds.Tables[0].Rows[0]["Description"].ToString();
                product.IsDefault = Convert.ToBoolean(ds.Tables[0].Rows[0]["IsDefault"]);
                product.ProductBrandID = Convert.ToInt16(ds.Tables[0].Rows[0]["ProductBrandID"]);

                int productTypeId = (int)ds.Tables[0].Rows[0]["ProductTypeID"];
                product.ProductType = ProductTypeFactory.GetProductType(productTypeId);

                if (ds.Tables[0].Columns.Contains("IsMultiTerm"))
                {
                    product.IsMultiTerm = ds.Tables[0].Rows[0]["IsMultiTerm"] == null ? false : (bool)ds.Tables[0].Rows[0]["IsMultiTerm"];
                }
            }
            return product;
        }

        public static bool IsCustomProduct(string productId)
        {
            Product product = CreateProduct(productId);
            return product.IsCustom;
        }

        /// <summary>
        /// check if the product is a custom product regardless of its "Inactive status"
        /// </summary>
        /// <param name="productId">product ID </param>
        /// <param name="showActiveOnly">1- search only active products. 0- Search active and non-active products</param>
        /// <returns></returns>
        public static bool IsCustomProduct(string productId, bool showActiveOnly)
        {
            Product product = CreateProduct(productId, showActiveOnly);
            return product.IsCustom;
        }

        /// <summary>
        /// Gets a list of products
        /// </summary>
        /// <returns>Returns a list of products</returns>
        public static ProductBrandList GetProductBrands(int productTypeId)
        {
            ProductBrandList list = new ProductBrandList();

            DataSet ds = lp.ProductSql.GetProductBrandsByProductTypeId(productTypeId);

            if (DataSetHelper.HasRow(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                    list.Add(CreateProductBrand(dr));
            }
            else // create a "none" product brand
                list.Add(GetProductBrandAllOthers());

            return list;
        }

        /// <summary>
        /// Check if Product Brand Exists
        /// </summary>
        /// <returns>Returns a boolean</returns>
        public static bool IsProductBrandExists(string productBrand)
        {
            bool returnBool;

            DataSet ds = lp.ProductSql.GetProductBrand(productBrand);

            if (DataSetHelper.HasRow(ds))
            {
                returnBool = true;
            }
            else
                returnBool = false;

            return returnBool;
        }

        /// <summary>
        /// Gets product brand object for all others
        /// </summary>
        /// <returns>Returns a product brand object for all others.</returns>
        /// 
        public static ProductBrandList GetProductBrandsWithCurrentProduct(int productBrandId)
        {
            ProductBrandList list = new ProductBrandList();

            DataSet ds = lp.ProductSql.GetProductBrandsWithCurrentProduct(productBrandId);

            if (DataSetHelper.HasRow(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                    list.Add(CreateProductBrand(dr));
            }
            return list;
        }

        public static ProductBrand GetProductBrandAllOthers()
        {
            ProductBrand pb = new ProductBrand();

            pb.ProductIdentity = -1;
            pb.Name = "All Others";

            return pb;
        }

        /// <summary>
        /// Gets a product brand for specified record identifier
        /// </summary>
        /// <param name="productBrandId">Record identifier</param>
        /// <returns>Returns a product brand for specified record identifier.</returns>
        public static ProductBrand GetProductBrand(int productBrandId)
        {
            ProductBrand pb = null;

            DataSet ds = lp.ProductSql.GetProductBrand(productBrandId);

            if (DataSetHelper.HasRow(ds))
                pb = CreateProductBrand(ds.Tables[0].Rows[0]);

            return pb;
        }

        /// <summary>
        /// Gets product brands
        /// </summary>
        /// <returns>Returns product brands.</returns>
        public static ProductBrandList GetProductBrands()
        {
            ProductBrandList list = new ProductBrandList();

            DataSet ds = lp.ProductSql.GetProductBrands();

            if (DataSetHelper.HasRow(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                    list.Add(CreateProductBrand(dr));
            }
            return list;
        }

        /// <summary>
        /// Inserts product brand record returning record identifier
        /// </summary>
        /// <param name="name">Product brand name</param>
        /// <param name="productTypeID">Product type record identifier</param>
        /// <param name="isCustom">Custom flag</param>
        /// <param name="isDefaultRollover">Default rollover flag</param>
        /// <param name="rolloverBrandID">Rollover brand ID</param>
        /// <param name="isActive">Active flag</param>
        /// <param name="username">Username</param>
        /// <param name="dateCreated">Date created</param>
        public static int InsertProductBrand(string name, int productTypeID, int isCustom, int isDefaultRollover,
            int rolloverBrandID, int isActive, string username, DateTime dateCreated)
        {
            int productBrandID = 0;

            DataSet ds = lp.ProductSql.InsertProductBrand(name, productTypeID, isCustom, isDefaultRollover, rolloverBrandID, isActive, username, dateCreated);
            if (DataSetHelper.HasRow(ds))
            {
                productBrandID = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
            }
            return productBrandID;
        }

        /// <summary>
        /// Gets product brands that are fixed non-custom.
        /// </summary>
        /// <returns>Returns product brands that are fixed non-custom.</returns>
        public static ProductBrandList GetProductBrandsForDailyPricing()
        {
            ProductBrandList list = new ProductBrandList();

            DataSet ds = lp.ProductSql.GetProductBrandsForPricing();

            if (DataSetHelper.HasRow(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                    list.Add(CreateProductBrand(dr));
            }
            return list;
        }

        /// <summary>
        /// Creates a product brand object
        /// </summary>
        /// <param name="dr">Data row</param>
        /// <returns>Returns a product brand object.</returns>
        public static ProductBrand CreateProductBrand(DataRow dr)
        {
            ProductBrand pb = new ProductBrand();

            pb.ProductBrandID = (int)dr["ProductBrandID"];
            pb.Name = dr["Name"].ToString();
            pb.ProductTypeID = (int)dr["ProductTypeID"];
            pb.IsCustom = Convert.ToBoolean(dr["IsCustom"]);
            pb.IsMultiTerm = (bool)dr["IsMultiTerm"];
            if (dr.Table.Columns.Contains("IsGas") && dr["IsGas"] != DBNull.Value)
                pb.IsGas = (bool)dr["IsGas"];

            return pb;
        }

        public static Product GetProductRatesFromExcel(string salesChannel, string utilityID, int termMonths, DateTime effStartDate, DateTime contractDate, decimal rate, string accountType, string productType, string serviceClass, string zone, ref int rateId)
        {
            int accType = 1;

            if (accountType == "SMB")
                accType = 1;
            else if (accountType == "RES")
                accType = 2;
            else if (accountType == "RESIDENTIAL")
                accType = 2;
            else if (accountType == "LCI")
                accType = 3;
            else if (accountType == "SOHO")
                accType = 4;

            DataSet ds = lc.ProductSql.GetProductRatesFromExcel(salesChannel, utilityID, termMonths, effStartDate, contractDate, rate, accType, productType, serviceClass, zone);
            string productId = ds.Tables[0].Rows[0]["ProductId"].ToString();
            rateId = Convert.ToInt32(ds.Tables[0].Rows[0]["return_value"]);
            return CreateProduct(productId);
        }

        public static Product BuildProduct(DataRow dr)
        {
            Product product = null;

            // fixed products  ------------------------------------------------------------

            switch (dr["Category"].ToString().Trim())
            {
                case "FIXED":
                    FixedProduct fixedProduct = new FixedProduct();
                    fixedProduct.Category = ProductCategory.Fixed;
                    product = fixedProduct;
                    break;

                case "VARIABLE":
                    // determine sub category
                    switch (dr["SubCategory"].ToString().Trim())
                    {
                        case "CUSTOM":
                            {
                                VariableProduct variableProduct = new VariableProduct();
                                variableProduct.Category = ProductCategory.Variable;
                                variableProduct.SubCategory = ProductSubCategory.Custom;
                                product = variableProduct;
                                break;
                            }
                        case "FIXED ADDER":
                            {
                                IndexedProduct indexedProduct = new IndexedProduct();
                                indexedProduct.Category = ProductCategory.Variable;
                                indexedProduct.SubCategory = ProductSubCategory.Indexed;
                                product = indexedProduct;
                                break;
                            }
                        case "BLOCK-INDEXED":
                            {
                                BlockIndexProduct blockIndexProduct = new BlockIndexProduct();
                                blockIndexProduct.Category = ProductCategory.Variable;
                                blockIndexProduct.SubCategory = ProductSubCategory.BlockIndexed;
                                product = blockIndexProduct;
                                break;
                            }
                        default: // indexed
                            {
                                VariableProduct variableProduct = new VariableProduct();
                                variableProduct.Category = ProductCategory.Variable;
                                variableProduct.SubCategory = ProductSubCategory.Portfolio;
                                product = variableProduct;
                                break;
                            }
                    }
                    break;

                default:
                    throw new Exception("Product category not found.");
            }

            if (product != null)
            {
                product.ProductId = dr["ProductID"].ToString();
                product.MarketCode = dr["MarketCode"].ToString();
                product.UtilityCode = dr["UtilityCode"].ToString();
                product.MarketID = Convert.ToInt32(dr["MarketID"]);
                product.UtilityID = Convert.ToInt32(dr["UtilityID"]);
                product.AccountTypeID = Convert.ToInt32(dr["AccountTypeID"]);
                product.ProductBrandID = Convert.ToInt32(dr["ProductBrandID"]);
                product.IsCustom = Convert.ToBoolean(dr["IsCustom"]);
                product.IsFlexible = Convert.ToBoolean(dr["IsFlexible"]);
                product.Description = dr["Description"].ToString();
                product.IsDefault = Convert.ToBoolean(dr["IsDefault"]);
            }

            return product;
        }

        /// <summary>
        /// Gets all products that are not variable
        /// </summary>
        /// <returns>Returns all products that are not variable.</returns>
        public static ProductList GetProducts()
        {
            ProductList list = new ProductList();
            DataSet ds = lc.ProductSql.GetProducts();

            if (DataSetHelper.HasRow(ds))
            {
                list.AddRange(ds.Tables[0].Rows.Cast<DataRow>().Select(BuildProduct).Where(product => product != null));
            }
            return list;
        }

        /// <summary>
        /// Gets a product object for specified parameters from product list
        /// </summary>
        /// <param name="list">Product list</param>
        /// <param name="productID">Product ID</param>
        /// <param name="marketID">Market code</param>
        /// <param name="utilityID">Utility code</param>
        /// <param name="accountTypeID">Account type record identifier</param>
        /// <param name="productBrandID">Product brand record identifier</param>
        /// <returns>Returns a product object for specified parameters from product list</returns>
        public static Product GetProduct(ProductList list, string productID, int marketID, int utilityID, int accountTypeID, int productBrandID)
        {
            Product product = null;

            if (CollectionHelper.HasItem(list))
            {
                return (from p in list
                        where p.ProductId.Trim().ToLower() == productID.Trim().ToLower()
                        && p.MarketID == marketID
                        && p.UtilityID == utilityID
                        && p.AccountTypeID == accountTypeID
                        && p.ProductBrandID == productBrandID
                        select p).FirstOrDefault();
            }
            return product;
        }

        /// <summary>
        /// Gets a product object for specified parameters.
        /// </summary>
        /// <param name="marketID">Market code</param>
        /// <param name="utilityID">Utility code</param>
        /// <param name="accountTypeID">Account type record identifier</param>
        /// <param name="productBrandID">Product brand record identifier</param>
        /// <returns>Returns a product object for specified parameters.</returns>
        public static Product GetProduct(int marketID, int utilityID, int accountTypeID, int productBrandID)
        {
            ProductList list = GetProducts();
            Product product = null;

            if (CollectionHelper.HasItem(list))
            {
                return (from p in list
                        where p.MarketID == marketID
                        && p.UtilityID == utilityID
                        && p.AccountTypeID == accountTypeID
                        && p.ProductBrandID == productBrandID
                        select p).FirstOrDefault();
            }
            return product;
        }


        public static string GetProductID(int productBrandID, string utilityCode, int accountTypeID, int isFlexible)
        {
            string productId = String.Empty;

            DataSet ds = lc.ProductSql.GetProductID(productBrandID, utilityCode, accountTypeID, isFlexible);
            if (DataSetHelper.HasRow(ds))
            {
                productId = ds.Tables[0].Rows[0]["ProductID"].ToString();
            }
            return productId;
        }


        /// <summary>
        /// get the product type based on a product brand
        /// </summary>
        /// <param name="priceID ">price ID</param>
        /// <returns>product type</returns>
        public static eProductType GetProductType(long priceID)
        {
            int type = lp.ProductSql.GetProductTypeId(priceID);
            Type enumType = typeof(eProductType);
            eProductType eType = (eProductType)Enum.ToObject(enumType, type);
            return eType;
        }

        //Sept 26 2013 - PBI 20710
        //Get the ProductTypeId from PriceID
        public static Int32 GetProductTypeID(long priceID)
        {
            int type = lp.ProductSql.GetProductTypeId(priceID);
            return type;
        }


        /// <summary>
        /// check if a product is eligible to be processed for Mark to Market
        /// </summary>
        /// <param name="priceId">price ID</param>
        /// <returns>true or false</returns>
        public static bool isProductEligibleForMtM(long priceId)
        {
            eProductType eType = GetProductType(priceId);
            if (eType.Equals(eProductType.Fixed) || eType.Equals(eProductType.MultiTerm) || eType.Equals(eProductType.Green))
                return true;
            return false;
        }


        /// <summary>
        /// Get ServiceClassDisplayName
        /// </summary>
        /// <param name="zoneId">zone Id</param>
        /// <param name="utilityId">utility Id</param>
        /// <param name="productTypeId">product Type Id</param>
        /// <param name="serviceClassId">service Class Id</param>
        /// <param name="segmentId">segment Id</param>
        /// <returns>DisplayName string</returns>
        public static string GetServiceClassDisplayNameFromProductCostRuleSetupTable(int zoneId, int utilityId,
                                                                                     int productTypeId, int serviceClassId,
                                                                                     int segmentId)
        {
            string rtrnVal = string.Empty;
            DataSet ds = lc.ProductSql.GetServiceClassDisplayNameFromProductCostRuleSetupTable(zoneId, utilityId, productTypeId, serviceClassId, segmentId);
            if (DataSetHelper.HasRow(ds))
            {
                rtrnVal = ds.Tables[0].Rows[0]["ServiceClassDisplayName"].ToString();
            }
            return rtrnVal;

        }

        /// <summary>
        /// Get ServiceClassDisplayName
        /// </summary>
        /// <param name="utilityId">utility Id</param>
        /// <param name="serviceClassId">service Class Id</param>
        /// <returns>DisplayName string</returns>
        public static string GetPricingNamesForServiceClass(int utilityId, int serviceClassId)
        {
            string rtrnVal = string.Empty;
            DataSet ds = lc.ProductSql.GetPricingNamesForServiceClass(utilityId, serviceClassId);
            int cntr = 0;
            if (DataSetHelper.HasRow(ds))
            {
                foreach (DataRow dataRow in ds.Tables[0].Rows)
                {
                    if (cntr == 0)
                    {
                        rtrnVal = dataRow.ItemArray[0].ToString();
                    }
                    else
                    {
                        rtrnVal += "/ " + dataRow.ItemArray[0].ToString();
                    }
                    cntr += 1;
                }
            }
            return rtrnVal;

        }

        //Dec 10 2013 -  //28372: Change ProductType to Product Brand
        //Get the GetProductBrandID from PriceID
        public static Int32 GetProductBrandID(long priceID)
        {
            int type = lp.ProductSql.GetProductBrandId(priceID);
            return type;
        }


    }
}
