using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
    public class VariableProductRate : ProductRate
    {
        public DateTime EffectiveDate
        {
            get
            {
                throw new System.NotImplementedException();
            }
            set
            {
            }
        }
    }
}
