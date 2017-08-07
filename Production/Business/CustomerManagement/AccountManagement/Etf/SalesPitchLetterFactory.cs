using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.DataAccess.WebServiceAccess.DocumentWebService;
using LibertyPower.DataAccess.WebServiceAccess.DocumentWebService.DocumentRepository;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class SalesPitchLetterFactory
	{
		public const string TerminationLetterDocumentType = "TNL";

		public static SalesPitchLetter GetSalesPitchLetter( int salesPitchLetterID )
		{
			DataSet ds = AccountSalesPitchLetterQueueSql.Get( salesPitchLetterID );

			if ( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				throw new Exception( "Could not retrieve Sales Pitch Letter information" );
			}

			DataRow dr = ds.Tables[0].Rows[0];
			SalesPitchLetter salesPitchLetter = BuildSalesPitchLetterObject( dr );
			return salesPitchLetter;
		}


		private static SalesPitchLetter BuildSalesPitchLetterObject( DataRow dr )
		{
			int salesPitchLetterID = Helper.ConvertFromDB<int>( dr["SalesPitchLetterID"] );
			SalesPitchLetter salesPitchLetter = new SalesPitchLetter( salesPitchLetterID );
			salesPitchLetter.AccountID = Helper.ConvertFromDB<int>( dr["AccountID"] );
			salesPitchLetter.EtfID = Helper.ConvertFromDB<int>( dr["EtfID"] );
			salesPitchLetter.Status = (SalesPitchLetterStatus) Helper.ConvertFromDB<int>( dr["StatusID"] );
			salesPitchLetter.ScheduledDate = Helper.ConvertFromDB<DateTime>( dr["DateScheduled"] );
			salesPitchLetter.ProcessedDate = Helper.ConvertFromDB<DateTime>( dr["DateProcessed"] );
			salesPitchLetter.DateInserted = Helper.ConvertFromDB<DateTime>( dr["DateInserted"] );

			return salesPitchLetter;
		}


		/// <summary>
		/// Creates a new SalesPitchLetter for the account provided.
		/// The scheduled processing day is set to 1 buisness day after it was created
		/// </summary>
		public static void QueueSalesPitchLetter( CompanyAccount companyAccount )
		{
			DateTime now = DateTime.Now;

			SalesPitchLetter salesPitchLetter = new SalesPitchLetter();
			salesPitchLetter.AccountID = companyAccount.Identity;
			salesPitchLetter.EtfID = Convert.ToInt32( companyAccount.Etf.EtfID );
			salesPitchLetter.Status = SalesPitchLetterStatus.Scheduled;
			//Documents are processed the FOLLOWING business day after they have been added to queue
			salesPitchLetter.ScheduledDate = new DateTime( now.Year, now.Month, now.Day ).AddDays( 1 );
			salesPitchLetter.DateInserted = now;
			Save( salesPitchLetter );

		}

		public static void Save( SalesPitchLetter salesPitchLetter )
		{
			if ( salesPitchLetter.SalesPitchLetterID.HasValue )
			{
				AccountSalesPitchLetterQueueSql.UpdateAccountSalesPitchLetterQueue( Convert.ToInt32( salesPitchLetter.SalesPitchLetterID ), salesPitchLetter.AccountID, salesPitchLetter.EtfID, (int) salesPitchLetter.Status, salesPitchLetter.ScheduledDate, Convert.ToDateTime( salesPitchLetter.ProcessedDate ), salesPitchLetter.DateInserted );
			}
			else
			{
				AccountSalesPitchLetterQueueSql.InsertAccountSalesPitchLetterQueue( salesPitchLetter.AccountID, Convert.ToInt32( salesPitchLetter.EtfID ), (int) salesPitchLetter.Status, salesPitchLetter.ScheduledDate, salesPitchLetter.DateInserted );
			}
		}


		public static void ProcessSalesPitchLetter( SalesPitchLetter salesPitchLetter, SalesPitchLetterAction salesPitchLetterAction )
		{
			EtfContext etfContext = null;

			CompanyAccount companyAccount = CompanyAccountFactory.GetCompanyAccount( salesPitchLetter.AccountID );

			etfContext = EtfContextFactory.Load( companyAccount );
            //if ( etfContext.CompanyAccount.Etf.EtfState != EtfState.PendingSalesPitchLetter )
            //{
            //    throw new Exception( "Sales Pitch letter can not be processed, incorrect status." );
            //}
			etfContext.SalesPitchLetter = salesPitchLetter;

			if ( salesPitchLetterAction == SalesPitchLetterAction.Cancel )
			{
				etfContext.EtfProcessingAction = EtfProcessingAction.CancelSalesPitchLetter;
			}
			else if ( salesPitchLetterAction == SalesPitchLetterAction.Process )
			{
				etfContext.EtfProcessingAction = EtfProcessingAction.ProcessSalesPitchLetter;
			}
			else if ( salesPitchLetterAction == SalesPitchLetterAction.ProcessManually )
			{
				etfContext.EtfProcessingAction = EtfProcessingAction.ProcessSalesPitchLetterManually;
			}

			//Process
			etfContext = EtfContextFactory.Process( etfContext );

			// Save ETF Invoice to database
			EtfContextFactory.Save( etfContext );
		}


		public static byte[] ProcessSalesPitchLetterManually( SalesPitchLetter salesPitchLetter, string userName )
		{
			int docTypeID = DocumentService.GetDocumentTypeIDByCode( TerminationLetterDocumentType );

			List<string> accountNumberList = new List<string>();
			accountNumberList.Add( salesPitchLetter.CompanyAccount.AccountNumber );

			Result result = null;
			try
			{
				result = DocumentService.GenerateDocumentByTypeAlt2Bytes( docTypeID, salesPitchLetter.CompanyAccount.ContractNumber, accountNumberList, true, true, userName, String.Empty );
				if ( !result.IsSuccessful )
				{
					throw new Exception( result.ExceptionString );
				}
			}
			catch ( Exception ex )
			{
				throw ex;
			}
			ProcessSalesPitchLetter( salesPitchLetter, SalesPitchLetterAction.ProcessManually );

			return (byte[]) result.Value;
		}


		public static SalesPitchLetterList GetAutomatedProcessingList()
		{

			DataSet ds = AccountSalesPitchLetterQueueSql.GetAutomatedProcessingList();
			if ( ds == null || ds.Tables.Count == 0 )
			{
				throw new Exception( "Could not retrieve Sales Pitch Letter Queue data." );
			}

			SalesPitchLetterList salesPitchLetterList = new SalesPitchLetterList();

			foreach ( DataRow dr in ds.Tables[0].Rows )
			{
				SalesPitchLetter salesPitchLetter = BuildSalesPitchLetterObject( dr );
				salesPitchLetterList.Add( salesPitchLetter );
			}
			return salesPitchLetterList;
		}


		public static SalesPitchLetterList GetPendingList()
		{

			DataSet ds = AccountSalesPitchLetterQueueSql.GetPendingList();
			if ( ds == null || ds.Tables.Count == 0 )
			{
				throw new Exception( "Could not retrieve Sales Pitch Letter Queue data." );
			}

			SalesPitchLetterList salesPitchLetterList = new SalesPitchLetterList();

			foreach ( DataRow dr in ds.Tables[0].Rows )
			{
				SalesPitchLetter salesPitchLetter = BuildSalesPitchLetterObject( dr );
				salesPitchLetterList.Add( salesPitchLetter );
			}
			return salesPitchLetterList;
		}


	}
}
