namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	public class WebUsage
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public WebUsage()
		{
			this.BeginDate = DateTime.MinValue;
			this.EndDate = DateTime.MinValue;
			this.TotalKwh = -1;
		}

		public WebUsage( DateTime beginDate, DateTime endDate )
		{
			this.BeginDate = beginDate;
			this.EndDate = endDate;
		}

		/// <summary>
		/// Meter number
		/// </summary>
		public string AccountNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Utility code
		/// </summary>
		public string UtilityCode
		{
			get;
			set;
		}

		/// <summary>
		/// Begin date
		/// </summary>
		public DateTime BeginDate
		{
			get;
			set;
		}

		/// <summary>
		/// End date
		/// </summary>
		public DateTime EndDate
		{
			get;
			set;
		}

		/// <summary>
		/// Days
		/// </summary>
		public int Days
		{
			get;
			set;
		}

		/// <summary>
		/// Meter number
		/// </summary>
		public string MeterNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Quantity
		/// </summary>
		public int TotalKwh
		{
			get;
			set;
		}

		/// <summary>
		/// ICAP
		/// </summary>
		public decimal Icap
		{
			get;
			set;
		}

		/// <summary>
		/// TCAP
		/// </summary>
		public decimal Tcap
		{
			get;
			set;
		}

		public BusinessRule UsageDataExistsRule
		{
			get;
			set;
		}
	}
}
