using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Runtime.InteropServices;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.CommonBusiness.CommonExceptions;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	/// <summary>
	/// Rule to determine if product is convertible
	/// </summary>
	[Serializable]
	[Guid( "F09EA8E5-54D6-4118-8C24-34BFDB884710" )]
	public class ProductConvertibleRule : BusinessRule
	{
		private string productId;
		private string productDescription;

		/// <summary>
		/// Constructor taking product id
		/// </summary>
		/// <param name="productId">Identifier for product</param>
		public ProductConvertibleRule( string productId )
			: base( "Product Convertible Rule", BrokenRuleSeverity.Error )
		{
			this.productId = productId;
		}

		/// <summary>
		/// Validate
		/// </summary>
		/// <returns>True or false</returns>
		public override bool Validate()
		{
			DataSet ds = ProductSql.GetProductByProductId( this.productId );

			if( ds != null )
				if( ds.Tables[0] != null )
					if( ds.Tables[0].Rows.Count > 0 )
						if( Convert.ToInt16(ds.Tables[0].Rows[0]["is_convertible"]) == 0 )
						{
							productDescription = ds.Tables[0].Rows[0]["product_descp"].ToString();

							string format = "Product {0} cannot be converted.";
							string reason = string.Format( format, productDescription );
							this.SetException( reason );
						}

			return this.Exception == null;
		}
	}
}
