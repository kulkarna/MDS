using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.EdiManagement;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class EtfContext
	{
		public EtfContext( CompanyAccount companyAccount )
		{
			this.companyAccount = companyAccount;
			this.EtfProcessingAction = EtfProcessingAction.None;
		}

		private CompanyAccount companyAccount;
		public CompanyAccount CompanyAccount
		{
			get
			{
				return companyAccount;
			}
		}

		public EtfInvoice EtfInvoice { get; set; }

		public ResponseType IstaResponseType { get; set; }

		public SalesPitchLetter SalesPitchLetter { get; set; }

		/// <summary>
		/// Indicated the current ETF State of the context object
		/// </summary>
		public IEtfState CurrentIEtfState
		{
			get;
			set;
		}


		public EtfProcessingAction EtfProcessingAction { get; set; }

		///// <summary>
		///// Specifies the SalesPitchLetter action (SEND or CANCEL), 
		///// only needed when in state PendingSalesPitchLetterState
		///// </summary>
		//public SalesPitchLetterAction SalesPitchLetterAction { get; set; }

		///// <summary>
		///// Specifies the EtfInvoice action chosen by the user (SEND or CANCEL), 
		///// only needed when in state PendingInvoiceState
		///// </summary>
		//public EtfInvoiceAction EtfInvoiceAction { get; set; }


		///// <summary>
		///// Specifies the EtfPaying action chosen by the user (PAY or NONE), 
		///// only needed when in state PendingEtfPaidState
		///// </summary>
		//public EtfPayingAction EtfPayingAction { get; set; }


		/// <summary>
		/// 
		/// </summary>
		/// <returns>A boolean whether to stop or continue processing</returns>
		public bool ProcessNext()
		{
			this.CurrentIEtfState.Process( this );

			if ( this.CurrentIEtfState.Persist )
			{
				return false; // = stopProcessing
			}
			else
			{
				return true; // = continueProcessing
			}
		}
	}
}
