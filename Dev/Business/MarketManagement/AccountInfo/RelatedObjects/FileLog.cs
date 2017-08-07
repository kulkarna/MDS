using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	/// <summary>
	/// FileLog object will hold information regarding the files imported
	/// </summary>
	public class FileLog
	{
		/// <summary>
		/// ID
		/// </summary>
		public int ID;

		/// <summary>
		/// name of the zipfile
		/// </summary>
		public string ZipFileName;

		/// <summary>
		/// file name
		/// </summary>
		public string FileName;

		/// <summary>
		/// status: processed, failed, in process
		/// </summary>
		public string Status;

		/// <summary>
		/// message related to the process error/success
		/// </summary>
		public string MSG;

		/// <summary>
		/// GUID
		/// </summary>
		public string FGUID;

		/// <summary>
		/// Load date
		/// </summary>
		public DateTime LoadDate;
		public DateTime ProcessStartTime;
		public DateTime ProcessEndTime;

	}
}
