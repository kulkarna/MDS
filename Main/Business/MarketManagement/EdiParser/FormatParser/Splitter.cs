namespace LibertyPower.Business.MarketManagement.EdiParser.FormatParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Class for splitting strings
	/// </summary>
	public static class Splitter
	{
		/// <summary>
		/// Split string using specified delimiter.
		/// </summary>
		/// <param name="stringToSplit">String to split</param>
		/// <param name="delimiter">Delimiter</param>
		/// <returns>Returns a string array.</returns>
		public static string[] Split( string stringToSplit, char delimiter )
		{
			return stringToSplit.Split( delimiter );
		}
	}
}
