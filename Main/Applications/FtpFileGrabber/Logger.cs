using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace Libertypower.FtpFileGrabber
{
	public static class Logger
	{
		private static string fileDate = DateTime.Today.Year.ToString() + DateTime.Today.Month.ToString().PadLeft(2, Convert.ToChar("0"));
		private static string logFile = ConfigurationManager.AppSettings["LogFile"] + fileDate + ".log";
		private static string errorFile = ConfigurationManager.AppSettings["ErrorFile"] + ".log";
		private static string logDirectory = ConfigurationManager.AppSettings["LogDirectory"];
		private static string date = DateTime.Now.ToString();
		private static string spaces = "    ";

		public static void LogError( string error )
		{
			string file = Path.Combine( logDirectory, errorFile );

			error = Environment.NewLine + date + Environment.NewLine + spaces + error;

			using( StreamWriter sw = File.AppendText( file ) )
				sw.WriteLine( error );
		}

		public static void LogFileTransfer( string file )
		{
			file = date + " - " + file;
			logFile = Path.Combine( logDirectory, logFile );

			using( StreamWriter sw = File.AppendText( logFile ) )
				sw.WriteLine( file );
		}

	}
}
