using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class ValidAccountStatusState : IEtfState
	{

		public ValidAccountStatusState()
			: base( EtfState.ValidAccountStatus )
		{

		}
	
		public override void Process( EtfContext context )
		{
			if ( context.CompanyAccount.IsSmbOrResidential )
			{
				context.CurrentIEtfState = new ValidCustomerTypeState();
			}
			else
			{
				context.CompanyAccount.Etf.EtfState = EtfState.EtfCompleted;
				context.CompanyAccount.Etf.ErrorMessage = "This is a LCI account. Manual ETF calculation required." ;
				context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.InvalidCustomerType;
				context.CurrentIEtfState = new EtfCompletedState();
			}
		}

	}
}
