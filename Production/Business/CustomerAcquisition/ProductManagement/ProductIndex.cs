using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
    public class ProductIndex
    {
        public int SourceDescription
        {
			get;
			set;
        }

        public string MarketCode
        {
			get;
			set;
        }

        public ProductIndexType IndexType
        {
			get;
			set;
        }
    }
}
