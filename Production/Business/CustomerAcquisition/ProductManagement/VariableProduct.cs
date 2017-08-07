using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
    public class VariableProduct : Product
    {
        private ProductSubCategory subCategory;

		public string ProfileCode
		{
			get;
			set;
		}

        public ProductSubCategory SubCategory
        {
            get
            {
                return this.subCategory;
            }
            set
            {
                this.subCategory = value;
            }
        }
    }
}
