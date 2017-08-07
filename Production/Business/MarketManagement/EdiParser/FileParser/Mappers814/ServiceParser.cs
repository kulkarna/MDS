namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Linq.Expressions;

	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Parser for services provided to a costumer (FIELD: LIN)
	/// </summary>
	public class ServiceParser : StringParser
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="propertySetter">Setter of the service property from EdiAccount</param>
		/// <param name="cellIndex">Position of the data in the field</param>
		public ServiceParser( Expression<Func<EdiAccount, string>> propertySetter, int cellIndex )
			: base( propertySetter, cellIndex )
		{
		}

		/// <summary>
		/// Parses field data
		/// </summary>
		/// <param name="fileRowCell">Row cell containing the field</param>
		/// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
		/// <returns>Parsed value of the field</returns>
		protected override string Parse( ref string fileRowCell, char fieldDelimiter )
		{
			string parsedValue = string.Empty;

			char[] cD = { fieldDelimiter };
			string[] cells = fileRowCell.Split( cD, CellIndex + 3 );

			if( CellIndex + 1 < cells.Length )
				parsedValue = cells[CellIndex].Trim() + cells[CellIndex + 1].Trim();

			return parsedValue;
		}
	}
}
