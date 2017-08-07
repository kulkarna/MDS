namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using LibertyPower.Business.CommonBusiness.CommonEntity;
	//using LibertyPower.DataAccess.SqlAccess.EnrollmentSql;
	using LibertyPower.DataAccess.SqlAccess.HistoricalInfoSql;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.WebAccess.WebScraperManagement;

	public static class ConedFactory
	{

		// ------------------------------------------------------------------------------------
		public static Coned GetUsage( string accountNumber, out string message )
		{
			Coned coned = new Coned( accountNumber );

			string html = ConedScraper.Navigate( accountNumber );

			// ------------------------------------------
			string ErrorMessage;

			if( html.Contains( "Account Number not found" ) )
			{
				message = "Account number is not valid.";
				return coned = null;
			}

			if( html.Contains( coned.AccountNumber ) )
				ErrorMessage = ConedParser.ParseData( coned, html, true );
			else
				ErrorMessage = ConedParser.ParseData( coned, html, false );

			ValidateResults( ErrorMessage, coned.AccountNumber );

			// ------------------------------------------
			//ValidateData( coned );
			ConedAccountDataExistsRule rule = new ConedAccountDataExistsRule( coned );
			rule.Validate();

			if( rule.DefaultSeverity.Equals( BrokenRuleSeverity.Error ) )
				ExceptionLogger.LogAccountExceptions( coned );

			MessageFormatter messageFormatter = new MessageFormatter( rule.Exception );

			message = messageFormatter.Format();

			switch( coned.Profile )
			{
				case "Y":
					coned.MeterType = "IDR";
					break;
				default:
					coned.MeterType = "Non-IDR";
					break;
			}

			return coned;
		}

		/*/ ------------------------------------------------------------------------------------
		private static void ValidateData( Coned account )
		{
			if( account.StratumVariable == null | account.StratumVariable.Length == 0 )
				throw new WebManagerException( "No Stratum Variable was found for account: " + account.AccountNumber + " (CONED)" );

			if( account.Icap == -1 )
				throw new WebManagerException( "No Icap value was found for account: " + account.AccountNumber + " (CONED)" );

			if( account.ZoneCode == null | account.ZoneCode.Length == 0 )
				throw new WebManagerException( "No Zone was found for account: " + account.AccountNumber + " (CONED)" );

			if( account.BillGroup == -1 )
				throw new WebManagerException( "No Bill Cycle/Bill Group was found for account: " + account.AccountNumber + " (CONED)" );

			if( account.RateClass == null | account.RateClass.Length == 0 )
				throw new WebManagerException( "No Rate Class/Service Class was found for account: " + account.AccountNumber + " (CONED)" );

		}	*/

		// ------------------------------------------------------------------------------------
		public static void ValidateResults( string ErrorMessage, string AccountNumber )
		{
			if( ErrorMessage.Contains( "Success" ) )
			{
				if( ErrorMessage.Contains( "No Annual Usage" ) )
					throw new WebManagerException( "Account: " + AccountNumber + " (CONED) had no usage." );
			}
			else
				throw new WebManagerException( "Error found while scrapping account: " + AccountNumber + " (CONED): " + ErrorMessage );

		}

	}
}
