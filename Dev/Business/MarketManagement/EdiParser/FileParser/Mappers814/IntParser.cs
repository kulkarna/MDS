namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Linq.Expressions;

	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Parses string properties of a EdiAccount instance.
	/// </summary>
	public class IntParser : PropertyParser<int>
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="propertySetter">Setter of the property that will be parsed</param>
		/// <param name="cellIndex">Positon of th data in the field</param>
		public IntParser( Expression<Func<EdiAccount, int>> propertySetter, int cellIndex )
			: base( propertySetter, cellIndex )
		{
		}

		/// <summary>
		/// Parses field data
		/// </summary>
		/// <param name="fileRowCell">Row cell containing the field</param>
		/// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
		/// <returns>Parsed value of the field</returns>
		protected override int Parse( ref string fileRowCell, char fieldDelimiter )
		{
			string parsedValue = string.Empty;
			int parsed = 0;
			char[] cD = { fieldDelimiter };

			string[] cells = fileRowCell.Split( cD, CellIndex + 1 );

			if( CellIndex < cells.Length )
				parsedValue = cells[CellIndex].Trim();

			if( string.IsNullOrEmpty( parsedValue ) )
				parsed = -1;
			else
				int.TryParse( parsedValue, out parsed );

			return parsed;
		}
	}
}
