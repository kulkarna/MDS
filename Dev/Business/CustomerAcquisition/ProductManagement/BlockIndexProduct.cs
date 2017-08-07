using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
    public class BlockIndexProduct : IndexedProduct
    {
        public Decimal OffPeakKw
        {
			get;
			set;
        }

        public decimal PeakKw
        {
			get;
			set;
        }

        public Decimal OffPeakRate
        {
			get;
			set;
        }

        public decimal PeakRate
        {
			get;
			set;
        }
    }
}
