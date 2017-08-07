using System;
using System.Configuration;
using System.Collections.Generic;
using System.Text;
using System.Net.Mail;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class Email
	{
		public void Send( string from, string fromName,
			string to, string toName, string subject,
			string body, string cc, string bcc, string bcc2 )
		{
            if (Helper.EmailEnabled == false)
                return;

            SmtpClient smtpClient = new SmtpClient();
			MailMessage message = new MailMessage();

			try
			{
				MailAddress fromAddress = new MailAddress( from, fromName );

				smtpClient.Host = Properties.Settings.Default.SMTPServer;
				smtpClient.Port = 25;

				message.From = fromAddress;
				message.To.Add( to );
				message.Subject = subject;

				if( cc != null )
					message.CC.Add( cc );

				if( bcc != null )
					message.Bcc.Add( new MailAddress( bcc ) );
				if( bcc2 != null )
					message.Bcc.Add( new MailAddress( bcc2 ) );

				message.IsBodyHtml = true;
				message.Body = body;

				smtpClient.Send( message );
			}
			catch( Exception ex )
			{
				ErrorFactory.LogError( "", "AccountManagement.Email.Send()", ex.Message, DateTime.Now, false );
			}
		}
	}
}
