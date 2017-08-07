using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class EtfResult
    {

        public EtfResultType EtfResultType
        {
            get;
            set;
        }

        public decimal? CalculatedEtfAmount
        {
            get;
            set;
        }

        public decimal? DisplayEtfAmount
        {
            get
            {
                if (CalculatedEtfAmount.HasValue && CalculatedEtfAmount < 0)
                {
                    return 0;
                }
                else
                {
                    return CalculatedEtfAmount;
                }
            }
        }

        public EtfResult()
        {
            this.EtfResultType = EtfResultType.Undefined;
        }

        public EtfResult(string errorMessage)
        {
            this.EtfResultType = EtfResultType.Undefined;
            this.ErrorMessage = errorMessage;
        }

        public bool HasError
        {
            get
            {
                if (this.ErrorMessage == null || this.ErrorMessage == string.Empty)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
        }

        public string ErrorMessage { get; set; }

    }
}
