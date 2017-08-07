using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class ValidCustomerTypeState : IEtfState
	{

		public ValidCustomerTypeState()
			: base( EtfState.ValidCustomerType )
		{

		}

		public override void Process( EtfContext context )
		{
			if ( !context.CompanyAccount.Product.IsCustom )
			{
				context.CurrentIEtfState = new ValidCustomTypeState();
			}
			else
			{
				context.CompanyAccount.Etf.EtfState = EtfState.EtfCompleted;
				context.CompanyAccount.Etf.ErrorMessage = "Custom Product: Manual ETF calculation required.";
				context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.IneligibleCustomProduct;
				context.CurrentIEtfState = new EtfCompletedState();
			}
		}
	}
}
