using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
    public class IndexedProduct : VariableProduct
    {
        public ProductIndex Index
        {
			get;
			set;
        }

        public Decimal Adder
        {
			get;
			set;
        }

        public decimal EstimatedValue
        {
			get;
			set;
        }
    }
}
