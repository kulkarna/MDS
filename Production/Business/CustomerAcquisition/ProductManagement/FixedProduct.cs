using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
    public class FixedProduct : Product
    {
        public string ProfileCode
        {
			get;
			set;
        }
    }
}
