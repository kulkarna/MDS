namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.IO;
	using System.Net;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.WebAccess.WebScraperManagement;

	public static class CmpFactory
	{
		public static Cmp GetUsage( string accountNumber, out string message )
		{
			string       htmlContent = CmpScraper.GetUsageHtml( accountNumber );
			CmpParser    parser      = new CmpParser( htmlContent );
			Cmp          account     = parser.Parse();

			//in case the account entered doesn't exist, the account object will be null. Therefore exit the methode
			if( account == null )
			{
				message = "Account doesn't exist";
				return null;
			}

			BusinessRule rule        = new CmpAccountDataExistsRule( account );

			account.AccountNumber = accountNumber;

			if( !rule.Validate() && rule.Exception.Severity.Equals( BrokenRuleSeverity.Error ) )
				ExceptionLogger.LogAccountExceptions( account );

			MessageFormatter messageFormatter = new MessageFormatter( rule.Exception );

			message = messageFormatter.Format();

			return account;
		}
	}
}
