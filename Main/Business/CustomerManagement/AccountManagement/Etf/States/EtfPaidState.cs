using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class EtfPaidState : IEtfState
	{
		public EtfPaidState()
			: base( EtfState.EtfPaid )
		{
			this.Persist = true;
		}

		public override void Process( EtfContext context )
		{

			//check if the account is in the correct status that allows processing of ETFs
			AccountDeenrollmentConfirmedRule accountDeenrollmentConfirmedRule = new AccountDeenrollmentConfirmedRule( context.CompanyAccount );
			if ( accountDeenrollmentConfirmedRule.Validate() )
			{
				bool waiveEtf = context.CompanyAccount.WaiveEtf;
				if ( !waiveEtf )
				{
					// send to ETF invoicing Queue
					EtfInvoiceFactory.QueueEtfInvoice( context.CompanyAccount );
					context.CurrentIEtfState = new PendingInvoiceState();
				}
				else
				{
					context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.EtfWaived;
					context.CurrentIEtfState = new EtfCompletedState();
				}
			}
			else
			{
				context.CompanyAccount.Etf.ErrorMessage = "Account has to be in status Deenrollment Confirmed.";
				context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.IncorrectAccountStatus;
				context.CurrentIEtfState = new EtfCompletedState();
			}
			
		}

	}
}
