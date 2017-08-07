using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class FixedEtfResult : EtfResult
    {

        public int LostTermDays
        {
            get;
            set;
        }

        public int LostTermMonths
        {
            get;
            set;
        }

        public decimal MarketRate
        {
            get;
            set;
        }

        public int AnnualUsage
        {
            get;
            set;
        }

        public int Term
        {
            get;
            set;
        }

        public decimal Rate
        {
            get;
            set;
        }

        public DateTime FlowStartDate
        {
            get;
            set;
        }

        public DateTime DeenrollmentDate
        {
            get;
            set;
        }

        public int DropMonthIndicator
        {
            get;
            set;
        }
        

        public FixedEtfResult()
        {
            this.EtfResultType = EtfResultType.Fixed;
        }

        public FixedEtfResult(string errorMessage)
            : base(errorMessage)
        {
            this.EtfResultType = EtfResultType.Fixed;
        }

    }
}
