using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class SalesPitchLetter
    {

        private int? salesPitchLetterID;
        public int? SalesPitchLetterID
        {
            get
            {
                return this.salesPitchLetterID;
            }
        }

		public int AccountID
            {
			get;
			set;
        }

		public DateTime DateInserted { get; set; }

		public DateTime ScheduledDate { get; set; }
		public DateTime? ProcessedDate { get; set; }

		private CompanyAccount companyAccount;
		public CompanyAccount CompanyAccount
        {
            get
            {
				if ( companyAccount == null )
                {
					companyAccount = CompanyAccountFactory.GetCompanyAccount( AccountID );
                }
				return companyAccount;
            }
		}

        public SalesPitchLetterStatus Status { get; set; }

		public int EtfID { get; set; }

		private Etf etf;
		public Etf Etf
        {
            get
            {
				if ( etf == null )
            {
					etf = CompanyAccount.Etf;
				}
				return etf;
            }
        }



		public SalesPitchLetter(  )
            {
            }

		public SalesPitchLetter( int salesPitchLetterID )
            {
			this.salesPitchLetterID = salesPitchLetterID;
        }
    }
}
