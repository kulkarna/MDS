using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class RetentionSavedAccount
	{

		private int? savedAccountsQueueID;
		public int? SavedAccountsQueueID
		{
			get
			{
				return this.savedAccountsQueueID;
			}
		}

		public int AccountID
		{
			get;
			set;
		}

		public DateTime DateInserted { get; set; }

		public DateTime? DateProcessed { get; set; }

		public string ProcessedBy { get; set; }

		public string IstaWaivedInvoiceNumber { get; set; }

		public int Aging
		{
			get { return (DateTime.Now - DateInserted).Days; }
		}

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

		public int EtfInvoiceID { get; set; }

		private EtfInvoice etfInvoice;
		public EtfInvoice EtfInvoice
		{
			get
			{
				if ( etfInvoice == null )
				{
					etfInvoice = EtfInvoiceFactory.GetEtfInvoice( EtfInvoiceID );
				}
				return etfInvoice;
			}
		}

		public RetentionSavedAccountStatus Status { get; set; }

		public int EtfID { get; set; }

		private Etf etf;
		public Etf Etf
		{
			get
			{
				if ( etf == null )
				{
					etf = EtfFactory.Get( CompanyAccount );
				}
				return etf;
			}
		}


		public RetentionSavedAccount()
		{
		}

		public RetentionSavedAccount( int savedAccountsQueueID )
		{
			this.savedAccountsQueueID = savedAccountsQueueID;
		}


	}
}
