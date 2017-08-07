using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class EtfInvoice
    {

        private int? etfInvoiceID;
        public int? EtfInvoiceID
        {
            get
            {
                return this.etfInvoiceID;
            }
        }

        public int AccountID
        {
            get;
            set;
        }

        public DateTime DateInserted { get; set; }

        public DateTime? DateInvoiced { get; set; }

        public int Aging
        {
            get { return (DateTime.Now - DateInserted).Days; }
        }

        private CompanyAccount companyAccount;
        public CompanyAccount CompanyAccount
        {
            get
            {
                if (companyAccount == null)
                {
                    companyAccount = CompanyAccountFactory.GetCompanyAccount(AccountID);
                }
                return companyAccount;
            }
        }

        public string IstaInvoiceNumber { get; set; }

        public EtfInvoiceStatus InvoiceStatus { get; set; }

		public bool IsPaid { get; set; }

		public int EtfID { get; set; }

		private Etf etf;
		public Etf Etf
		{
			get
			{
				if ( etf == null )
				{
					etf = EtfFactory.Get(CompanyAccount);
				}
				return etf;
			}
		}


		public EtfInvoice(  )
		{
		}

        public EtfInvoice(int etfInvoiceID)
        {
            this.etfInvoiceID = etfInvoiceID;
        }


    }
}
