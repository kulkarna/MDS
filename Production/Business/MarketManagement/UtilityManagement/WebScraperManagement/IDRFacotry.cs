namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
	using LibertyPower.DataAccess.WebAccess.WebScraperManagement;
	
	public static class IDRFacotry
	{
		/// <summary>
		/// get the list of IDR accounts from the site and save it to the database
		/// </summary>
		/// <param name="utility">utility in question: IDR_PECO</param>
		/// <param name="message">informative message (on success or failure)</param>
		/// <returns>True if success, False in case of an error</returns>
		public static bool GetIDRAccounts( string utility, out string message )
		{
			message = string.Empty;

			IDRScraper scraper = IDRScraper.GetScraper(utility);
			string content = scraper.GetIDRList();

			IDRParser parser = IDRParser.GetParser( utility, content );

			bool bSucess = parser.Parse( out message );

			Logger.LogIDRInfo( utility, message, DateTime.Now );
			
			Logger.LogIDRDelete();

			return bSucess;
		}
	}
}
