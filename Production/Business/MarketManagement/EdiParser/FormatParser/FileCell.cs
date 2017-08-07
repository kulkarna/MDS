namespace LibertyPower.Business.MarketManagement.EdiParser.FormatParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// File cell, cell of file row
	/// </summary>
	public class FileCell
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public FileCell() { }

		/// <summary>
		/// Constructor that takes cell contents and cell position
		/// </summary>
		/// <param name="contents">Cell contents</param>
		/// <param name="position">Cell position</param>
		public FileCell( string contents, int position )
		{
			this.Contents = contents;
			this.Position = position;
		}

		/// <summary>
		/// Cell contents
		/// </summary>
		public string Contents
		{
			get;
			set;
		}

		/// <summary>
		/// Cell position
		/// </summary>
		public int Position
		{
			get;
			set;
		}
		#region .Equals override

		/// <summary>
		/// Override the equals method on the AccountIDR object to compare only the account number. Equals is used by Contains, IndexOf...
		/// </summary>
		/// <param name="obj">object to be compared</param>
		/// <returns>true if a match is found</returns>
		public override bool Equals( object obj )
		{
			if( obj == null )
				return false;

			if( this.GetType() != obj.GetType() )
				return false;

			// safe because of the GetType check
			FileCell fc = (FileCell) obj;

			// use this pattern to compare reference members
			if( Object.Equals( this.Contents, fc.Contents ) )
				return true;

			return false;
		}

		public override int GetHashCode()
		{
			return base.GetHashCode();
		}

		#endregion .Equals override
		}
	}
