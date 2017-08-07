using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class EtfInvoiceNotPaidState : IEtfState
	{

		public EtfInvoiceNotPaidState()
			: base( EtfState.PendingInvoice )
		{
			this.Persist = true;
		}

		public override void Process( EtfContext context )
		{

			if ( context.EtfProcessingAction == EtfProcessingAction.CancelInvoice )
			{
				EtfInvoice etfInvoice = context.EtfInvoice;
				etfInvoice.InvoiceStatus = EtfInvoiceStatus.Cancelled;
				etfInvoice.DateInvoiced = DateTime.Now;
				EtfInvoiceFactory.Save( etfInvoice );

				context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.CancelledEtfInvoice;
			}
			else if ( context.EtfProcessingAction == EtfProcessingAction.SendInvoice )
			{
				EtfInvoice etfInvoice = context.EtfInvoice;

				string istaInvoiceNumber = EtfInvoiceFactory.SendInvoiceToIsta( etfInvoice );
				etfInvoice.IstaInvoiceNumber = istaInvoiceNumber;
				etfInvoice.InvoiceStatus = EtfInvoiceStatus.Invoiced;
				etfInvoice.DateInvoiced = DateTime.Now;

				EtfInvoiceFactory.Save( etfInvoice );

				context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.CompletedEtfInvoice;
			}
			else if( context.EtfProcessingAction == EtfProcessingAction.PayEtf )
			{
				Etf etf = context.CompanyAccount.Etf;
				etf.EtfState = EtfState.EtfPaid;
				etf.EtfInvoice.IsPaid = true;
                etf.EtfInvoice.InvoiceStatus = EtfInvoiceStatus.Paid;
				etf.EtfEndStatus = EtfEndStatus.CompletedEtfInvoice;

				EtfInvoiceFactory.Save( etf.EtfInvoice );
				
				EtfFactory.SendPaidEtfNotificationEmail( context.CompanyAccount );
			}
            else if (context.EtfProcessingAction == EtfProcessingAction.WaiveInvoice)
            {
                EtfInvoice etfInvoice = context.EtfInvoice;
                etfInvoice.InvoiceStatus = EtfInvoiceStatus.Waived;
                etfInvoice.DateInvoiced = DateTime.Now;
                EtfInvoiceFactory.Save(etfInvoice);

                context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.EtfWaived;
            }

			context.CurrentIEtfState = new EtfCompletedState();
		}

	}
}
