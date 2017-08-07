namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Responsible for resolving the field name from a given FileRow
	/// </summary>
	public class FieldResolver
	{
		private List<Field> availableFields;

		/// <summary>
		/// Resolve all the fields
		/// </summary>
		public FieldResolver( )
		{
			availableFields = new List<Field>()
			{
				// Single cell fields
				Field.CreateSingleField( "ISA" ),
				Field.CreateSingleField( "ASI" ),
				Field.CreateSingleField( "PM"  ),
				Field.CreateSingleField( "NM1" ),
				Field.CreateSingleField( "PER" ),
				Field.CreateSingleField( "GS"  ),
				Field.CreateSingleField( "GE"  ),
				Field.CreateSingleField( "BGN" ),
				Field.CreateSingleField( "N2"  ),
				Field.CreateSingleField( "N3"  ),
				Field.CreateSingleField( "N4"  ),
				Field.CreateSingleField( "LIN" ),
				Field.CreateSingleField( "ST"  ),
				Field.CreateSingleField( "SE"  ),
				Field.CreateSingleField( "IEA" ),
				// Composite cells fields
				Field.CreateCompositeField( "N1"  ),
				Field.CreateCompositeField( "REF" ),
				Field.CreateCompositeField( "BPT" ),
				Field.CreateCompositeField( "AMT" ),
				Field.CreateCompositeField( "DTM" )
			};
		}

		/// <summary>
		/// Resolves the name of the field for a given FileRow
		/// </summary>
		/// <returns>Field</returns>
		public Field Resolve( string fc, char fieldDelimiter )
		{
			char[] cD = { fieldDelimiter };
			string[] cells = fc.Split( cD , 3);
			
			string fieldName = string.Empty;

			string firstCell = cells[0];

			if( firstCell.Equals( string.Empty ) )
				return null;

			Field field = ( from fieldResult in availableFields
							where fieldResult.Name == firstCell
							select fieldResult ).Single();

			if( field.IsComposite )
				field.Complement( cells[1] );

			return field;
		}
	}
}
