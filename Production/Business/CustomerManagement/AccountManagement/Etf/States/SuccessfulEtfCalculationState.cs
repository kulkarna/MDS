using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.EdiManagement;
using LibertyPower.Business.CustomerManagement.LetterQueue;
using LibertyPower.DataAccess.WebServiceAccess.DocumentWebService;
using LibertyPower.DataAccess.WebServiceAccess.DocumentWebService.DocumentRepository;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class SuccessfulEtfCalculationState : IEtfState
	{

		public SuccessfulEtfCalculationState()
			: base( EtfState.SuccessfulEtfCalculation )
		{

		}

		public override void Process( EtfContext context )
		{
			EtfCalculator etfCalculator = context.CompanyAccount.Etf.EtfCalculator;
			CompanyAccount companyAccount = context.CompanyAccount;

            //if ( (etfCalculator.CalculatedEtfAmount >= 0 && etfCalculator.CalculatedEtfAmount < 50) 
            //     && context.IstaResponseType == ResponseType.UtilityDeenrollmentNotification 
            //     && companyAccount.AnnualUsage >= 20000 )
            //{
            //    // Add account to sales pitch letter queue
            //    SalesPitchLetterFactory.QueueSalesPitchLetter( companyAccount );
            //    context.CurrentIEtfState = new PendingSalesPitchLetterState();
            //}

            if (context.IstaResponseType == ResponseType.UtilityDeenrollmentNotification)
            {
                // Add account to sales pitch letter queue
				//SalesPitchLetterFactory.QueueSalesPitchLetter(companyAccount);
				//context.CurrentIEtfState = new PendingSalesPitchLetterState();

				LetterQueue.LetterQueue letterQueue = new LetterQueue.LetterQueue();
				letterQueue.AccountID = companyAccount.Identity;
				letterQueue.ContractNumber = companyAccount.ContractNumber;
				letterQueue.ScheduledDate = DateTime.Today.AddDays( 1 );
                letterQueue.DocumentTypeID = 26;// DocumentService.GetDocumentTypeIDByCode("TNL");
				letterQueue.LetterQueueStatus = "Scheduled";
				letterQueue.UserName = "";

				if( etfCalculator.CalculatedEtfAmount > 0 )
				{
				LetterQueueFactory.InsertLetterQueue( letterQueue );
				}


                if (etfCalculator.CalculatedEtfAmount >= 50)
                {
                    // send to ETF invoicing Queue
                    EtfInvoiceFactory.QueueEtfInvoice(companyAccount);
                    context.CurrentIEtfState = new EtfInvoiceNotPaidState();
                }
				else
				{
					context.CurrentIEtfState = new EtfCompletedState();
				}
            }
			else
			{
				context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.NoEtfActionRequired;
				context.CurrentIEtfState = new EtfCompletedState();
			}

		}

	}
}
