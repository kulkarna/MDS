namespace LibertyPower.Business.MarketManagement.EdiParser.ParserTrigger
{
	using System;
	using System.Configuration;
	using FileParser;

	class Program
	{
		static void Main( string[] args )
		{
			string exeFullPath = System.Reflection.Assembly.GetExecutingAssembly().Location;
			string exeFileName = System.IO.Path.GetFileName( exeFullPath );
			string logFileName = exeFullPath.Replace( exeFileName, "" ) + "log.txt";

			Console.WriteLine( "***********************************" );
			Console.WriteLine( "***********************************" );
			Console.WriteLine( "" );
			Console.WriteLine( "WELCOME TO FILE PARSING VERSION 2.1 !" );
			Console.WriteLine( "" );
			Console.WriteLine( "***********************************" );
			Console.WriteLine( "***********************************" );
			Console.WriteLine( "" );
			Console.Write( "Enter directory path: " );
			string directoryPath = Console.ReadLine();

			if( directoryPath.Length.Equals( 0 ) )
				directoryPath = ConfigurationManager.AppSettings["TestFilesRoot"];

			try
			{
				Console.WriteLine( "" );
				Console.WriteLine( "***********************************" );
				Console.WriteLine( "" );
				Console.WriteLine( "Parsing process started..." );
				Console.WriteLine( "" );
				Console.WriteLine( "***********************************" );

				FileController.ProcessFiles( directoryPath );

				Console.WriteLine( "" );
				Console.WriteLine( "***********************************" );
				Console.WriteLine( "" );
				Console.WriteLine( "Parsing process finished." );
				Console.WriteLine( "" );
				Console.WriteLine( "***********************************" );
				Console.WriteLine( "" );
			}
			catch( Exception ex )
			{
				Console.WriteLine( "" );
				Console.WriteLine( "***********************************" );
				Console.WriteLine( "***********************************" );
				Console.WriteLine( "" );
				Console.WriteLine( "An error occurred during file parsing. See stack trace below." );
				Console.WriteLine( "" );
				Console.WriteLine( "***********************************" );
				Console.WriteLine( "***********************************" );
				Console.WriteLine( "" );
				Console.WriteLine( ex.ToString() );
				Console.WriteLine( "" );
				string content = string.Format( "{0} - An error occurred during file parsing. See stack trace below.", ex.Message );
				LogResults( logFileName, content );

				Console.ReadLine();
			}
		}

		private static void LogResults( string fileName, string content )
		{
			Logger.WriteLogFile( fileName, String.Format( content, DateTime.Now.ToString() ) );
		}
	}
}

