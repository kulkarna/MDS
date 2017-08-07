namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// File row class
	/// </summary>
	public class FileRow
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public FileRow() { }

		/// <summary>
		/// Constructor that takes the contents as a parameter.
		/// </summary>
		/// <param name="contents">Contents of file row</param>
		/// <param name="rowNumber"> the row number</param>
		public FileRow( string contents, int rowNumber )
		{
			this.Contents = contents;
			this.RowNumber = rowNumber;
		}

		/// <summary>
		/// Row number
		/// </summary>
		public int RowNumber
		{
			get;
			set;
		}

		/// <summary>
		/// File contents
		/// </summary>
		public string Contents
		{
			get;
			set;
		}
	}
}
