namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Linq.Expressions;

	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Parses string properties of a EdiAccount instance.
	/// </summary>
	public class DynamicParser : PropertyParser<dynamic>
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="propertySetter">Setter of the property that will be parsed</param>
		/// <param name="cellIndex">Positon of th data in the field</param>
        public DynamicParser(Expression<Func<EdiAccount,dynamic>> propertySetter, int cellIndex)
			: base( propertySetter, cellIndex )
		{
		}

		/// <summary>
		/// Parses field data
		/// </summary>
		/// <param name="fileRowCell">Row cell containing the field</param>
		/// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
		/// <returns>Parsed value of the field</returns>
		protected override dynamic Parse( ref string fileRowCell, char fieldDelimiter )
		{
			string parsedValue = string.Empty;

			char[] cD = { fieldDelimiter };
			string[] cells = fileRowCell.Split( cD, CellIndex + 2 );

			if( CellIndex < cells.Length )
				parsedValue = cells[CellIndex].Trim();

			return parsedValue;
		}
	}
}
