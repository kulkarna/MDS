using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public enum UsageType
	{
		/// <summary>
		/// Any (Billed) meter read that has been canceled by the Utility company
		/// </summary>
		Canceled = 0,
		/// <summary>
		/// Any meter read of an enrolled customer
		/// </summary>
		Billed = 1,
		/// <summary>
		/// Any meter read gotten prior to an enrollment
		/// </summary>
		Historical = 2,
		/// <summary>
		/// Any meter read calculated based on gap(s) from one meter read to the next
		/// </summary>
		Estimated = 6,
		/// <summary>
		/// Any meter read calculated in order to fill "external" gaps which is then used to give customers' quotes
		/// </summary>
		Profiled = 5,
		/// <summary>
		/// Meter reads manually entered by users (in case no historical data is available)
		/// </summary>
		Manual = 7,
		/// <summary>
		/// Meter reads uploaded by Pricing in the form of flat files
		/// </summary>
		File = 3,
		/// <summary>
		/// Any meter read calculated by the Utility based on trends from one meter read to the next
		/// </summary>
		UtilityEstimate = 4,
        /// <summary>
        /// Usage calendarized in ProspectAccountFactory to reduce multiple meters
        /// </summary>
        Calendarized = 8
	}
}
