using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Class for file row and field delimiters
	/// </summary>
	[Serializable]
	public class UtilityFileDelimiter
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public UtilityFileDelimiter() { }

		/// <summary>
		/// Constructor that takes parameters for all properties of class
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="rowDelimter">File row delimiter</param>
		/// <param name="fieldDelimiter">File field delimiter</param>
		public UtilityFileDelimiter( string utilityCode, char rowDelimter, char fieldDelimiter )
		{
			this.UtilityCode = utilityCode;
			this.RowDelimiter = rowDelimter;
			this.FieldDelimiter = fieldDelimiter;
		}

		/// <summary>
		/// Utility identifier
		/// </summary>
		public string UtilityCode
		{
			get;
			set;
		}

		/// <summary>
		/// File row delimiter
		/// </summary>
		public char RowDelimiter
		{
			get;
			set;
		}

		/// <summary>
		/// File field delimiter
		/// </summary>
		public char FieldDelimiter
		{
			get;
			set;
		}
	}
}
