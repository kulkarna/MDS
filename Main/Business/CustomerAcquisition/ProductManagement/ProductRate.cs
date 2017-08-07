using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
    public abstract class ProductRate
    {
		public int Zone
		{
			get;
			set;
		}

        public int Market
        {
			get;
			set;
        }

        public string UtilityCode
        {
			get;
			set;
        }

        public Product Product
        {
			get;
			set;
        }

        public decimal Rate
        {
			get;
			set;
        }

		public int RateId
		{
			get;
			set;
		}

        public string ServiceClass
        {
			get;
			set;
        }

        public decimal Value
        {
			get;
			set;
        }

        public AccountType AccountType
        {
			get;
			set;
        }

        public decimal? GrossMarginValue
        {
			get;
			set;
        }

		public DateTime EndDate
		{
			get;
			set;
		}

        public string RateDescription
        {
            get;
            set;
        }
    }
}
