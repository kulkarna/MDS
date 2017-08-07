using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Services;
using LibertyPower.Business.CustomerManagement.AccountManagement;

namespace UsageService
{
	/// <summary>
	/// Summary description for UsageService
	/// </summary>
	[WebService( Namespace = "UsageWebServices" )]
	[WebServiceBinding( ConformsTo = WsiProfiles.BasicProfile1_1 )]
	[System.ComponentModel.ToolboxItem( false )]
	// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
	// [System.Web.Script.Services.ScriptService]
	public class UsageService : System.Web.Services.WebService
	{
		string format = "<div style=font-family:Verdana,Arial;font-size:10pt>{0}<br><br>{1}</div>";
		string from = ConfigurationManager.AppSettings["emailFrom"];
		string to = ConfigurationManager.AppSettings["emailTo"];
		string subject = ConfigurationManager.AppSettings["emailSubject"];
		string smtpServer = ConfigurationManager.AppSettings["smtpServer"];

		[WebMethod]
		public bool UpdateConsolidatedTable( string account, string utility )
		{
			bool val = false;

			utility = utility.Replace( '~', '&' );

			try
			{
				string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
				userName = (string) userName.Split( '\\' ).GetValue( 1 );

				val = CompanyAccountFactory.ConsolidateUsage( account, utility.Trim(), userName );
			}
			catch( Exception ex )
			{
				Email.Send( from, "", to, "", subject, String.Format( format, DateTime.Now.ToString(), ex.Message ), null, null, null, smtpServer );
			}

			return val;
		}
	}
}