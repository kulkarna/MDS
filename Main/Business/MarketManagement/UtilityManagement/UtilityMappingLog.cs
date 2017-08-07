namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Class for utility mapping log data
	/// </summary>
	public class UtilityMappingLog
	{
		/// <summary>
		/// Record identifier
		/// </summary>
		public int Identity {get;set;}

		/// <summary>
		/// Account number
		/// </summary>
		public string AccountNumber { get; set; }

		/// <summary>
		/// Utility record identifier
		/// </summary>
		public int UtilityID { get; set; }

		/// <summary>
		/// Log message
		/// </summary>
		public string Message { get; set; }

		/// <summary>
		/// Severity level (Enum)
		/// </summary>
		public BrokenRuleSeverity SeverityLevel { get; set; }

		/// <summary>
		/// LPC Application (Enum)
		/// </summary>
		public LpcApplication LpcApplication { get; set; }

		/// <summary>
		/// Date created
		/// </summary>
		public DateTime DateCreated { get; set; }


	}
}
