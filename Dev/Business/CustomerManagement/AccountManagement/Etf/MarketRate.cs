using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;


namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class MarketRate
    {

        private float? rate;
        public float? Rate
        {
            get
            {
                return rate;
            }
        }

        public bool HasError
        {
            get
            {
                if (this.ErrorMessage != String.Empty)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        private string errorMessage = String.Empty;
        public string ErrorMessage
        {
            get
            {
                return errorMessage;
            }
        }

        public MarketRate(float rate)
        {
            this.rate = rate;
        }

        public MarketRate(string errorMessage)
        {
            this.errorMessage = errorMessage;
        }


    }
}
