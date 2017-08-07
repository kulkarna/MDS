using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using System.Transactions;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class EtfContextFactory
	{

		public static EtfContext Create( CompanyAccount companyAccount, EtfCalculationType etfCalculationType )
		{
			EtfContext etfContext = new EtfContext( companyAccount );
			etfContext.CurrentIEtfState = new EtfStartState();
			etfContext.CompanyAccount.Etf.EtfCalculationType = etfCalculationType;

			return etfContext;
		}

		public static EtfContext Load( CompanyAccount companyAccount )
		{
			EtfContext etfContext = new EtfContext( companyAccount );
			etfContext.CompanyAccount.Etf = EtfFactory.Get( companyAccount );

			switch ( etfContext.CompanyAccount.Etf.EtfState )
			{
				case EtfState.EtfEstimated:
					etfContext.CurrentIEtfState = new EtfEstimatedState();
					break;
				case EtfState.PendingInvoice:
					etfContext.CurrentIEtfState = new EtfInvoiceNotPaidState();
					break;
				case EtfState.PendingSalesPitchLetter:
					etfContext.CurrentIEtfState = new PendingSalesPitchLetterState();
					break;
				case EtfState.EtfCompleted:
					etfContext.CurrentIEtfState = new EtfCompletedState();
					break;
			}

			return etfContext;
		}

		public static void Save( EtfContext etfContext )
		{

			using ( TransactionScope trans = new TransactionScope() )
			{
				Etf etf = etfContext.CompanyAccount.Etf;

				// Set ETF State to current ETF State of the context obejct
				etf.EtfState = etfContext.CurrentIEtfState.EtfState;

				int etfID = EtfFactory.SaveEtf( etf, etfContext.CompanyAccount.Identity );

				trans.Complete();
			}

		}

		public static EtfContext Process( EtfContext etfContext )
		{
			bool keepProcessing = etfContext.ProcessNext();
			while ( keepProcessing )
			{
				keepProcessing = etfContext.ProcessNext();
			}
			return etfContext;
		}

	}
}
