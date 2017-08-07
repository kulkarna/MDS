using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Transactions;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.MarketManagement.EdiManagement;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class EtfInvoiceFactory
	{

		public static EtfInvoice GetEtfInvoice( int etfInvoiceID )
		{
			DataSet ds = EtfInvoiceSql.Get( etfInvoiceID );

			if ( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				throw new Exception( "Could not retrieve ETF Invoice information" );
			}

			DataRow dr = ds.Tables[0].Rows[0];
			EtfInvoice etfInvoice = BuildEtfInvoiceObject( dr );
			return etfInvoice;
		}


		private static EtfInvoice BuildEtfInvoiceObject( DataRow dr )
		{
			EtfInvoice etfInvoice = new EtfInvoice( Helper.ConvertFromDB<int>( dr["EtfInvoiceID"] ) );
			etfInvoice.AccountID = Helper.ConvertFromDB<int>( dr["AccountID"] );
			etfInvoice.EtfID = Helper.ConvertFromDB<int>( dr["EtfID"] );
			etfInvoice.InvoiceStatus = (EtfInvoiceStatus) Helper.ConvertFromDB<int>( dr["StatusID"] );
			etfInvoice.IsPaid = Helper.ConvertFromDB<bool>( dr["IsPaid"] );
			etfInvoice.DateInvoiced = Helper.ConvertFromDB<DateTime?>( dr["DateInvoiced"] );
			etfInvoice.IstaInvoiceNumber = Helper.ConvertFromDB<string>( dr["IstaInvoiceNumber"] );
			etfInvoice.DateInserted = Helper.ConvertFromDB<DateTime>( dr["DateInserted"] );

			return etfInvoice;
		}

		/// <summary>
		/// Adds an invoice to the account and updates / inserts it in the invoice queue
		/// </summary>
		public static void QueueEtfInvoice( CompanyAccount companyAccount )
		{
			EtfInvoice etfInvoice = new EtfInvoice();
			etfInvoice.AccountID = companyAccount.Identity;
			etfInvoice.EtfID = Convert.ToInt32( companyAccount.Etf.EtfID );
			etfInvoice.InvoiceStatus = EtfInvoiceStatus.Pending;
			etfInvoice.IsPaid = false;
			etfInvoice.DateInserted = DateTime.Now;
			Save( etfInvoice );

			companyAccount.Etf.EtfInvoice = etfInvoice;
		}

		public static int Save( EtfInvoice etfInvoice )
		{
            int? etfInvoiceID = etfInvoice.EtfInvoiceID;
			if ( etfInvoice.EtfInvoiceID.HasValue )
			{
				// Update
				EtfInvoiceSql.UpdateAccountEtfInvoiceQueue( Convert.ToInt32( etfInvoice.EtfInvoiceID ), etfInvoice.AccountID, Convert.ToInt32( etfInvoice.EtfID ), (int) etfInvoice.InvoiceStatus, etfInvoice.IsPaid, etfInvoice.DateInvoiced, etfInvoice.IstaInvoiceNumber, etfInvoice.DateInserted );
			}
			else
			{
				// Insert
				etfInvoiceID = EtfInvoiceSql.InsertAccountEtfInvoiceQueue( etfInvoice.AccountID, Convert.ToInt32( etfInvoice.EtfID ), (int) etfInvoice.InvoiceStatus, etfInvoice.IsPaid, etfInvoice.DateInserted );
			}

            return Convert.ToInt32( etfInvoiceID );
		}

		public static void ProcessInvoice( EtfInvoice etfInvoice, EtfInvoiceAction etfInvoiceAction )
		{
			EtfContext etfContext = null;

			CompanyAccount companyAccount = CompanyAccountFactory.GetCompanyAccount( etfInvoice.AccountID );

			etfContext = EtfContextFactory.Load( companyAccount );
            if (etfInvoiceAction != EtfInvoiceAction.Waive)
            {
			    if ( etfContext.CompanyAccount.Etf.EtfState != EtfState.PendingInvoice )
			    {
				    throw new Exception( "ETF Invoice can not be processed, incorrect status, current status is " + etfContext.CompanyAccount.Etf.EtfState.ToString() + ", expecting Pending invoice." );
			    }
            }
            else if ((etfInvoice.InvoiceStatus != EtfInvoiceStatus.Invoiced) && (etfInvoice.InvoiceStatus != EtfInvoiceStatus.Pending))
            {
                throw new Exception("ETF Waive can not be processed, incorrect status, current status is " + etfInvoice.InvoiceStatus.ToString() + ", expecting Pending or Invoiced invoice.");
            }
			etfContext.EtfInvoice = etfInvoice;

			if ( etfInvoiceAction == EtfInvoiceAction.Send )
			{
				etfContext.EtfProcessingAction = EtfProcessingAction.SendInvoice;
			}
			else if ( etfInvoiceAction == EtfInvoiceAction.Cancel )
			{
				etfContext.EtfProcessingAction = EtfProcessingAction.CancelInvoice;
			}
            else if (etfInvoiceAction == EtfInvoiceAction.Waive)
            {
                etfContext.EtfProcessingAction = EtfProcessingAction.WaiveInvoice;
            }

			//Process
			etfContext = EtfContextFactory.Process( etfContext );

			// Save ETF Invoice to database
			EtfContextFactory.Save( etfContext );
		}


		public static void SubmitInvoice( int etfInvoiceID, string userName )
		{

			using ( TransactionScope scope = new TransactionScope( TransactionScopeOption.RequiresNew ) )
			{
				EtfInvoice etfInvoice = EtfInvoiceFactory.GetEtfInvoice( etfInvoiceID );

				// Process 
				EtfInvoiceFactory.ProcessInvoice( etfInvoice, EtfInvoiceAction.Send );

				CompanyAccountFactory.InsertComment( etfInvoice.CompanyAccount.Identifier, "ETF INVOICED", "ETF has been invoiced on " + Convert.ToDateTime( etfInvoice.DateInvoiced ).ToShortDateString(), userName );
				scope.Complete();
			}
		}

        public static void WaiveInvoice(int etfInvoiceID, string userName)
        {

            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.RequiresNew))
            {
                EtfInvoice etfInvoice = EtfInvoiceFactory.GetEtfInvoice(etfInvoiceID);

                // Process 
                EtfInvoiceFactory.ProcessInvoice(etfInvoice, EtfInvoiceAction.Waive);

                CompanyAccountFactory.InsertComment(etfInvoice.CompanyAccount.Identifier, "ETF WAIVED", "ETF has been waived on " + DateTime.Now, userName);
                scope.Complete();
            }
        }

		public static string SendInvoiceToIsta( EtfInvoice etfInvoice )
		{
            //string istaInvoiceNumner = EdiInvoiceFactory.SubmitEtfInvoice( etfInvoice.CompanyAccount.AccountNumber, Convert.ToDecimal( etfInvoice.Etf.EtfCalculator.CalculatedEtfAmount ), etfInvoice.IsPaid );
            string istaInvoiceNumner = EdiInvoiceFactory.SubmitEtfInvoice( etfInvoice.CompanyAccount.AccountNumber, Convert.ToDecimal( etfInvoice.Etf.EtfCalculator.EtfFinalAmount ), etfInvoice.IsPaid );

			return istaInvoiceNumner;
		}

		public static EtfInvoiceList GetList( string accountNumber, string customerName, string istaInvoiceNumber, int invoiceStatus, DateTime? invoiceStartDate, DateTime? invoiceEndDate, DateTime? insertedStart, DateTime? insertedEnd, int? aging )
		{

			DataSet ds = EtfInvoiceSql.GetList( accountNumber, customerName, istaInvoiceNumber, invoiceStatus, invoiceStartDate, invoiceEndDate, insertedStart, insertedEnd, aging );

			if ( ds == null || ds.Tables.Count == 0 )
			{
				throw new Exception( "Could not retrieve ETF Invoice data." );
			}


			EtfInvoiceList etfInvoiceList = new EtfInvoiceList();

			foreach ( DataRow dr in ds.Tables[0].Rows )
			{
				EtfInvoice etfInvoice = BuildEtfInvoiceObject( dr );
				etfInvoiceList.Add( etfInvoice );
			}

			return etfInvoiceList;
		}

	}
}
