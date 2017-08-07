namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// Represents a filed in a file row
	/// </summary>
	public class Field
	{
		private string name;
		private bool   isComposite;

		private Field( string name, bool isComposite )
		{
			this.name = name;
			this.isComposite = isComposite;
		}

		/// <summary>
		/// Verifies if the field name represents Account Start
		/// </summary>
		public bool IsAccountStart
		{
			get { return name.Equals( "ST" ); }
		}

		/// <summary>
		/// Verifies if the field name represents Account End
		/// </summary>
		public bool IsAccountEnd
		{
			get { return name.Equals( "SE" ); }
		}

		/// <summary>
		/// Verifies if the field name represents the End of the Fle
		/// </summary>
		public bool IsEndOfFile
		{
			get { return name.Equals( "GE" ); }
		}

		/// <summary>
		/// Gets the name of the field
		/// </summary>
		public string Name
		{
			get { return name; }
		}

		/// <summary>
		/// Verifies if the field is compose by more than one cell
		/// </summary>
		public bool IsComposite
		{
			get { return isComposite; }
		}

		/// <summary>
		/// Adds a complement to the name of the filed. Ex.: N1 -> N18S
		/// </summary>
		/// <param name="complent"></param>
		public void Complement( string complent )
		{
			name += complent;
		}

		/// <summary>
		/// Creates a composite field
		/// </summary>
		/// <param name="name">Name of the field</param>
		/// <returns>Field instance</returns>
		public static Field CreateCompositeField( string name )
		{
			return new Field( name, true );
		}

		/// <summary>
		/// Creates a field based on a single cell
		/// </summary>
		/// <param name="name">Name of the field</param>
		/// <returns>Field instance</returns>
		public static Field CreateSingleField( string name )
		{
			return new Field( name, false );
		}
	}
}
