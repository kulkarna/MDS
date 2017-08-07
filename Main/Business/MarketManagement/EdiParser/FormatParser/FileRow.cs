namespace LibertyPower.Business.MarketManagement.EdiParser.FormatParser
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
		/// <param name="rowNumber">Row number</param>
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

		/// <summary>
		/// List of file cells
		/// </summary>
		public string[] FileCellList
		{
			get;
			set;
		}

		/// <summary>
		/// Adds a file cell to file cell list
		/// </summary>
		/// <param name="cell">File cell</param>
		/*public void AddFileCell( FileCell cell )
		{
			if( FileCellList == null )
				FileCellList = new FileCellList();

			FileCellList.Add( cell );
		}*/
		}
	}
