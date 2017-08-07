namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;

	/// <summary>
	/// Utilit configuration object that inherits from the utility object
	/// </summary>
	public class UtilityConfig : Utility
	{
		/// <summary>
		/// Constructor that takes necessary parameters for object
		/// </summary>
		/// <param name="utility">Utility identifier</param>
		/// <param name="marketCode">Market identifier</param>
		/// <param name="dunsNumber">DUNS number</param>
		/// <param name="rowDelimiter">Character row delimiter</param>
		/// <param name="fieldDelimiter">Character field delimiter</param>
		/// <param name="parsable">indicates if the utility is parsable or not</param>
		public UtilityConfig( Utility utility, string marketCode, string dunsNumber, char rowDelimiter, char fieldDelimiter, bool parsable )
			:base (utility.Code)
		{
			this.UtilityCode = utility.Code;
			this.RetailMarketCode = marketCode;
			this.DunsNumber = dunsNumber;
			this.RowDelimiter = rowDelimiter;
			this.FieldDelimiter = fieldDelimiter;
			this.Parsable = parsable;
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public UtilityConfig( string utilityCode )
			: base( utilityCode )
		{
		}

		/// <summary>
		/// Utility identifier
		/// </summary>
		public string UtilityCode
		{
			get;
			set;
		}

		/// <summary>
		/// Character row delimiter
		/// </summary>
		public char RowDelimiter
		{
			get;
			set;
		}

		/// <summary>
		/// Character field delimiter
		/// </summary>
		public char FieldDelimiter
		{
			get;
			set;
		}

		/// <summary>
		/// true if the utility is Scrapable
		/// </summary>
		public bool Parsable
		{
			get;
			set;
		}

	}
}
