using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
    public class FixedProductRate : ProductRate
    {
        private int term;
        
        public int Year
        {
            get
            {
                throw new System.NotImplementedException();
            }
            set
            {
            }
        }

        public int Month
        {
            get
            {
                throw new System.NotImplementedException();
            }
            set
            {
            }
        }

        public int Term
        {
            get
            {
                return term;
            }
            set
            {
                this.term = value;
            }
        }
    }
}
