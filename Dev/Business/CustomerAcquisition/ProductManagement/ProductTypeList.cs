namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
using System;
	using System.Runtime.Serialization;
using System.Collections.Generic;
using System.Text;

	/// <summary>
	/// List of product types
	/// </summary>
	[Serializable]
	[DataContract]
	public class ProductTypeList : List<ProductType>
	{
	}
}
