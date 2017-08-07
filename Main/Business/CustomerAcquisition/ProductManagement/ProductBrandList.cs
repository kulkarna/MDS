using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.Serialization;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	/// <summary>
	/// List of product brands
	/// </summary>
	[Serializable]
    [DataContract]
	public class ProductBrandList : List<ProductBrand>
	{
	}
}
