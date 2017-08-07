namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;

	/// <summary>
	/// Edi account object
	/// </summary>
	public class EdiDailyTransaction
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public EdiDailyTransaction() { }

		/// <summary>
		/// Constructor that takes all properties of account object.
		/// </summary>
		/// <param name="dunsNumber">Duns Number</param>
		/// <param name="customerName">Customer number</param>
		/// <param name="TransactionNumber">Transaction number</param>
		/// <param name="TransactionDate">Transaction date</param>
		/// <param name="RequestType">Request type</param>
		/// <param name="TransactionReferenceNumber">Transaction reference number</param>
		/// <param name="Direction">Direction</param>
		/// <param name="Tstatus">Status</param>
		/// <param name="fileName">File name</param>
		public EdiDailyTransaction( string dunsNumber, string customerName, string TransactionNumber, DateTime TransactionDate, string RequestType,
									string TransactionReferenceNumber, string Direction, int Tstatus, string fileName )
		{
			
		}

		/// <summary>
		/// DUNS number (ASP_TPID) 
		/// </summary>
		public string DunsNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Account number (ACCTNUM)
		/// </summary>
		public string AccountNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Transaction Number (TRANSNO)
		/// </summary>
		public string TransactionNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Transaction Date (TRANSLATEDT)
		/// </summary>
		public DateTime TransactionDate
		{
			get;
			set;
		}
	
		/// <summary>
		/// Request Type (TSET)
		/// </summary>
		public string RequestType
		{
			get;
			set;
		}

		/// <summary>
		/// Request Type (TRANSREFNO)
		/// </summary>
		public string TransactionReferenceNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Direction (DIRECTIONSW)
		/// </summary>
		public string Direction
		{
			get;
			set;
		}
		
		/// <summary>
		/// Tstatus (TSTATUS)
		/// </summary>
		public int Tstatus
		{
			get;
			set;
		}
		
		/// <summary>
		/// FileName (FILENAME)
		/// </summary>
		public string FileName
		{
			get;
			set;
		}
	}
}
