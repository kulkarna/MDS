using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.EdiManagement;
using LibertyPower.DataAccess.SqlAccess.AccountSql;


namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class RateChangeProcessor
	{
		static string format = "<div style=font-family:Verdana,Arial;font-size:10pt>{0}<br><br>{1}</div>";
		static string begin = "Process has begun.";
		static string end = "Process has ended";
		static string emailFrom = Properties.Settings.Default.EmailFrom;
		static string emailTo = Properties.Settings.Default.EmailTo;
		static string subject = "";
		static string smtpServer = Properties.Settings.Default.SMTPServer;

		public static void ProcessRateChanges()
		{
			subject = "Rate Change Event";
			Email email = new Email();

			// send email notification of process begin
			email.Send( emailFrom, "", emailTo, "", subject, String.Format( format, DateTime.Now.ToString(), begin ),
				null, null, null );

			DataSet ds = AccountSql.GetAccountsWithRateChange();

			foreach( DataRow dr in ds.Tables[0].Rows )
				AccountEventProcessor.ProcessEvent( AccountEventType.RateChange, dr["AccountNumber"].ToString(), dr["UtilityCode"].ToString() );

			// send email notification of process end
			email.Send( emailFrom, "", emailTo, "", subject, String.Format( format, DateTime.Now.ToString(), end ),
				null, null, null );
		}

		public static void ProcessContractUsageEvent( string contractNumber, string eventType )
		{
			subject = "Contract Usage Event";
			Email email = new Email();

			// send email notification of process begin
			email.Send( emailFrom, "", emailTo, "", subject, String.Format( format, DateTime.Now.ToString(), begin ),
				null, null, null );

			AccountEventType aet = AccountEventType.UsageUpdate;
			AccountEventType eventAssociate = AccountEventType.DealSubmission;

			DataSet ds = new DataSet();

			if( AccountEventType.DealSubmission.ToString().Equals( eventType ) )
				ds = AccountSql.GetAccountsByContractNumber( contractNumber );

			if( AccountEventType.RenewalSubmission.ToString().Equals( eventType ) )
			{
				eventAssociate = AccountEventType.RenewalSubmission;
				ds = AccountSql.GetRenewalAccountsByContractNumber( contractNumber );
			}

			foreach( DataRow dr in ds.Tables[0].Rows )
				AccountEventProcessor.ProcessEvent( eventAssociate, aet, dr["account_number"].ToString(), dr["utility_id"].ToString(), ResponseType.None, null );

			// send email notification of process end
			email.Send( emailFrom, "", emailTo, "", subject, String.Format( format, DateTime.Now.ToString(), end ),
				null, null, null );
		}

		public static void ProcessAccountRolloverEvent( string accountNumber, string utilityCode )
		{
			subject = "Account Rollover Event";
			Email email = new Email();

			// send email notification of process begin
			email.Send( emailFrom, "", emailTo, "", subject, String.Format( format, DateTime.Now.ToString(), begin ),
				null, null, null );

			AccountEventType aet = AccountEventType.Rollover;

			AccountEventProcessor.ProcessEvent( aet, accountNumber, utilityCode );

			// send email notification of process end
			email.Send( emailFrom, "", emailTo, "", subject, String.Format( format, DateTime.Now.ToString(), end ),
				null, null, null );
		}
	}
}
