namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Edi process log
	/// </summary>
	public class EdiProcessLog
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public EdiProcessLog() { }

		/// <summary>
		/// Constructor that takes all properties of object.
		/// </summary>
		/// <param name="id">Edi process log record identifier</param>
		/// <param name="ediFileLogId">Edi file log record identifier</param>
		/// <param name="info">Log information</param>
		/// <param name="isProcessed">Boolean indicating if successfully processed</param>
		/// <param name="timeStampInsert">Time stamp of record insert</param>
		/// <param name="timeStampUpdate">Time stamp of record update</param>
		public EdiProcessLog(int id, int ediFileLogId, string info, bool isProcessed,
			DateTime timeStampInsert, DateTime timeStampUpdate ) 
		{
			this.ID = id;
			this.EdiFileLogID = ediFileLogId;
			this.Information = info;
			this.IsProcessed = IsProcessed;
			this.TimeStampInsert = timeStampInsert;
			this.TimeStampUpdate = timeStampUpdate;
		}

		/// <summary>
		/// Edi process log record identifier
		/// </summary>
		public int ID
		{
			get;
			set;
		}

		/// <summary>
		/// Edi file log record identifier
		/// </summary>
		public int EdiFileLogID
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
		/// Boolean indicating if successfully processed
		/// </summary>
		public bool IsProcessed
		{
			get;
			set;
		}

		/// <summary>
		/// Time stamp of record insert
		/// </summary>
		public DateTime TimeStampInsert
		{
			get;
			set;
		}

		/// <summary>
		/// Time stamp of record update
		/// </summary>
		public DateTime TimeStampUpdate
		{
			get;
			set;
		}
	}
}
