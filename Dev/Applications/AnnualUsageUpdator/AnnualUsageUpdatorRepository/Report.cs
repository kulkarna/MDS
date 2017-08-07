

namespace LibertyPower.MarketDataServices.AnnualUsageUpdatorRespository
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    public class Report
    {
       public Report() { }

       public Report(int accountBegin, int accountProcessed, int accountPending, int accountUpdated) 
		{
            AccountBegin = accountBegin;
            AccountProcessed = accountProcessed;
            AccountPending = accountPending;
            AccountUpdated = accountUpdated;
			
		}
         public int AccountBegin
        {
            get;
            set;
        }
         public int AccountProcessed
		{
			get;
			set;
		}
        public  int AccountPending
        {
            get;
            set;
        }

        public int AccountUpdated
		{
			get;
			set;
		}
       
    }
}
