namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;

	/// <summary>
	/// Class for creating utility configuration objects
	/// </summary>
	public static class ConfigurationFactory
	{
		/// <summary>
		/// list that contains the list of the utilities to be scraped and not parsed
		/// </summary>
		//private static IList<string> scrapbaleList;

		/// <summary>
		/// Creates a utility configuration dictionary.
		/// </summary>
		/// <returns>Returns a utility configuration list.</returns>
		public static UtilityConfigList GetUtilityConfigurations()
		{
			UtilityConfigList configs = new UtilityConfigList();
			UtilityFileDelimiter delimiter = new UtilityFileDelimiter();

			UtilityList utilities = UtilityFactory.GetUtilityDuns();
			UtilityFileDelimiterDictionary delimiters = UtilityFactory.GetUtilityFileDelimiters();

			foreach( Utility utility in utilities )
			{
				try
				{
					string utilityCode = utility.Code;
					string marketCode = utility.RetailMarketCode;
					string dunsNumber = utility.DunsNumber;

					delimiters.TryGetValue( utilityCode, out delimiter );

					char rowDelimiter = delimiter.RowDelimiter;
					char fieldDelimiter = delimiter.FieldDelimiter;
					//					bool isUtilityParsable = isParsable( utility.Code );

					configs.Add( new UtilityConfig( utility, marketCode, dunsNumber, rowDelimiter, fieldDelimiter, true ) );
				}
				catch
				{
					// TODO: add missing delimiter message
				}
			}

			return configs;
		}

		/// <summary>
		/// get the utility configuration info from the database
		/// </summary>
		/// <param name="dunsNumber">duns number needed to get the info for</param>
		/// <returns>UtilityConfig object</returns>
		public static UtilityConfig GetUtilityConfigurations( string dunsNumber )
		{
			UtilityConfig uc = null;
			UtilityFileDelimiter fd = null;
			try
			{

				Utility utility = UtilityFactory.GetUtilityConfig( dunsNumber, out fd );
				if( utility != null )
				{
					//					bool isUtilityParsable = isParsable( utility.Code );
					uc = new UtilityConfig( utility, utility.RetailMarketCode, dunsNumber, fd.RowDelimiter, fd.FieldDelimiter, true );
				}
			}
			catch( Exception ex )
			{
				throw ex;
			}

			return uc;
		}
		/*
				private static bool isParsable( string utilityCode )
				{
					if( scrapbaleList == null || scrapbaleList.Count.Equals( 0 ) )
					{
						scrapbaleList = new List<string>();
		//				scrapbaleList.Add( "BGE" );										// SD24256
		//				scrapbaleList.Add( "CENHUD" );
		//				scrapbaleList.Add( "COMED" );									// SD22759
		//				scrapbaleList.Add( "CMP" );
		//				scrapbaleList.Add( "CONED" );									// SD24256
		//				scrapbaleList.Add( "NYSEG" );
						scrapbaleList.Add( "PGE" );										// Parser turned off until we get actual files from this Utility..
					}
					return !scrapbaleList.Contains( utilityCode );

				}
		*/
	}
}
