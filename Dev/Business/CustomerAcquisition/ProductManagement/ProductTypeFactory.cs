using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	/// <summary>
	/// Factory for the ProductType class
	/// </summary>
	[Serializable]
	public static class ProductTypeFactory
	{

		/// <summary>
		/// Gets the productType.
		/// </summary>
		/// <param name="id">The id.</param>
		/// <returns></returns>
		public static ProductType GetProductType( int id )
		{
			ProductType productType = null;
			DataSet ds = ProductSql.ProductTypeGet( id );
			
			if(DataSetHelper.HasRow(ds))
			{
				productType = LoadProductType( ds.Tables[0].Rows[0] );
			}
			
			return productType;
		}

		/// <summary>
		/// Gets the productType.
		/// </summary>
		/// <param name="name">The name.</param>
		/// <returns></returns>
		public static ProductType GetProductType( string name )
		{
			ProductType productType = null;
			DataSet ds = ProductSql.ProductTypeGet( name );

			if( DataSetHelper.HasRow( ds ) )
			{
				productType = LoadProductType( ds.Tables[0].Rows[0] );
			}

			return productType;
		}

		/// <summary>
		/// Loads the productType object.
		/// </summary>
		/// <param name="datarow">The datarow.</param>
		/// <returns></returns>
		private static ProductType LoadProductType( DataRow datarow )
		{
			ProductType pt = new ProductType();

			pt.Identity = Convert.ToInt32( datarow["ProductTypeID"] );
			pt.Name = Convert.ToString( datarow["Name"] );
			pt.IsActive = Convert.ToBoolean( datarow["Active"] );
			pt.UserName = Convert.ToString( datarow["UserName"] );
			pt.DateCreated = Convert.ToDateTime( datarow["DateCreated"] );

			return pt;
		}

		/// <summary>
		/// Creates product type object from data row.
		/// </summary>
		/// <param name="datarow">Data row</param>
		/// <returns>Returns a product type object from data row.</returns>
		public static ProductType CreateProductType( DataRow dr )
		{
			ProductType pt = new ProductType();

			pt.Identity = Convert.ToInt32( dr["ProductTypeID"] );
			pt.Name = Convert.ToString( dr["Name"] );

			return pt;
		}

		/// <summary>
		/// Gets product types
		/// </summary>
		/// <returns>Returns a list of product types</returns>
		public static ProductTypeList GetProductTypes()
		{
			ProductTypeList list = new ProductTypeList();

			list.Add( GetProductTypeAllOthers() );

			DataSet ds = ProductSql.GetProducts();

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( LoadProductType( dr ) );
			}

			return list;
		}

		/// <summary>
		/// Gets product type object for all others
		/// </summary>
		/// <returns>Returns a product type object for all others.</returns>
		public static ProductType GetProductTypeAllOthers()
		{
			ProductType pt = new ProductType();

			pt.Identity = -1;
			pt.Name = "All Others";

			return pt;
		}
	}
}
