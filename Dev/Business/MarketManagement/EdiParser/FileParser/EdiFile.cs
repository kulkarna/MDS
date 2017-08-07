namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Edi file object that contains among other items the
	///  generic collections of the utility file content.
	/// </summary>
	public class EdiFile
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public EdiFile() { }

		/// <summary>
		/// Constructor that takes a file name with full path, DUNS number and utility code
		/// </summary>
		/// <param name="file">file name with full path</param>
		/// <param name="dunsNumber">DUNS number</param>
		/// <param name="utilityCode">Utility identifier</param>
		public EdiFile( string file, string dunsNumber, string utilityCode  )
		{
			this.File = file;
			this.DunsNumber = dunsNumber;
			this.UtilityCode = utilityCode;
		}

		/// <summary>
		/// Constructor that takes a file guid, file name with full path, DUNS number and utility code
		/// </summary>
		/// <param name="fileGuid">File identifier in managed storage.</param>
		/// <param name="file">file name with full path</param>
		/// <param name="dunsNumber">DUNS number</param>
		/// <param name="utilityCode">Utility identifier</param>
		public EdiFile( string fileGuid, string file, string dunsNumber, string utilityCode )
		{
			this.FileGuid = fileGuid;
			this.File = file;
			this.DunsNumber = dunsNumber;
			this.UtilityCode = utilityCode;
		}

		/// <summary>
		/// Edi file valid business rule
		/// </summary>
		public EdiFileValidRule EdiFileValidRule
		{
			get;
			set;
		}

		/// <summary>
		/// File identifier in managed storage
		/// </summary>
		public string FileGuid
		{
			get;
			set;
		}

		/// <summary>
		/// File name with full path
		/// </summary>
		public string File
		{
			get;
			set;
		}

		/// <summary>
		/// Edi file type (814, 867, status update)
		/// </summary>
		public EdiFileType FileType
		{
			get;
			set;
		}

		/// <summary>
		/// DUNS number
		/// </summary>
		public string DunsNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Utiltiy identifier
		/// </summary>
		public string UtilityCode
		{
			get;
			set;
		}

		/// <summary>
		/// Generic collection of rows with their respective cell collections
		///  for utility file.
		/// </summary>
		public FileRowList FileRowList
		{
			get;
			set;
		}

		/// <summary>
		/// Edi account list
		/// </summary>
		public EdiAccountList EdiAccountList
		{
			get;
			set;
		}

		/// <summary>
		/// Usage list
		/// </summary>
		public UtilityUsageAccountList UtilityUsageAccountList
		{
			get;
			set;
		}

		/// <summary>
		/// Edi file log
		/// </summary>
		public EdiFileLog EdiFileLog
		{
			get;
			set;
		}

		/// <summary>
		/// Edi process log
		/// </summary>
		public EdiProcessLog EdiProcessLog
		{
			get;
			set;
		}

		/// <summary>
		/// Edi account log list
		/// </summary>
		public EdiAccountLogList EdiAccountLogList
		{
			get;
			set;
		}

		/// <summary>
		/// Adds an edi account log object to account log list
		/// </summary>
		/// <param name="log"></param>
		public void AddEdiAccountLog( EdiAccountLog log )
		{
			if( this.EdiAccountLogList == null )
				this.EdiAccountLogList = new EdiAccountLogList();
			this.EdiAccountLogList.Add( log );
		}
	}
}
