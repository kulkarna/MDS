namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.WebAccess.WebScraperManagement;

	public static class RgeFactory
	{
		public static Rge GetUsage( string accountNumber, out string message )
		{
			string       htmlContent = RgeScraper.GetAccountUsageHtml( accountNumber );
			RgeParser    parser      = new RgeParser( htmlContent );
			Rge          account     = parser.Parse();
			BusinessRule rule        = new RgeAccountDataExistsRule( account );

			account.AccountNumber = accountNumber;

			if( !rule.Validate() && rule.Exception.Severity.Equals( BrokenRuleSeverity.Error ) )
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
