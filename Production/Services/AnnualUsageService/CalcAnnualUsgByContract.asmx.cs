using System;
using System.Configuration;
using System.Web.Services;
using LibertyPower.Business.CustomerManagement.AccountManagement;

namespace AnnualUsageService
{
	/// <summary>
	/// Summary description for CalcAnnualUsgByContract
	/// </summary>
	[WebService( Namespace = "http://tempuri.org/" )]
	[WebServiceBinding( ConformsTo = WsiProfiles.BasicProfile1_1 )]
	[System.ComponentModel.ToolboxItem( false )]
	// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
	// [System.Web.Script.Services.ScriptService]
	public class CalcAnnualUsgByContract : System.Web.Services.WebService
	{

		string format = "<div style=font-family:Verdana,Arial;font-size:10pt>{0}<br><br>{1}</div>";
		string from = ConfigurationManager.AppSettings["emailFrom"];
		string to = ConfigurationManager.AppSettings["emailTo"];
		string subject = ConfigurationManager.AppSettings["emailSubject"];
		string smtpServer = ConfigurationManager.AppSettings["smtpServer"];

		[WebMethod]
		public bool CalculateUsage( string contract_number, string processId, Int16 renewal )
		{
			bool val = false;
			bool isRenewal;
			switch( renewal ) { case 1: isRenewal = true; break; default: isRenewal = false; break; }

			try
			{
				string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
				userName = (string) userName.Split( '\\' ).GetValue( 1 );

				val = CompanyAccountFactory.CalculateAnnualUsage( contract_number, userName, processId, isRenewal );
			}
			catch( Exception ex )
			{
				Email.Send( from, "", to, "", subject, String.Format( format, DateTime.Now.ToString(), ex.Message ), null, null, null, smtpServer );
			}

			return val;
		}
	}
}
