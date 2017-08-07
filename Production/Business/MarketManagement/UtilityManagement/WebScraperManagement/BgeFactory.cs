namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Linq;
	using System.Net;
	using System.Web;
	using System.IO;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.WebAccess.WebScraperManagement;

	public static class BgeFactory
	{
		public static Bge GetUsage( string accountNumber, out string message )
		{
			string htmlContent = BgeScraper.GetUsageHtml( accountNumber );
			BgeParser parser = new BgeParser( htmlContent );
			Bge account = parser.Parse();

			if( accountNumber.StartsWith("0") && account.AccountNumber != accountNumber )
				account.AccountNumber = accountNumber;

			BusinessRule rule = new BgeAccountDataExistsRule( account );

			//account.AccountNumber = accountNumber;

			if( !rule.Validate() )
				ExceptionLogger.LogAccountExceptions( account );

			MessageFormatter messageFormatter = new MessageFormatter( rule.Exception );

			message = messageFormatter.Format();

			return account;
		}
	}
}
