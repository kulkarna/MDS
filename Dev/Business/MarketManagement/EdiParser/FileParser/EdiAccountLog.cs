namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Edi account log object
	/// </summary>
	public class EdiAccountLog
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public EdiAccountLog() { }

		/// <summary>
		/// Constructor that takes all properties ob edi account log.
		/// </summary>
		/// <param name="ediFileLogID">Edi file log record identifier</param>
		/// <param name="ediProcessLogID">Edi process log record identifier</param>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="dunsNumber">DUNS number</param>
		/// <param name="information">Log information</param>
		public EdiAccountLog( int ediFileLogID, int ediProcessLogID, string accountNumber,
			string utilityCode, string dunsNumber, string information )
		{
			this.EdiFileLogID = ediFileLogID;
			this.EdiProcessLogID = ediProcessLogID;
			this.AccountNumber = accountNumber;
			this.UtilityCode = utilityCode;
			this.DunsNumber = dunsNumber;
			this.Information = information;
		}

		/// <summary>
		/// Constructor that takes all properties ob edi account log.
		/// </summary>
		/// <param name="id">Edi account log record identifier</param>
		/// <param name="ediProcessLogID">Edi process log record identifier</param>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="dunsNumber">DUNS number</param>
		/// <param name="information">Log information</param>
		/// <param name="severity">Severity of an exception</param>
		/// <param name="timeStamp">Time stamp of record</param>
		public EdiAccountLog( int id, int ediProcessLogID, string accountNumber,
			string dunsNumber, string information, BrokenRuleSeverity severity, DateTime timeStamp ) 
		{
			this.ID = id;
			this.EdiProcessLogID = ediProcessLogID;
			this.AccountNumber = accountNumber;
			this.DunsNumber = dunsNumber;
			this.Information = information;
			this.TimeStamp = timeStamp;
		}

		/// <summary>
		/// Edi account log record identifier
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
		/// Edi process log record identifier
		/// </summary>
		public int EdiProcessLogID
		{
			get;
			set;
		}

		/// <summary>
		/// Account identifier
		/// </summary>
		public string AccountNumber
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
		/// DUNS number
		/// </summary>
		public string DunsNumber
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
		/// Severity of an exception
		/// </summary>
		public BrokenRuleSeverity Severity
		{
			get;
			set;
		}

		/// <summary>
		/// Time stamp of record
		/// </summary>
		public DateTime TimeStamp
		{
			get;
			set;
		}
	}
}
