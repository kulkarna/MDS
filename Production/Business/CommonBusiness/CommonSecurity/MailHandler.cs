namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Net.Mail;
    using System.Text;
	using System.IO;

    /// <summary>
    /// Mail Handler for SecurityManager.
    /// </summary>
    public class MailHandler
    {
        #region Methods

		/// <summary>
		/// Sends the mail message.
		/// </summary>
		/// <param name="message">The message.</param>
		public static void SendMailMessage( MailMessage message )
		{
			bool canSendEmails = (ConfigurationManager.AppSettings["SendEmails"].ToString() == "true");
			message.IsBodyHtml = true;
			if( canSendEmails )
			{
				SmtpClient smtpClient = new SmtpClient();
				smtpClient.Host = ConfigurationManager.AppSettings["SMTPServer"];
				smtpClient.Port = 25;

				smtpClient.Send( message );
			}
			else
			{
				SmtpClient client = new SmtpClient(  );
				client.DeliveryMethod = SmtpDeliveryMethod.SpecifiedPickupDirectory;
				client.PickupDirectoryLocation = ConfigurationManager.AppSettings["SaveEmailLocation"];
				client.Send( message );
			}


		}

        #endregion Methods
    }
}