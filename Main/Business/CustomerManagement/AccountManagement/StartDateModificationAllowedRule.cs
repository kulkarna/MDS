using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Runtime.InteropServices;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.CommonBusiness.CommonExceptions;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// Determines if start date can be modified based on the parameter of product id.
	/// Currently only accounts with fixed products can have start date modified.
	/// </summary>
	[Guid( "914C9F93-7482-4e28-BB28-6932B22B301F" )]
	public class StartDateModificationAllowedRule : BusinessRule
	{
		private string productId;
		private string productDescription;

		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="productId">Identifier of product</param>
		public StartDateModificationAllowedRule( string productId )
			: base( "Start Date Modification Allowed Rule", BrokenRuleSeverity.Error )
		{
			this.productId = productId;
		}

		/// <summary>
		/// Identifier of product
		/// </summary>
		public string ProductId
		{
			get { return this.productId; }
		}


		/// <summary>
		/// Overridden method to validate rule
		/// </summary>
		/// <returns>True or false</returns>
		public override bool Validate()
		{
			DataSet ds = ProductSql.GetProductByProductId( this.productId );

			if(ds != null)
				if(ds.Tables[0] != null)
					if( ds.Tables[0].Rows.Count > 0)
						if( !ds.Tables[0].Rows[0]["product_category"].ToString().Contains( "VAR" ) )
						{
							productDescription = ds.Tables[0].Rows[0]["product_descp"].ToString();
							CreateException();
						}

			return this.Exception == null;
		}

		/// <summary>
		/// Creates exception
		/// </summary>
		private void CreateException()
		{
			string format = "Start date cannot be modified for product {0}.";
			string reason = string.Format( format, this.productDescription );
			this.SetException( reason );
		}
	}
}
