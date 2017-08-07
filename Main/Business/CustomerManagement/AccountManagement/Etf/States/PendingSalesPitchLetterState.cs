using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class PendingSalesPitchLetterState : IEtfState
	{

		public PendingSalesPitchLetterState()
			: base( EtfState.PendingSalesPitchLetter )
		{
			this.Persist = true;
		}


		public override void Process( EtfContext context )
		{

			if ( context.EtfProcessingAction == EtfProcessingAction.CancelSalesPitchLetter )
			{
				SalesPitchLetter salesPitchLetter = context.SalesPitchLetter;
				salesPitchLetter.Status = SalesPitchLetterStatus.Cancelled;
				salesPitchLetter.ProcessedDate = DateTime.Now;

				SalesPitchLetterFactory.Save( salesPitchLetter );

				context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.CancelledSalesPitchLetter;
			}
			else if ( context.EtfProcessingAction == EtfProcessingAction.ProcessSalesPitchLetter )
			{
				SalesPitchLetter salesPitchLetter = context.SalesPitchLetter;
				salesPitchLetter.Status = SalesPitchLetterStatus.Processed;
				salesPitchLetter.ProcessedDate = DateTime.Now;

				SalesPitchLetterFactory.Save( salesPitchLetter );

				context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.CompletedSalesPitchLetter;
			}
			else if ( context.EtfProcessingAction == EtfProcessingAction.ProcessSalesPitchLetterManually )
			{
				SalesPitchLetter salesPitchLetter = context.SalesPitchLetter;
				salesPitchLetter.Status = SalesPitchLetterStatus.ProcessedManually;
				salesPitchLetter.ProcessedDate = DateTime.Now;

				SalesPitchLetterFactory.Save( salesPitchLetter );

				context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.CompletedSalesPitchLetter;
			}

			context.CurrentIEtfState = new EtfCompletedState();
			
		}
	}

}
