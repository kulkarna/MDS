using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{

	/// <summary>
	/// DateHelper include essential computing needed to be done on date fields
	/// </summary>
	public static class DateHelper
	{

		/// <summary>
		/// Default date to be used accross the app
		/// </summary>
		public static DateTime DefaultDate = DateTime.Parse( "01/01/1980" );

		/// <summary>
		/// Converts a date string to a date time object
		/// </summary>
		/// <param name="date">Date string</param>
		/// <returns>Returns a date time objetc</returns>
		public static DateTime ConvertDateString( string date )
		{
			if( date == null || date == string.Empty )
				return DefaultDate;

			int year = Convert.ToInt32( date.Substring( 0, 4 ) );
			int month = Convert.ToInt32( date.Substring( 4, 2 ) );
			int day = Convert.ToInt32( date.Substring( 6, 2 ) );

			return new DateTime( year, month, day );
		}

		/// <summary>
		/// Converts a datetime string to a date time object
		/// </summary>
		/// <param name="date"></param>
		/// <returns></returns>
		public static DateTime ConvertDateTimeString( string date )
		{
			if( date == null || date == string.Empty )
				return DefaultDate;

			int year = Convert.ToInt32( date.Substring( 0, 4 ) );
			int month = Convert.ToInt32( date.Substring( 4, 2 ) );
			int day = Convert.ToInt32( date.Substring( 6, 2 ) );
			int hour = Convert.ToInt32( date.Substring( 8, 2 ) );
			int mins = Convert.ToInt32( date.Substring( 10, 2 ) );

			return new DateTime( year, month, day, hour, mins, 0 );
		}

		/// <summary>
		/// Converts a date time to a fixed size string
		/// </summary>
		/// <param name="date"></param>
		/// <returns>yyyymmddhhMM</returns>
		public static string ConvertDateTimeString( DateTime date )
		{
			string dateTime = "";
			string temp = "";

			if (date == DateTime.MinValue)
				return dateTime;

			dateTime = date.Year.ToString();
			temp = date.Month.ToString();
			dateTime += temp.Length == 2 ? temp : "0" + temp;
			temp = date.Day.ToString();
			dateTime += temp.Length == 2 ? temp : "0" + temp;
			temp = date.Hour.ToString();
			dateTime += temp.Length == 2 ? temp : "0" + temp;
			temp = date.Minute.ToString();
			dateTime += temp.Length == 2 ? temp : "0" + temp;

			return dateTime;
		}

	}
}
