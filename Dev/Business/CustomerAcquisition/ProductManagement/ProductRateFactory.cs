using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
	public static class ProductRateFactory
	{
		public static ProductRate CreateProductRate( string productId, int rateId )
		{
			// The code which was previously here was found to be identical to the method being called below.
			return CreateAccountProductRate( productId, rateId );
		}

		public static ProductRate CreateAccountProductRate( string productId, int rateId )
		{
			// TODO: Need to pass in today's date without the time portion.
			// If a prior date was not specified, we will fetch the rates for today.
			return CreateAccountProductRate( productId, rateId, DateTime.Now );
		}

		public static ProductRate CreateAccountProductRateReadOnly( string productId, int rateId, DateTime dealDate )
		{
			bool ShowActiveOnly = false;
			Product product = ProductFactory.CreateProduct( productId.Trim(), ShowActiveOnly );


			return GetAccountProductRate( product, rateId, dealDate );
		}

		public static ProductRate CreateAccountProductRate( string productId, int rateId, DateTime dealDate )
		{
			Product product = ProductFactory.CreateProduct( productId.Trim() );


			return GetAccountProductRate( product, rateId, dealDate );
		}

		public static ProductRate GetAccountProductRate( Product product, int rateId, DateTime dealDate )
		{
			ProductRate prodRate = new FixedProductRate();

			DataSet ds = ProductSql.GetProductRate( product.ProductId.Trim(), rateId, dealDate );

			if( ds.Tables[0].Rows.Count > 0 )
			{
				if( product.Category == ProductCategory.Variable )
					prodRate = new VariableProductRate();

				if( ds.Tables[0].Rows[0]["GrossMargin"] == DBNull.Value )
					prodRate.GrossMarginValue = null;
				else
					prodRate.GrossMarginValue = Convert.ToDecimal( ds.Tables[0].Rows[0]["GrossMargin"] );
				prodRate.Product = product;
				prodRate.Rate = Convert.ToDecimal( ds.Tables[0].Rows[0]["Rate"] );
				prodRate.RateId = rateId;
				prodRate.EndDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["EndDate"] );
			}

			return prodRate;
		}

		public static int GetNewRateID()
		{
			int rateID = 0;

			DataSet ds = ProductSql.GetNewRateID();
			if( DataSetHelper.HasRow( ds ) )
			{
				rateID = Convert.ToInt32( ds.Tables[0].Rows[0]["RateID"] );
			}
			return rateID;
		}

		public static void AddProductRate( string productId, int rateId, decimal rate, string rateDescription, int term, decimal grossMargin, string indexType, int billingTypeID, DateTime startDate, DateTime effectiveDate, DateTime dueDate, int gracePeriod, int zoneID, int serviceClassID, DateTime activeDate, DateTime dateCreated, string username, string ratesString = null )
		{
			ProductSql.AddProductRate( productId, rateId, rate, rateDescription, term, grossMargin, indexType, billingTypeID, startDate, effectiveDate, dueDate, gracePeriod, zoneID, serviceClassID, activeDate, dateCreated, username, ratesString );
		}

		public static void UpdateGrossMargin( string productId, int rateId, decimal grossMargin )
		{
			ProductSql.UpdateGrossMargin( productId, rateId, grossMargin );
		}
	}
}
