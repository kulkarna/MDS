using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.DataAccess.WebServiceAccess.DocumentWebService;
using LibertyPower.DataAccess.WebServiceAccess.DocumentWebService.DocumentRepository;
using LibertyPower.DataAccess.SqlAccess.AccountSql;

namespace LibertyPower.Business.CustomerManagement.LetterQueue
{
	public static class LetterQueueFactory
	{
		public static LetterQueue GetLetterQueueByAccoun_Id( int DocumentTypeId, string Account_id)
		{
			LetterQueue letterQueue = new LetterQueue();

			DataSet ds = LetterQueueSql.GetLetterQueueByAccount_Id( DocumentTypeId, Account_id );
			if( ds == null || ds.Tables.Count == 0 )
			{
				throw new Exception( "Could not retrieve Letter Queue data." );
			}
			
			if( ds.Tables[0].Rows.Count != 0 )
			{
				letterQueue = BuildLetterQueueObject( ds.Tables[0].Rows[0] );
			}	
			return letterQueue;
		}

		public static LetterQueueList GetLetterQueueList( int DocumentTypeId, string LetterStatus, string OrderBy, string SortAscending, string ContractNumber )
		{

			DataSet ds = LetterQueueSql.GetLetterQueue( DocumentTypeId, LetterStatus, OrderBy, SortAscending, ContractNumber );
			if( ds == null || ds.Tables.Count == 0 )
			{
				throw new Exception( "Could not retrieve Letter Queue data." );
			}

			LetterQueueList letterQueueList = new LetterQueueList();

			foreach( DataRow dr in ds.Tables[0].Rows )
			{
				LetterQueue letterQueue = BuildLetterQueueObject( dr );
				letterQueueList.Add( letterQueue );
			}
			return letterQueueList;
		}

		public static DataSet GetLetterQueueScheludedList( int DocumentTypeId)
		{

			DataSet letterQueueList = LetterQueueSql.GetLetterQueue( DocumentTypeId, "Scheduled", "", "", "" );
			if( letterQueueList == null || letterQueueList.Tables.Count == 0 )
			{
				throw new Exception( "Could not retrieve Letter Queue data." );
			}			
			return letterQueueList;
		}

		public static DataSet UpdateLetterQueue( LetterQueue letterQueue )
		{
			DataSet ds = new DataSet();

			try
			{
				ds = LetterQueueSql.UpdateLetterQueue( Convert.ToInt32( letterQueue.LetterQueueID ), letterQueue.LetterQueueStatus, letterQueue.ScheduledDate.ToString(), letterQueue.PrintDate.ToString(), letterQueue.UserName );
			}
			catch( Exception ex )
			{

				throw ex;
			}
			return ds;

		}

		public static DataSet InsertLetterQueue( LetterQueue letterQueue )
		{

			DataSet ds = new DataSet();

			try
			{
				ds = LetterQueueSql.InsertLetterQueue( letterQueue.LetterQueueStatus, letterQueue.ContractNumber, letterQueue.AccountID, letterQueue.DocumentTypeID, letterQueue.ScheduledDate.ToString(), letterQueue.UserName );
			}
			catch( Exception ex )
			{

				throw ex;
			}

			return ds;

		}

		public static void DeleteLetterQueue( int letterQueueId )
		{
			try
			{
				LetterQueueSql.DeleteLetterQueue( letterQueueId );
			}
			catch( Exception ex )
			{

				throw ex;
			}

		}

		private static LetterQueue BuildLetterQueueObject( DataRow dr )
		{
			LetterQueue letterQueue = new LetterQueue();
			letterQueue.LetterQueueID = Helper.ConvertFromDB<int>( dr["LetterQueueID"] );
			letterQueue.LetterQueueStatus = Helper.ConvertFromDB<string>( dr["Status"] );
			letterQueue.ContractNumber = Helper.ConvertFromDB<string>( dr["ContractNumber"] );
			letterQueue.AccountID = Helper.ConvertFromDB<int>( dr["AccountID"] );
			letterQueue.DocumentTypeID = Helper.ConvertFromDB<int>( dr["DocumentTypeId"] );
			letterQueue.DateCreated = Helper.ConvertFromDB<DateTime>( dr["DateCreated"] );
			letterQueue.ScheduledDate = Helper.ConvertFromDB<DateTime>( dr["ScheduledDate"] );
			letterQueue.PrintDate = Helper.ConvertFromDB<DateTime>( dr["PrintDate"] );
			letterQueue.UserName = Helper.ConvertFromDB<string>( dr["UserName"] );
			letterQueue.CustomerName = Helper.ConvertFromDB<string>( dr["CustomerName"] );
			letterQueue.AccountNumber = Helper.ConvertFromDB<string>( dr["AccountNumber"] );
			letterQueue.DocumentTypeName = Helper.ConvertFromDB<string>( dr["document_type_name"] );
			letterQueue.Account_ID = Helper.ConvertFromDB<string>( dr["account_id"] );

			return letterQueue;
		}

        public static Result PrintLetterQueue(LetterQueue letterQueue, string userName)
		{
			
			List<string> accountNumberList = new List<string>();
			accountNumberList.Add( letterQueue.AccountNumber );

			Result result = DocumentService.GenerateDocumentByTypeAlt2Bytes( letterQueue.DocumentTypeID, letterQueue.ContractNumber, accountNumberList, true, true, userName, String.Empty );

			return result;
		}

		public static DataSet GetPendingLetterQueuDocumentTypeId( )
		{

			DataSet DoucmentTypeList = LetterQueueSql.GetPendingLetterQueueDocumentTypeId( );
			if( DoucmentTypeList == null || DoucmentTypeList.Tables.Count == 0 )
			{
				throw new Exception( "Could not retrieve Letter Queue data." );
			}
			return DoucmentTypeList;
		}

		/// <summary>
		/// Inserts a comment when a letter is generated.
		/// </summary>
		/// <param name="letterQueue">Letter queue object - with at least the properties AccountID and DocumentTypeName.</param>
		/// <param name="userName">userName of current user.</param>
		public static void InsertLetterQueueComment( LetterQueue letterQueue, string userName )
		{
			string comment;
			//PBI: 76845 Document Manager - FORM 1 - Update Notes in customer Account
			//June 30 2015- CTPURA
			switch( letterQueue.DocumentTypeName )
			{
				case "CP1_ConnecticutPuraForms1":
					{
						comment = "CT PURA Form 1 Quarterly Notice sent - " + String.Format( "{0:MMMM d, yyyy}", letterQueue.PrintDate );						
					}
					break;
				case "CP2_ConnecticutPuraForms2":
					{
						comment = "CT PURA Form 2 Notice sent - " + String.Format( "{0:MMMM d, yyyy}", letterQueue.PrintDate );
					}
					break;
				case "CP3_ConnecticutPuraForms3":
					{
						comment = "CT PURA Form 3 Notice sent - " + String.Format( "{0:MMMM d, yyyy}", letterQueue.PrintDate );
					}
					break;
                case "CP4_ConnecticutPuraForms4":
                    {
                        comment = "CT PURA Form 4 Notice sent - " + String.Format("{0:MMMM d, yyyy}", letterQueue.PrintDate);
                    }
                    break;
				default:
					comment = "Printed letter - '" + letterQueue.DocumentTypeName + "'.";
					break;
			}
			
			AccountSql.InsertComment(letterQueue.Account_ID, "LETTER", comment, userName);
			
		}
	}
}
