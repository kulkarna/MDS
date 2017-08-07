namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonHelper;

	/// <summary>
	/// Edi file log
	/// </summary>
	public class EdiFileLog
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public EdiFileLog() { }

		/// <summary>
		/// Constructor that takes all properties for object
		/// </summary>
		/// <param name="id">Edi file log record identifier</param>
		/// <param name="fileGuid">File identifier in managed storage</param>
		/// <param name="fileName">File name</param>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="attempts">Processing attempts</param>
		/// <param name="information">Log information</param>
		/// <param name="isProcessed">Boolean indicating if successfully processed</param>
		/// <param name="timeStamp">Time stamp of record</param>
		/// <param name="ediFileType">Edi file type</param>
		public EdiFileLog(int id, string fileGuid, string fileName, string utilityCode, int attempts, string information,
			bool isProcessed, DateTime? timeStamp, EdiFileType ediFileType ) 
		{
			this.ID = id;
			this.FileGuid = fileGuid;
			this.FileName = fileName;
			this.UtilityCode = utilityCode;
			this.Attempts = attempts;
			this.Information = information;
			this.IsProcessed = IsProcessed;
			this.TimeStamp = timeStamp;
			this.EdiFileType = ediFileType;
		}

		/// <summary>
		/// Edi file log record identifier
		/// </summary>
		public int ID
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
		/// File name
		/// </summary>
		public string FileName
		{
			get;
			set;
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
		/// Log information
		/// </summary>
		public string Information
		{
			get;
			set;
		}

		/// <summary>
		/// Processing attempts
		/// </summary>
		public int Attempts
		{
			get;
			set;
		}

		/// <summary>
		/// Boolean indicating if successfully processed
		/// </summary>
		public bool IsProcessed
		{
			get;
			set;
		}

		/// <summary>
		/// Time stamp of record
		/// </summary>
		public DateTime? TimeStamp
		{
			get;
			set;
		}

		/// <summary>
		/// Edi file type (814, 867, status update)
		/// </summary>
		public EdiFileType EdiFileType
		{
			get;
			set;
		}
	}
}
