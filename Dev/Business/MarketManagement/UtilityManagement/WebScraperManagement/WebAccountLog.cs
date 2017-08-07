namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using LibertyPower.Business.CommonBusiness.CommonRules;

	public class WebAccountLog
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public WebAccountLog() { }

		/// <summary>
		/// Constructor that takes (almost) all properties of the web account log.
		/// </summary>
		/// <param name="utilityCode"></param>
		/// <param name="accountNumber"></param>
		/// <param name="information"></param>
		/// <param name="severity"></param>
		public WebAccountLog( string utilityCode, string accountNumber, string information, BrokenRuleSeverity severity )
		{
			this.UtilityCode = utilityCode;
			this.AccountNumber = accountNumber;
			this.Information = information;
			this.Severity = severity;
		}

		/// <summary>
		/// Constructor that takes all properties of the web account log.
		/// </summary>
		/// <param name="id"></param>
		/// <param name="utilityCode"></param>
		/// <param name="accountNumber"></param>
		/// <param name="information"></param>
		/// <param name="severity"></param>
		public WebAccountLog( int id, string utilityCode, string accountNumber, string information, BrokenRuleSeverity severity )
		{
			this.ID = id;
			this.UtilityCode = utilityCode;
			this.AccountNumber = accountNumber;
			this.Information = information;
			this.Severity = severity;
		}

		/// <summary>
		/// Web account log record identifier
		/// </summary>
		public int ID
		{
			get;
			set;
		}

		public string UtilityCode
		{
			get;
			set;
		}

		public string AccountNumber
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
	}
}
