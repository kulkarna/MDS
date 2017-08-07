using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
//using LibertyPower.Business.CommonBusiness.FileManager;
//using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.MarketManagement.EdiParser.Logger
{
	public static class Logger
	{
		//// log file related information
		//public static void LogFileInfo( int ediFileLogID, string fileGuid, int attempts, string info, bool isProcessed )
		//{
		//    int success = Convert.ToInt16( isProcessed );
		//    EdiSql.InsertEdiFileLog( ediFileLogID, fileGuid, attempts, info, success );
		//}

		//// log process related information
		//public static void LogProcessInfo( int ediProcessLogID, int ediFileLogID, string info, bool isProcessed )
		//{
		//    int success = Convert.ToInt16( isProcessed );
		//    EdiSql.InsertEdiProcessLog( ediProcessLogID, ediFileLogID, info, success );
		//}

		//// log account related information
		//public static void LogAccountInfo( int ediProcessLogID, string accountNumber, string dunsNumber, string info )
		//{
		//    EdiSql.InsertEdiAccountLog( ediProcessLogID, accountNumber, dunsNumber, info );
		//}

		// writes to a log file
		public static void WriteLogFile( string fileName, string content )
		{
			int index = fileName.IndexOf( "." );
			int length = fileName.Length - index;
			string extension = fileName.Substring( index, length );
			fileName = fileName.Replace( extension, ".log" );

			using( StreamWriter writer = new StreamWriter( fileName ) )
			{
				writer.Write( content );
			}
		}
	}
}
