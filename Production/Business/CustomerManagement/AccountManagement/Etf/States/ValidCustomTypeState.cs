using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;
using System.Linq;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class ValidCustomTypeState : IEtfState
	{

		public ValidCustomTypeState()
			: base( EtfState.ValidCustomType )
		{

		}

		public override void Process( EtfContext context )
		{
			if ( context.CompanyAccount.WaiveEtf )
			{
				context.CompanyAccount.Etf.EtfState = EtfState.EtfCompleted;

				EtfWaivedReasonCodeList etfReasonCodes = EtfWaivedReasonCodeFactory.GetCodes();

				string reason = "Unknown Reason";
				if ( context.CompanyAccount.WaivedEtfReasonCodeID.HasValue )
				{
					var result = (from e in etfReasonCodes
								  where e.ReasonID == context.CompanyAccount.WaivedEtfReasonCodeID
								  select e.ReasonCode).FirstOrDefault();

					if ( result != String.Empty )
					{
						reason = result;
					}
				}
				else
				{
					reason = "Unknown Reason Code";
				}

				context.CompanyAccount.Etf.ErrorMessage = "ETF waived: " + reason;
				context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.EtfWaived;
				context.CurrentIEtfState = new EtfCompletedState();
			}
			else
			{
				context.CurrentIEtfState = new ProductEligibilityCheckState();
			}
		}

	}

}
