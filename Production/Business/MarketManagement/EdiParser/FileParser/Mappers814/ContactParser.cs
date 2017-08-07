namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Linq.Expressions;

	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Parses the Contact property of a EdiAccount instance
	/// </summary>
	public class ContactParser : PropertyParser<EdiAccountContact>
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="propertySetter">Setter of the Contact property</param>
		/// <param name="cellIndex">Index for the start of contact data</param>
		public ContactParser( Expression<Func<EdiAccount, EdiAccountContact>> propertySetter, int cellIndex )
			: base( propertySetter, cellIndex )
		{ 
		}

		/// <summary>
		/// Parses a FileRow instance into a EdiAccountContact instance
		/// </summary>
		/// <param name="fileRowCell">Row cell containing the field</param>
		/// <param name="fieldDelimiter">file delimiter used to split fileRowCell</param>
		/// <returns>Parsed value of the FileRow instance</returns>
		protected override EdiAccountContact Parse( ref string fileRowCell, char fieldDelimiter )
		{
			string[] cells = fileRowCell.Split( fieldDelimiter );

			EdiAccountContact contact = new EdiAccountContact();
			for( int i = CellIndex; i < cells.Length; i += 2 )
			{
				if( IsContactName( cells[i] ) )
					contact.Name = cells[i + 1].Trim();
				else if( IsEmailAddress( cells[i] ) )
					contact.EmailAddress = cells[i + 1].Trim();
				else if( IsFax( cells[i] ) )
					contact.Fax = cells[i + 1].Trim();
				else if( IsHomePhone( cells[i] ) )
					contact.HomePhone = cells[i + 1].Trim();
				else if( IsWorkPhone( cells[i] ) )
					contact.WorkPhone = cells[i + 1].Trim();
				else if( IsTelephone( cells[i] ) )
					contact.Telephone = cells[i + 1].Trim();
			}
			return contact;
		}

		/// <summary>
		/// Verifies if the cell contents represents Contact Name information
		/// </summary>
		private bool IsContactName ( string Contents )
		{
			return Contents.Equals( "IC" ) || Contents.Equals( "AL" ); 
		}

		/// <summary>
		/// Verifies if the cell contents represents Email Address information
		/// </summary>
		private bool IsEmailAddress ( string Contents )
		{
			return Contents.Equals( "EM" );
		}

		/// <summary>
		/// Verifies if the cell contents represents Fax information
		/// </summary>
		private bool IsFax ( string Contents )
		{
			return Contents.Equals( "FX" ); 
		}

		/// <summary>
		/// Verifies if the cell contents represents Home Phone information
		/// </summary>
		private bool IsHomePhone ( string Contents )
		{
			return Contents.Equals( "HP" );
		}

		/// <summary>
		/// Verifies if the cell contents represents Telephone information
		/// </summary>
		private bool IsTelephone ( string Contents )
		{
			return Contents.Equals( "TE" );
		}

		/// <summary>
		/// Verifies if the cell contents represents Work Phone information
		/// </summary>
		private bool IsWorkPhone ( string Contents )
		{
			return Contents.Equals( "WP" );
		}
	}
}
