using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.Serialization;
namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
	[DataContract]
	public abstract class Product
	{
		[DataMember]
		public string ProductId
		{
			get;
			set;
		}

		[DataMember]
		public string Description { get; set; }

		[DataMember]
		public DateTime EffectiveDate
		{
			get;
			set;
		}

		[DataMember]
		public ProductCategory Category
		{
			get;
			set;
		}

		public decimal AllocatedPercentage
		{
			get;
			set;
		}

		public bool IsCustom
		{
			get;
			set;
		}

		/// <summary>
		/// Indicates ABC product
		/// </summary>
		public bool IsFlexible
		{
			get;
			set;
		}

		public bool IsABC
		{
			get
			{
				return IsFlexible;
			}
		}

		/// <summary>
		/// Product type
		/// </summary>
		public ProductType ProductType
		{
			get;
			set;
		}

		/// <summary>
		/// If tue, ETF is disabled for variable products
		/// </summary>
		public bool EtfDisabled { get; set; }

		/// <summary>
		/// Indicates if a product is in default variable
		/// </summary>
		public bool IsDefault { get; set; }

		[DataMember]
		public int ProductBrandID { get; set; }

		[DataMember]
		public bool IsMultiTerm { get; set; }

        [DataMember]
        public bool? IsGas { get; set; }

		public int MarketID { get; set; }

		public string MarketCode { get; set; }

		public string UtilityCode { get; set; }

		public int UtilityID { get; set; }

		public int AccountTypeID { get; set; }

		public override string ToString()
		{
			var description = string.Format( "Product ID: {0} MarketID: {1} UtilityID: {2} Account Type ID: {3} Product Brand ID: {4}",
				ProductId, MarketID.ToString(), UtilityID.ToString(), AccountTypeID.ToString(), ProductBrandID.ToString() );
			return description;
		}
	}
}
