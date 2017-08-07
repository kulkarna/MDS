namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Linq.Expressions;

	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Parser for meter multiplier property
	/// </summary>
	public class MeterMultiplierParser : PropertyParser<short>
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="propertySetter"></param>
		/// <param name="cellIndex"></param>
		public MeterMultiplierParser( Expression<Func<EdiAccount, short>> propertySetter, int cellIndex )
			: base( propertySetter, cellIndex )
		{ 
		}

		/// <summary>
		/// Parses field data
		/// </summary>
		/// <param name="fileRowCell">Row cell containing the field</param>
		/// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
		/// <returns>Parsed value of the field</returns>
		protected override short Parse( ref string fileRowCell, char fieldDelimiter )
		{
			char[] cD = { fieldDelimiter };
			string[] cells = fileRowCell.Split( cD, CellIndex + 2 );

			string parsedValue = string.Empty;
			short parsed = -1;

			//////// T O FIX 

			if( !fileRowCell.Contains( "KHMON" ) )
			{
				parsedValue = cells[CellIndex].Trim();
				short.TryParse( parsedValue.Split( '.' )[0], out parsed );
			}
			return parsed;
		}
	}
}
