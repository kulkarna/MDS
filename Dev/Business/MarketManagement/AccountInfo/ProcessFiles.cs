using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Text;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	public static class ProcessFiles
	{
		/// <summary>
		/// Run the reports: make a webservice call to ERCOT, get the list of reports to download, 
		/// download the reports, unzip them then parse them
		/// </summary>
		/// <param name="message">error message</param>
		/// <returns>false in case of an error</returns>
		public static bool Run( out string message )
		{
			string messageR = string.Empty;
			string messageS = string.Empty;
			AccountInfoFacotry.Errors.Clear();

			bool bRun = RunReport( "203", ConfigurationManager.AppSettings["REPORTS"].ToString(),
				ConfigurationManager.AppSettings["ZIP_PATH"].ToString(),
				ConfigurationManager.AppSettings["UNZIP_PATH"].ToString(),
				ConfigurationManager.AppSettings["ZIP_EXT"].ToString(),
				ConfigurationManager.AppSettings["UNZIP_EXT"].ToString(),
				ConfigurationManager.AppSettings["CERT_COMMON_NAME"].ToString(),
				ConfigurationManager.AppSettings["CERT_USER_ID"].ToString(),
				ConfigurationManager.AppSettings["WEBSERVICE_URL"].ToString(),
				new ParserReport(),
				out messageR );


			bRun = RunReport( "10008", ConfigurationManager.AppSettings["SETTLEMENT"].ToString(),
				ConfigurationManager.AppSettings["ZIP_PATH_SET"].ToString(),
				ConfigurationManager.AppSettings["UNZIP_PATH_SET"].ToString(),
				ConfigurationManager.AppSettings["ZIP_EXT"].ToString(),
				ConfigurationManager.AppSettings["UNZIP_EXT_SET"].ToString(),
				ConfigurationManager.AppSettings["CERT_COMMON_NAME"].ToString(),
				ConfigurationManager.AppSettings["CERT_USER_ID"].ToString(),
				ConfigurationManager.AppSettings["WEBSERVICE_URL"].ToString(),
				new ParserSettlement(),
				out messageS );

			message = messageR + "\r\n" + messageS;

			SendNotification( message );

			return bRun;
		}

		private static bool RunReport( string reportID, string reportListPath,
			string zipPath, string unZipPath, string zipEXT, string unZipEXT,
			string certCommonName, string certUserID, string webServiceURL,
			Parser parser,
			out string message )
		{
			message = string.Empty;
			bool bRun = false;

			RunService.FilePath = reportListPath;
			bool getList = bool.Parse( ConfigurationManager.AppSettings["GetList"].ToString() );

			if( getList )
			{
				bRun = RunService.GetReport( reportID, certCommonName, certUserID, webServiceURL, out message );
				if( !bRun )
					return false;
			}

			Downloader dwn = new Downloader( reportListPath );
			dwn.ToPath = zipPath;
			dwn.UnzipPath = unZipPath;

			bool downloadFiles = bool.Parse( ConfigurationManager.AppSettings["Download"].ToString() );
			if( downloadFiles )
			{
				bRun = dwn.DownloadFiles( certCommonName, out message );
				if( !bRun )
				{
					message = "Error downloading files: " + message;
					return false;
				}
			}
			dwn.UnzipFiles( zipEXT );

			//Parser paser = new ParserReport();
			parser.UnzipPath = unZipPath;
			parser.UnzipExt = unZipEXT;
			bRun = parser.ParseFiles( dwn.FileLogs, out message );

			return bRun;
		}


		private static void SendNotification( string message)
		{
			string smtpServer = ConfigurationManager.AppSettings["SMTPServer"].ToString();
			string to = ConfigurationManager.AppSettings["SMTPTo"].ToString();
			string from = ConfigurationManager.AppSettings["SMTPFrom"].ToString();
			string subject = ConfigurationManager.AppSettings["SMTPSubject"].ToString();
			StringBuilder body = new StringBuilder();
			body.Append( message + "\r\n" );
			body.Append( "\r\n" );
			if( AccountInfoFacotry.Errors.Count > 0 )
			{
				body.Append( "Process finished running with the following errors:\r\n" );
				foreach( string s in AccountInfoFactory.Errors )
					body.Append( s + "\r\n" );
			}
			else
				body.Append( "Process finished running without any errors." );

			if( smtpServer.ToLower().Trim() == "disable" )
				return;

			//TODO: Consider using another technique to avoid doing this inefficient loop so we can have the email server handle the distribution of multiple emails.
			string[] emails = to.Split( ';' );
			foreach( string email in emails )
			{
				MailMessage mail = new MailMessage( from, email );
				mail.Subject = subject;
				mail.Body = body.ToString();
				mail.IsBodyHtml = false;
				mail.BodyEncoding = System.Text.Encoding.UTF8;
				SmtpClient client = new SmtpClient( smtpServer );
				client.Send( mail );
			}
		}
	}
}
