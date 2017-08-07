namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;

	/// <summary>
	/// IDR usage class
	/// </summary>
	public class IdrUsage
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public IdrUsage()
		{
		}

		/// <summary>
		/// Contructor that takes in two parameters: date + interval
		/// </summary>
		/// <param name="date"></param>
		/// <param name="interval"></param>
		public IdrUsage( DateTime date, Int16 interval )
		{
			this.Date = date;
			this.Interval = interval;
		}

		/// <summary>
		/// Account number
		/// </summary>
		public string AccountNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Date
		/// </summary>
		public DateTime Date
		{
			get;
			set;
		}

		/// <summary>
		/// Interval (i.e. 15 mins, hourly, etc)
		/// </summary>
		public Int16 Interval
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
		/// Quantity used in time interval
		/// </summary>
		public decimal Quantity
		{
			get;
			set;
		}
	}
}
