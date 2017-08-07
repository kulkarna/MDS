using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Transactions;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.MarketManagement.EdiManagement;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class RetentionSavedAccountFactory
	{

		public static RetentionSavedAccount GetRetentionSavedAccount( int savedAccountsQueueID )
		{
			DataSet ds = RetentionSavedAccountsQueueSql.Get( savedAccountsQueueID );

			if ( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				throw new Exception( "Could not retrieve Retention Saved Account information" );
			}

			DataRow dr = ds.Tables[0].Rows[0];
			RetentionSavedAccount retentionSavedAccount = BuildRetentionSavedAccountObject( dr );
			return retentionSavedAccount;
		}


		private static RetentionSavedAccount BuildRetentionSavedAccountObject( DataRow dr )
		{
			RetentionSavedAccount retentionSavedAccount = new RetentionSavedAccount( Helper.ConvertFromDB<int>( dr["SavedAccountsQueueID"] ) );
			retentionSavedAccount.AccountID = Helper.ConvertFromDB<int>( dr["AccountID"] );
			retentionSavedAccount.EtfID = Helper.ConvertFromDB<int>( dr["EtfID"] );
			retentionSavedAccount.EtfInvoiceID = Helper.ConvertFromDB<int>( dr["EtfInvoiceID"] );
			retentionSavedAccount.Status = (RetentionSavedAccountStatus) Helper.ConvertFromDB<int>( dr["StatusID"] );
			retentionSavedAccount.DateProcessed = Helper.ConvertFromDB<DateTime?>( dr["DateProcessed"] );
			retentionSavedAccount.DateInserted = Helper.ConvertFromDB<DateTime>( dr["DateInserted"] );
			retentionSavedAccount.IstaWaivedInvoiceNumber = Helper.ConvertFromDB<string>( dr["IstaWaivedInvoiceNumber"] );
			retentionSavedAccount.ProcessedBy = Helper.ConvertFromDB<string>( dr["ProcessedBy"] );

			return retentionSavedAccount;
		}

		/// <summary>
		/// Adds the account to the ETF invoice queue
		/// </summary>
		public static void AddToQueue( int accountID, int etfID, int etfInvoiceID )
		{
			RetentionSavedAccount retentionSavedAccount = new RetentionSavedAccount();
			retentionSavedAccount.AccountID = accountID;
			retentionSavedAccount.EtfID = etfID;
			retentionSavedAccount.EtfInvoiceID = etfInvoiceID;
			retentionSavedAccount.Status = RetentionSavedAccountStatus.Pending;
			retentionSavedAccount.DateInserted = DateTime.Now;
			Save( retentionSavedAccount );
		}

		public static void Save( RetentionSavedAccount retentionSavedAccount )
		{
			if ( retentionSavedAccount.SavedAccountsQueueID.HasValue )
			{
				// Update
				RetentionSavedAccountsQueueSql.UpdateRetentionSavedAccountsQueue( Convert.ToInt32( retentionSavedAccount.SavedAccountsQueueID ), retentionSavedAccount.AccountID, retentionSavedAccount.EtfID, retentionSavedAccount.EtfInvoiceID, (int) retentionSavedAccount.Status, Convert.ToDateTime( retentionSavedAccount.DateProcessed ), retentionSavedAccount.ProcessedBy,retentionSavedAccount.IstaWaivedInvoiceNumber, retentionSavedAccount.DateInserted );
			}
			else
			{
				// Insert
				RetentionSavedAccountsQueueSql.InsertRetentionSavedAccountsQueue( retentionSavedAccount.AccountID, retentionSavedAccount.EtfID, retentionSavedAccount.EtfInvoiceID, (int) retentionSavedAccount.Status, retentionSavedAccount.DateInserted );
			}
		}

		public static void Waive( RetentionSavedAccount retentionSavedAccount, string userName )
		{

			throw new Exception( "Due to technical problems with ISTA this feature is currently unavailable." );

			//EtfInvoice etfInvoice = retentionSavedAccount.EtfInvoice;
			//decimal negativeAmount = (-1) * Convert.ToDecimal( etfInvoice.Etf.EtfCalculator.DisplayEtfAmount );
			//string istaInvoiceNumner = EdiInvoiceFactory.SubmitEtfInvoice( retentionSavedAccount.CompanyAccount.AccountNumber, negativeAmount, etfInvoice.IsPaid );

			//using ( TransactionScope scope = new TransactionScope( TransactionScopeOption.RequiresNew ) )
			//{
			//    retentionSavedAccount.IstaWaivedInvoiceNumber = istaInvoiceNumner;
			//    retentionSavedAccount.DateProcessed = DateTime.Now;
			//    retentionSavedAccount.ProcessedBy = userName;
			//    retentionSavedAccount.Status = RetentionSavedAccountStatus.Waived;

			//    decimal etfAmount = Convert.ToDecimal( retentionSavedAccount.EtfInvoice.Etf.EtfCalculator.DisplayEtfAmount );

			//    CompanyAccountFactory.InsertComment( retentionSavedAccount.CompanyAccount.LegacyAccountId, "WAIVE ETF", "ETF charge of $" + etfAmount + " was waived on " + retentionSavedAccount.DateProcessed.Value.ToShortDateString() + " by " + userName + ".", userName );

			//    RetentionSavedAccountFactory.Save( retentionSavedAccount );
			//    scope.Complete();
			//}
		}

		public static RetentionSavedAccountList GetList( string accountNumber, string customerName, string istaInvoiceNumber, int invoiceStatus, DateTime? processedStartDate, DateTime? processedEndDate, DateTime? insertedStart, DateTime? insertedEnd, int? aging )
		{

			DataSet ds = RetentionSavedAccountsQueueSql.GetList( accountNumber, customerName, istaInvoiceNumber, invoiceStatus, processedStartDate, processedEndDate, insertedStart, insertedEnd, aging );

			if ( ds == null || ds.Tables.Count == 0 )
			{
				throw new Exception( "Could not retrieve Retention Saved Accounts Data." );
			}


			RetentionSavedAccountList retentionSavedAccountList = new RetentionSavedAccountList();

			foreach ( DataRow dr in ds.Tables[0].Rows )
			{
				RetentionSavedAccount retentionSavedAccount = BuildRetentionSavedAccountObject( dr );
				retentionSavedAccountList.Add( retentionSavedAccount );
			}

			return retentionSavedAccountList;
		}

	}
}
