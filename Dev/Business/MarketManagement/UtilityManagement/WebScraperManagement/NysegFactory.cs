namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.WebAccess.WebScraperManagement;

	public static class NysegFactory
	{

		// ------------------------------------------------------------------------------------
		public static Nyseg GetUsage( string accountNumber, out string message )
		{
			string htmlContent = NysegScraper.GetAccountUsageHtml( accountNumber );
			NysegParser parser = new NysegParser( htmlContent );

			Nyseg account = parser.Parse();
			account.AccountNumber = accountNumber;

			NysegAccountDataExistsRule rule = new NysegAccountDataExistsRule( account );
			rule.Validate();

			if( rule.DefaultSeverity.Equals( BrokenRuleSeverity.Error ) )
				ExceptionLogger.LogAccountExceptions( account );

			MessageFormatter messageFormatter = new MessageFormatter( rule.Exception );

			message = messageFormatter.Format();
			// SR 1-3502533 - check for incented load
			if( htmlContent.ToLower().Contains( "incented load" ) )
			{
				message = "[Has Incented Load]. " + message;
			}

			return account;
		}

	}
}
