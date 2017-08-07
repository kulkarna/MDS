using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{

	public class EtfEstimatedState : IEtfState
	{

		public EtfEstimatedState()
			: base( EtfState.EtfEstimated )
		{
			this.Persist = true;
		}

		public override void Process( EtfContext context )
		{

			if( context.EtfProcessingAction == EtfProcessingAction.CreateInvoice )
			{
				//AccountDeenrollmentConfirmedRule accountDeenrollmentConfirmedRule = new AccountDeenrollmentConfirmedRule( context.CompanyAccount );
				//if( accountDeenrollmentConfirmedRule.Validate() )
				//{
					bool waiveEtf = context.CompanyAccount.WaiveEtf;
					if( !waiveEtf )
					{
						EtfInvoiceFactory.QueueEtfInvoice( context.CompanyAccount );
						context.CurrentIEtfState = new EtfInvoiceNotPaidState();
					}
					else
					{
						context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.EtfWaived;
						context.CurrentIEtfState = new EtfCompletedState();
					}
				//}
				//else
				//{
				//	context.CompanyAccount.Etf.ErrorMessage = "Account has to be in status Deenrollment Confirmed.";
				//	context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.IncorrectAccountStatus;
				//  context.CurrentIEtfState = new EtfCompletedState();
				//	}
			}
			else if ( context.EtfProcessingAction == EtfProcessingAction.ProcessActualEtf )
			{
				// Process unpaid actual ETF
				context.CompanyAccount.Etf.EtfCalculationType = EtfCalculationType.Actual;

				//check if the account is in the correct status that allows processing of ETFs
				AccountDeenrollmentConfirmedRule accountDeenrollmentConfirmedRule = new AccountDeenrollmentConfirmedRule( context.CompanyAccount );
				if ( accountDeenrollmentConfirmedRule.Validate() )
				{
					context.CurrentIEtfState = new ValidAccountStatusState();
				}
				else
				{
					context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.IncorrectAccountStatus;
					context.CompanyAccount.Etf.ErrorMessage = accountDeenrollmentConfirmedRule.Exception.Message;
					context.CurrentIEtfState = new EtfCompletedState();
				}
			}
			else
			{
				// Recalculate Estimated ETF
				context.CurrentIEtfState = new EtfStartState();
			}

		}

	}
}
