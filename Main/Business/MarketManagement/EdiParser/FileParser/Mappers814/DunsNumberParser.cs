namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Linq.Expressions;

	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Responsible for parsing a FileRow instance into DunsNumber property of EdiAccount
	/// </summary>
	public class DunsNumberParser : PropertyParser<string>
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="dusnNumberSetter">Setter expression of DunsNumber property of EdiAccount class</param>
		/// <param name="cellIndex"></param>
		public DunsNumberParser( Expression<Func<EdiAccount, string>> dusnNumberSetter, int cellIndex )
			: base( dusnNumberSetter, cellIndex )
		{
		}

		/// <summary>
		/// Sets the value of the DunsNumber for the target account and sets its utility code based on this DunsNumber
		/// </summary>
		/// <param name="target">EdiAccount target instance</param>
		/// <param name="fileCellContent">the content of the row</param>
		/// <param name="fieldDelimiter">the field delimiter</param>
		public override void SetValue( EdiAccount target, ref string fileCellContent, char fieldDelimiter )
		{
			string parsedValue = Parse( ref fileCellContent, fieldDelimiter );
			string utilityCode = UtilityCodeResolver.ForDunsNumber( parsedValue ).Resolve();

			target.UtilityCode = utilityCode;

			Setter.SetValue( target, parsedValue, null );
		}

		/// <summary>
		/// Parses a FileRow instance into DusnNumber property of EdiAccount
		/// </summary>
		/// <param name="fileRowCell">Row cell containing the field</param>
		/// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
		/// <returns>Parsed value of the FileRow instance</returns>
		protected override string Parse( ref string fileRowCell, char fieldDelimiter )
		{
			char[] cD = { fieldDelimiter };
			string[] cells = fileRowCell.Split( cD, CellIndex + 2 );

			return cells[CellIndex].Trim();
		}
	}
}
