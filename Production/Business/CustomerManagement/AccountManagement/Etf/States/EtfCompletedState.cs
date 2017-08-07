using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class EtfCompletedState : IEtfState
	{
		public EtfCompletedState()
			: base( EtfState.EtfCompleted )
		{
			this.Persist = true;
		}


		public override void Process( EtfContext context )
		{

			if ( context.EtfProcessingAction == EtfProcessingAction.WaiveInvoice )
			{
                if (context.EtfInvoice.InvoiceStatus == EtfInvoiceStatus.Pending)
                {
                    EtfInvoice etfInvoice = context.EtfInvoice;
                    etfInvoice.InvoiceStatus = EtfInvoiceStatus.Waived;
                    etfInvoice.DateInvoiced = DateTime.Now;
                    EtfInvoiceFactory.Save(etfInvoice);

                    context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.EtfWaived;
                }
                else
                {
                    // Mark the original invoice as waived.
                    context.EtfInvoice.InvoiceStatus = EtfInvoiceStatus.Waived;
                    EtfInvoiceFactory.Save(context.EtfInvoice);

                    //Creating ETF
                    Etf etfNew = EtfFactory.Get(context.CompanyAccount);

                    etfNew.EtfID = null;
                    etfNew.EtfCalculator.EtfCalculationID = null;
                    etfNew.EtfCalculator.EtfFinalAmount = -1 * etfNew.EtfCalculator.EtfFinalAmount;

                    int etfID = EtfFactory.SaveEtf(etfNew, context.EtfInvoice.AccountID);


                    //Creating Invoice
                    EtfInvoice etfInvoice = new EtfInvoice();

                    etfInvoice.AccountID = context.EtfInvoice.AccountID;
                    etfInvoice.EtfID = etfID;
                    etfInvoice.InvoiceStatus = EtfInvoiceStatus.Pending;
                    etfInvoice.IsPaid = true;
                    etfInvoice.DateInserted = DateTime.Now;

                    int etfInvoiceID = EtfInvoiceFactory.Save(etfInvoice);
                    etfInvoice = EtfInvoiceFactory.GetEtfInvoice(etfInvoiceID);

                    string istaInvoiceNumber = EtfInvoiceFactory.SendInvoiceToIsta(etfInvoice);

                    etfInvoice.IstaInvoiceNumber = istaInvoiceNumber;
                    etfInvoice.InvoiceStatus = EtfInvoiceStatus.Invoiced;
                    etfInvoice.DateInvoiced = DateTime.Now;

                    EtfInvoiceFactory.Save(etfInvoice);

                    context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.CompletedEtfInvoice;
                }
			}

		}
	}
}

