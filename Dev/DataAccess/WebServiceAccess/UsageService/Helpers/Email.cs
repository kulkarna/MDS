namespace UsageService
{
	using System.Net.Mail;
	using System;

	public static class Email
	{
		public static void Send( string from, string fromName, string to, string toName,
			string subject, string body, string cc, string bcc, string bcc2, string smtpServer )
		{
			SmtpClient smtpClient = new SmtpClient();
			MailMessage message = new MailMessage();

			try
			{
				MailAddress fromAddress = new MailAddress( from, fromName );

				smtpClient.Host = smtpServer;
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
				string err = "Send Email Failed." + ex.Message;
			}
		}
	}
}