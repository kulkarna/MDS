namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Text;
	using System.Net;
	using System.IO;
	using System.Web;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.WebAccess.WebScraperManagement;

	public static class CenhudFactory
	{
		public static Cenhud GetUsage( string accountNumber, out string message )
		{
			string content = CenhudScraper.GetUsageHtml( accountNumber );
			CenhudParser parser  = new CenhudParser( content );
			Cenhud       account = parser.Parse();
			BusinessRule rule    = new CenhudAccountDataExistsRule( account );

			account.AccountNumber = accountNumber;

			if( !rule.Validate() && rule.Exception.Severity.Equals( BrokenRuleSeverity.Error ) )
				ExceptionLogger.LogAccountExceptions( account );

			MessageFormatter messageFormatter =	new MessageFormatter( rule.Exception );

			message = messageFormatter.Format();

			return account;
		}

		private static string FormatMessage( BrokenRuleException brokenRuleException )
		{
			StringBuilder messageBuilder = new StringBuilder();

			if( brokenRuleException != null )
			{
				messageBuilder.Append( brokenRuleException.Message );

				if( brokenRuleException.DependentExceptions != null && brokenRuleException.DependentExceptions.Count > 0 )
				{
					foreach( BrokenRuleException exception in brokenRuleException.DependentExceptions )
						messageBuilder.Append( FormatMessage( exception ) );
				}
			}

			return messageBuilder.ToString().Trim();
		}
	}
}
