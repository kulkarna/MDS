using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Factory for creating generic collections of peak hour objects.
	/// </summary>
	public static class PeakHoursFactory
	{
		/// <summary>
		/// Gets a generic collection of peak hour objects.
		/// </summary>
		/// <param name="marketCode">Market identifier</param>
		/// <param name="beginDate">Begin date</param>
		/// <param name="endDate">End date.</param>
		/// <returns>Returns a a generic collection of peak hour objects.</returns>
		public static PeakHoursDictionary GetPeakOffPeakHours(string marketCode, DateTime beginDate, DateTime endDate)
		{
			DataTable dt;
			DateTime dateKey; // date key is concatenated with month, year and first day of month
			PeakHours peakHours;
			PeakHoursDictionary phd = new PeakHoursDictionary();

			dt = UsageSql.GetPeakOffPeakHoursByMarket( marketCode, beginDate, endDate ).Tables[0];

			foreach( DataRow dr in dt.Rows )
			{
				peakHours = new PeakHours();
				peakHours.Month = (int) dr["Month"];
				peakHours.OffPeakHours = (int) dr["OffPeakHours"];
				peakHours.OnPeakHours = (int) dr["PeakHours"];
				peakHours.Year = (int) dr["Year"];

				dateKey = Convert.ToDateTime( peakHours.Month.ToString() + "/1/" + peakHours.Year.ToString() );

				phd.Add( dateKey, peakHours );
			}

			return phd;
		}
	}
}
