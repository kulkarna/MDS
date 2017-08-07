using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// This class represents a single scheduled meter read.
	/// </summary>
	public class MeterReadScheduleItem
	{
		/// <summary>
		/// The private instance field holding the utility code for this scheduled meter read.
		/// </summary>
		private string utilityCode;

		/// <summary>
		/// The private instance field holding the calendar year for this scheduled meter read.
		/// </summary>
		private int calendarYear;

		/// <summary>
		/// The private instance field holding the calendar month for this scheduled meter read.
		/// </summary>
		private int calendarMonth;

		/// <summary>
		/// The private instance field holding the meter read cycle ID for this scheduled meter read.
		/// </summary>
		private string readCycleId;

		/// <summary>
		/// The private instance field holding the meter read date for this scheduled meter read.
		/// </summary>
		private DateTime readDate;

		/// <summary>
		/// Instantiates the MeterReadScheduleItem with the given parameter values.
		/// </summary>
		/// <param name="utilityCode">The code uniquely identifying the utility.</param>
		/// <param name="calendarYear">The calendar year number.</param>
		/// <param name="calendarMonth">The calendar month number.</param>
		/// <param name="readCycleId">The meter read cycle identifier.</param>
		/// <param name="readDate">The scheduled meter read date.</param>
		public MeterReadScheduleItem(string utilityCode, int calendarYear, int calendarMonth, string readCycleId, DateTime readDate)
		{
			this.utilityCode = utilityCode;
			this.calendarYear = calendarYear;
			this.calendarMonth = calendarMonth;
			this.readCycleId = readCycleId;
			this.readDate = readDate;
		}

		/// <summary>
		/// The utility code of the utility to which this scheduled meter read belongs to.
		/// </summary>
		public string UtilityCode { get { return this.utilityCode; } }

		/// <summary>
		/// The calendar year number for which this scheduled meter read belongs to.
		/// </summary>
		public int CalendarYear { get { return this.calendarYear; } }

		/// <summary>
		/// The calendar month number for which this this scheduled meter read belongs to.
		/// </summary>
		public int CalendarMonth { get { return this.calendarMonth; } }

		/// <summary>
		/// The read cycle ID for this scheduled meter read.
		/// </summary>
		public string ReadCycleId { get { return this.readCycleId; } }

		/// <summary>
		/// The meter read date for this scheduled meter read.
		/// </summary>
		public DateTime ReadDate { get { return this.readDate; } }
	}
}
