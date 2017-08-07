using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	public abstract class IDRScraper
	{
		static Dictionary<string, IDRScraper> dicScrapers = new Dictionary<string, IDRScraper>();
		
		public IDRScraper()
		{
		}
		
		/// <summary>
		/// Get the instance of the scraper in question depending on the type passed
		/// </summary>
		/// <param name="type">type: IDR_PECO</param>
		/// <returns></returns>
		public static IDRScraper GetScraper(string type)
		{
			if( !dicScrapers.ContainsKey("IDR_PECO") )
				dicScrapers.Add( "IDR_PECO", IDRPecoScraper.GetInstance() );

			if( !dicScrapers.Keys.Contains(type) )
				return null;
			return dicScrapers[type];
		}

		/// <summary>
		/// abstract method to be overriden in the inheritant class, this method should get the list of the IDR accounts
		/// </summary>
		/// <returns>Returns the list in a text format (string)</returns>
		public abstract string GetIDRList();
		
	}
}
