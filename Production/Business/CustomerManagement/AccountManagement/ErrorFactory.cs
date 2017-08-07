using System;
using System.Configuration;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class ErrorFactory
	{
		public static void LogError( string accountId, string errorLocation, string errorMessage, DateTime errorDate )
		{
			LogError(accountId, errorLocation, errorMessage, errorDate, true);
		}
		public static void LogError(string accountId, string errorLocation, string errorMessage, DateTime errorDate, bool sendEmail)
		{
			GrossMarginSql.LogError(accountId, errorLocation, errorMessage, errorDate);

			// email notification not needed - 10/31/2011 Rick Deigsler
			//if( sendEmail )
			//{
			//    string emailFrom = Properties.Settings.Default.EmailFrom;
			//    string emailTo = Properties.Settings.Default.EmailTo;
			//    string subject = Properties.Settings.Default.ErrorSubject;
			//    string body = "Error has occurred:<br><br>Date: {0}<br><br>Account ID: {1}<br><br>Location: {2}<br><br>Message: {3}";

			//    Email email = new Email();
			//    email.Send( emailFrom, "", emailTo, "", subject,
			//        String.Format( body, errorDate, accountId, errorLocation, errorMessage ),
			//        null, null, null );
			//}

		}

	
		
		
		
		//public static void LogError( string accountId, string errorLocation, string errorMessage, DateTime errorDate, bool sendEmail )
		//{

		//    if (sendEmail)
		//    {
		//        LogError(accountId, errorLocation, errorMessage, errorDate);
		//        return;
		//    }

		//    GrossMarginSql.LogError(accountId, errorLocation, errorMessage, errorDate);
		//}
	
	
	}
}
