namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.WebAccess.WebScraperManagement;

	public static class NimoFactory
	{
		public static Nimo GetUsage( string accountNumber, out string message )
		{
			string       htmlContent = NimoScraper.GetUsageHtmlContent( accountNumber );
			NimoParser   parser      = new NimoParser( htmlContent );
			Nimo         account     = parser.Parse();
			BusinessRule rule        = new NimoAccountDataExistsRule( account );

			account.AccountNumber = accountNumber;

			if( !rule.Validate() && rule.Exception.Severity.Equals( BrokenRuleSeverity.Error ) )
				ExceptionLogger.LogAccountExceptions( account );

			MessageFormatter messageFormatter = new MessageFormatter( rule.Exception );

			message = messageFormatter.Format();

			return account;
		}
	}
}
