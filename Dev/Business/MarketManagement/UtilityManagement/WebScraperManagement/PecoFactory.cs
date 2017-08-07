namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.WebAccess.WebScraperManagement;

	// EP - July 2010
	public static class PecoFactory
	{
		// ------------------------------------------------------------------------------------
		public static Peco GetUsage( string accountNumber, out string message, string postalCode )
		{
			string htmlContent = PecoScraper.GetAccountUsageHtml( accountNumber, postalCode );

			PecoParser   parser = new PecoParser( htmlContent );
			Peco         peco   = parser.Parse();
			BusinessRule rule   = new PecoAccountDataExistsRule( peco );

			peco.AccountNumber = accountNumber;

			if( !rule.Validate() && rule.Exception.Severity.Equals( BrokenRuleSeverity.Error ) )
				ExceptionLogger.LogAccountExceptions( peco );

			MessageFormatter messageFormatter = new MessageFormatter( rule.Exception );

			message = messageFormatter.Format();

			return peco;
		}
	}
}
