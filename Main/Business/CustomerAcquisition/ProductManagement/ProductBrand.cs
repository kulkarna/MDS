namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	using System;
	using System.Runtime.Serialization;
	using System.Collections.Generic;
	using System.Text;

	/// <summary>
	/// Product brand class
	/// </summary>
	[Serializable]
	[DataContract]
	public class ProductBrand : Product
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public ProductBrand() { }

		/// <summary>
		/// Constructor that takes the product name
		/// </summary>
		/// <param name="name">Product name</param>
		public ProductBrand( string name )
		{
			this.Name = name;
		}

		/// <summary>
		/// Constructor that takes the product name
		/// </summary>
		/// <param name="identity">Product brand record identifier</param>
		public ProductBrand( int identity )
		{
			this.ProductBrandID = identity;
		}
		/// <summary>
		/// Product record identifier
		/// </summary>
		[DataMember]
		public int ProductIdentity
		{
			get;
			set;
		}

		/// <summary>
		/// Product type record identifier
		/// </summary>
		[DataMember]
		public int ProductTypeID
		{
			get;
			set;
		}

		/// <summary>
		/// Product brand name
		/// </summary>
		[DataMember]
		public string Name
		{
			get;
			set;
		}

		/// <summary>
		/// Active indicator
		/// </summary>
		[DataMember]
		public bool IsActive
		{
			get;
			set;
		}

		/// <summary>
		/// Username
		/// </summary>
		[DataMember]
		public string Username
		{
			get;
			set;
		}

		/// <summary>
		/// Date created
		/// </summary>
		[DataMember]
		public DateTime DateCreated
		{
			get;
			set;
		}
	}
}
