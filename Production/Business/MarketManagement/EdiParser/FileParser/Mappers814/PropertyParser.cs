namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Linq.Expressions;
	using System.Reflection;

	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Responsible for parsing a FileRow instance into a property of a EdiAccount instance.
	/// </summary>
	/// <typeparam name="T">Type of the property</typeparam>
	public abstract class PropertyParser<T> : IPropertySetter
	{
		private int          cellIndex;
		private PropertyInfo propertySetter;

		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="propertySetter">Setter expression of a property of a EdiAccount instance</param>
		/// <param name="cellIndex">Index of the in a FileRow wich contain the data that will be parsed</param>
		public PropertyParser( Expression<Func<EdiAccount, T>> propertySetter, int cellIndex )
		{
			this.cellIndex      = cellIndex;
			this.propertySetter = ( PropertyInfo ) ( propertySetter.Body as MemberExpression ).Member;
		}

		/// <summary>
		/// Index of the in a FileRow wich contain the data that will be parsed
		/// </summary>
		protected int CellIndex
		{
			get { return cellIndex; }
		}

		/// <summary>
		/// Property setter
		/// </summary>
		protected PropertyInfo Setter
		{
			get { return propertySetter; }
		}

		/// <summary>
		/// Parses a FileRow instance into a property of a EdiAccount instance and sets its value
		/// </summary>
		/// <param name="target">Property owner</param>
		/// <param name="fileCellContent">File Row Cell instance being parsed</param>
		/// <param name="fieldDelimiter">field delimiter</param>
		public virtual void SetValue( EdiAccount target, ref string fileCellContent, char fieldDelimiter )
		{
			object parsedValue = Parse( ref fileCellContent, fieldDelimiter );

			propertySetter.SetValue( target, parsedValue, null );
		}

		/// <summary>
		/// Parses a FileRow instance into a property of a EdiAccount instance
		/// </summary>
		/// <param name="fileRowCell">FileRow Cell instance wich will be mapped to a property</param>
		/// <param name="fieldDelimiter"> Field delimiter used to split the file row cell</param>
		/// <returns>Parsed value of the FileRow instance</returns>
		protected abstract T Parse( ref string fileRowCell, char fieldDelimiter );
	}
}
