namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Linq.Expressions;

	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Parses string properties of a EdiAccount instance.
	/// </summary>
	public class DecimalParser : PropertyParser<decimal>
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="propertySetter">Setter of the property that will be parsed</param>
		/// <param name="cellIndex">Positon of th data in the field</param>
		public DecimalParser( Expression<Func<EdiAccount, decimal>> propertySetter, int cellIndex )
			: base( propertySetter, cellIndex )
		{
		}

		/// <summary>
		/// Parses field data
		/// </summary>
		/// <param name="fileRowCell">Row cell containing the field</param>
		/// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
		/// <returns>Parsed value of the field</returns>
		protected override decimal Parse( ref string fileRowCell, char fieldDelimiter )
		{
			string parsedValue = string.Empty;
			decimal parsed = 0;
			char[] cD = { fieldDelimiter };

			string[] cells = fileRowCell.Split( cD, CellIndex + 2 );

			if( CellIndex < cells.Length )
				parsedValue = cells[CellIndex].Trim();

			if( string.IsNullOrEmpty( parsedValue ) )
				parsed = Convert.ToDecimal( -1 );
			else
				decimal.TryParse( parsedValue, out parsed );

			return parsed;
		}
	}
}
