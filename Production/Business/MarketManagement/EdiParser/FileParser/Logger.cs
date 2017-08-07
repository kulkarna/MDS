namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Data;
	using System.Text;
	using System.IO;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using LibertyPower.Business.CommonBusiness.FileManager;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	/// <summary>
	/// Class responsible for inserting log object data into database
	/// </summary>
	public static class Logger
	{
		/// <summary>
		/// Logs edi file log information
		/// </summary>
		/// <param name="ediFileLogID">Edi file log record identifier</param>
		/// <param name="fileGuid">File identifier in managed storage</param>
		/// <param name="fileName">File name</param>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="attempts">Processing attempts</param>
		/// <param name="info">Log information</param>
		/// <param name="isProcessed">Boolean indicating if successfully processed</param>
		/// <param name="fileType">Enumerated file type</param>
		/// <returns>Returns an edi file log object with record ID and time stamp</returns>
		public static EdiFileLog LogFileInfo( int ediFileLogID, string fileGuid,
			string fileName, string utilityCode, int attempts, string info, bool isProcessed, int fileType )
		{
			EdiFileLog log;
			int success = Convert.ToInt16( isProcessed );

			DataSet ds = TransactionsSql.InsertEdiFileLog( ediFileLogID, fileGuid, fileName, utilityCode,
				attempts, info, success, fileType );

			if( DataSetHelper.HasRow( ds ) )
				log = FileFactory.CreateEdiFileLog( ds.Tables[0].Rows[0] );
			else
			{
				string format = "Edi file log insert failed for file guid {0}.";
				throw new LogInsertException( String.Format( format, fileGuid ) );
			}
			return log;
		}

		/// <summary>
		/// Logs edi file log information taking edi file log object as parameter
		/// </summary>
		/// <param name="log">edi file log object</param>
		/// <returns>Returns an edi file log object with record ID and time stamp</returns>
		public static EdiFileLog LogFileInfo( EdiFileLog log )
		{
			int ediFileLogID = log.ID;
			string fileGuid = log.FileGuid;
			string fileName = log.FileName;
			string utilityCode = log.UtilityCode;
			int attempts = log.Attempts;
			string info;
			switch( utilityCode )
			{
				case "BGE":
//				case "CENHUD":	// cenhud files don't have <CR> - 10/17/2011 - FCT :-x
//				case "CONED":
					info = "Parser turned off for " + utilityCode + " since it is scrapable.";
					break;
				default:
					info = log.Information;
					break;
			}
			bool isProcessed = log.IsProcessed;
			int success = Convert.ToInt16( isProcessed );
			int fileType = Convert.ToInt16( log.EdiFileType );

			DataSet ds = TransactionsSql.InsertEdiFileLog( ediFileLogID, fileGuid, fileName, utilityCode,
				attempts, info, success, fileType );

			if( DataSetHelper.HasRow( ds ) )
				log = FileFactory.CreateEdiFileLog( ds.Tables[0].Rows[0] );
			else
			{
				string format = "Edi file log insert failed for file guid {0}.";
				throw new LogInsertException( String.Format( format, fileGuid ) );
			}
			return log;
		}

		/// <summary>
		/// Logs edi process log information 
		/// </summary>
		/// <param name="ediProcessLogID">Edi process log record ID</param>
		/// <param name="ediFileLogID">Edi file log record ID</param>
		/// <param name="info">Log information</param>
		/// <param name="isProcessed">Boolean indicating if successfully processed</param>
		/// <returns>Returns an edi process log object with record ID and time stamp</returns>
		public static EdiProcessLog LogProcessInfo( int ediProcessLogID, int ediFileLogID, string info, bool isProcessed )
		{
			EdiProcessLog log;
			int success = Convert.ToInt16( isProcessed );

			DataSet ds = TransactionsSql.InsertEdiProcessLog( ediProcessLogID, ediFileLogID, info, success );

			if( DataSetHelper.HasRow( ds ) )
			{
				int id = Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] );
				ediFileLogID = Convert.ToInt32( ds.Tables[0].Rows[0]["EdiFileLogID"] );
				info = ds.Tables[0].Rows[0]["Information"].ToString();
				isProcessed = Convert.ToBoolean( ds.Tables[0].Rows[0]["IsProcessed"] );
				DateTime timeStampInsert = Convert.ToDateTime( ds.Tables[0].Rows[0]["TimeStampInsert"] );
				DateTime timeStampUpdate = Convert.ToDateTime( ds.Tables[0].Rows[0]["TimeStampUpdate"] );

				log = new EdiProcessLog( id, ediFileLogID, info, isProcessed, timeStampInsert, timeStampUpdate );
			}
			else
			{
				string format = "Edi process log insert failed for file log ID {0}.";
				throw new LogInsertException( String.Format( format, ediFileLogID.ToString() ) );
			}
			return log;
		}

		/// <summary>
		/// Logs edi account log information
		/// </summary>
		/// <param name="ediProcessLogID">Edi process log record ID</param>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="dunsNumber">DUNS number</param>
		/// <param name="info">Log information</param>
		/// <param name="severity">Severity level of exception</param>
		/// <returns>Returns an edi account log object with record ID and time stamp</returns>
		public static EdiAccountLog LogAccountInfo( int ediProcessLogID, string accountNumber,
			string dunsNumber, string info, BrokenRuleSeverity severity )
		{
			EdiAccountLog log;
			DateTime timeStamp;
			int severityLevel = severity.Equals( BrokenRuleSeverity.Error ) ? 0 : 1;

			DataSet ds = TransactionsSql.InsertEdiAccountLog( ediProcessLogID, accountNumber, dunsNumber, info, severityLevel );

			if( DataSetHelper.HasRow( ds ) )
			{
				int id = Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] );
				ediProcessLogID = Convert.ToInt32( ds.Tables[0].Rows[0]["EdiProcessLogID"] );
				accountNumber = ds.Tables[0].Rows[0]["AccountNumber"].ToString();
				dunsNumber = ds.Tables[0].Rows[0]["DunsNumber"].ToString();
				info = ds.Tables[0].Rows[0]["Information"].ToString();
				timeStamp = Convert.ToDateTime( ds.Tables[0].Rows[0]["Timestamp"] );

				log = new EdiAccountLog( id, ediProcessLogID, accountNumber, dunsNumber, info, severity, timeStamp );
			}
			else
			{
				string format = "Edi account log insert failed for process log ID {0}.";
				throw new LogInsertException( String.Format( format, ediProcessLogID.ToString() ) );
			}
			return log;
		}

		/// <summary>
		/// Writes to a log file
		/// </summary>
		/// <param name="file">File name with full path</param>
		/// <param name="content">File content</param>
		public static void WriteLogFile( string file, string content )
		{
			using( StreamWriter writer = new StreamWriter( file ) )
			{
				writer.Write( content );
			}
		}
	}
}
