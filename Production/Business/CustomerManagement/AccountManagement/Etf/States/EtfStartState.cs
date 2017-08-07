using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class EtfStartState : IEtfState
	{

		public EtfStartState()
			: base( EtfState.EtfStart )
		{

		}

		public override void Process( EtfContext context )
		{

			if ( context.CompanyAccount.Etf.EtfCalculationType == EtfCalculationType.Actual )
			{
				// =======================================================================================
				// CalculationType: ACTUAL
				// =======================================================================================

				//check if the account is in the correct status that allows processing of ETFs
				AccountDeenrollmentConfirmedRule accountDeenrollmentConfirmedRule = new AccountDeenrollmentConfirmedRule( context.CompanyAccount );
				if ( accountDeenrollmentConfirmedRule.Validate() )
				{
					context.CurrentIEtfState = new ValidAccountStatusState();
				}
				else
				{
					context.CompanyAccount.Etf.EtfState = EtfState.EtfCompleted;
					context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.IncorrectAccountStatus;
					context.CompanyAccount.Etf.ErrorMessage = accountDeenrollmentConfirmedRule.Exception.Message;
					context.CurrentIEtfState = new EtfCompletedState();

				}
			}
			else
			{
				// =======================================================================================
				// CalculationType: ESTIMATED
				// =======================================================================================
				//AccountEnrolledRule accountEnrolledRule = new AccountEnrolledRule( context.CompanyAccount );
				// Account has to be in "ENROLLED" status to calculate ETF
				//if ( accountEnrolledRule.Validate() )
				//{
					context.CurrentIEtfState = new ValidAccountStatusState();
				//}
				//else
				//{
				//    context.CompanyAccount.Etf.EtfState = EtfState.EtfCompleted;
				//    context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.IncorrectAccountStatus;
				//    context.CompanyAccount.Etf.ErrorMessage = accountEnrolledRule.Exception.Message;
				//    context.CurrentIEtfState = new EtfCompletedState();
				//}
			}

		}
	}
}
