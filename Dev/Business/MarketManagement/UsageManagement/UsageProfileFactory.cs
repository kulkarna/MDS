using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Factory that produces profiled usage
	/// </summary>
	public static class UsageProfileFactory
	{
		/// <summary>Creates a generic dictionary collection of monthly usages with begin date, end date, total kwh, peak, and off peak values.</summary>
		/// <param name="dailyUsageDictionary">Generic dictionary collection of daily usage.</param> 
		/// <param name="peakProfileDictionary">Generic dictionary collection of daily peak profiles.</param> 
		/// <exception cref="DailyUsageNotFoundException">Thrown when daily usage is not found for a given date.</exception>						
		/// <exception cref="PeakProfileNotFoundException">Thrown when peak profile is not found for a given date.</exception>
		/// <returns>Generic dictionary collection of monthly usages with begin date, end date, total kwh, peak and off peak values.</returns>		
		public static UsageDictionary GetMonthlyUsage(
			DailyUsageDictionary dailyUsageDictionary,
			PeakProfileDictionary peakProfileDictionary )
		{
			UsageDictionary usageDictionary = new UsageDictionary();  // holds collection of monthly usages
			DailyUsage dailyUsage;			// used to get daily usage value
			DateTime beginDate;				// monthly usage start date
			DateTime endDate;				// monthly usage end date
			decimal totalKwh = 0;			// monthly usage
			decimal totalPeakKwh = 0;		// monthly peak usage
			decimal dailyPeakRatio = 0;		// daily peak ratio
			int loopCount = 0;

			DateTime workingDate;						// used in determining number of days to shift
			DateTime profileDate = DateTime.MinValue;	// date of profile
			int daysToAdjust = 0;						// number of days to shift
			DateTime minProfileDate;					// beginning of profile range
			DateTime maxProfileDate;					// end of profile range

			ArrayList dates = new ArrayList(); // hold a sorted list of dates
			List<DateTime> dateList = new List<DateTime>(); // hold the profile dates
			int currentMonth = 0;  // hold current month

			// iterate through daily usage, getting usage dates
			// need to order dates for calendarizing usage
			foreach( DailyUsage du in dailyUsageDictionary.Values )
				dates.Add( du.Date );
			dates.Sort();

			// get date range of profiles
			foreach( PeakProfile pp in peakProfileDictionary.Values )
				dateList.Add( pp.ProfileDate );
			DateRange range = DateHelper.GetDateRange( dateList );
			//minProfileDate = range.StartDate;
			maxProfileDate = range.EndDate;
			minProfileDate = maxProfileDate.AddDays( -363 );

			// initialize current month, begin, and end date
			currentMonth = Convert.ToDateTime( dates[0] ).Month;
			beginDate = Convert.ToDateTime( dates[0] );
			endDate = Convert.ToDateTime( dates[0] );

			foreach( DateTime date in dates )
			{
				// get daily usage
				if( !dailyUsageDictionary.TryGetValue( date, out dailyUsage ) )
					throw new DailyUsageNotFoundException( "Daily usage not found for date - " + date.ToShortDateString() + "." );

				// determine days to adjust
				workingDate = GetMostRecentProfileDateWithMatchingMonth( date, peakProfileDictionary );
				daysToAdjust = AdjustUsageDate( date, workingDate );
				profileDate = workingDate.AddDays( daysToAdjust );

				// if date or profile date is leap day,
				// check if days need shifting
				if( IsLeapDay( date ) ^ IsLeapDay( profileDate ) )
				{
					daysToAdjust = AdjustForLeapDay( date, profileDate );
					profileDate = profileDate.AddDays( daysToAdjust );
				}

				// if profile date is outside of profile date range, change profile date by 52 weeks
				if( profileDate < minProfileDate )
					profileDate = profileDate.AddDays( 364 );
				else if( profileDate > maxProfileDate )
					profileDate = profileDate.AddDays( -364 );

				PeakProfile peakProfile;

				if( !peakProfileDictionary.TryGetValue( profileDate, out peakProfile ) )
					if( !peakProfileDictionary.TryGetValue( profileDate.AddDays( -364 ), out peakProfile ) )
						throw new PeakProfileNotFoundException( "Peak profile not found for forecast date - " + date.ToShortDateString() + "." );

				// get peak profile percentage
				dailyPeakRatio = peakProfile.PeakRatio;

				// if calendar month is over, add to UsageDictionary
				if( currentMonth != date.Month )
				{
					usageDictionary.Add( beginDate, AddToUsageDictionary( beginDate, endDate, totalKwh, totalPeakKwh ) );

					// reset variables to values of first day of month
					beginDate = date;
					totalKwh = dailyUsage.Kwh;
					totalPeakKwh = dailyUsage.Kwh * dailyPeakRatio;
				}
				// keep running total
				else
				{
					totalKwh += dailyUsage.Kwh;
					totalPeakKwh += (dailyUsage.Kwh * dailyPeakRatio);
				}
				currentMonth = date.Month;
				endDate = date;

				loopCount++;
			}

			usageDictionary.Add( beginDate, AddToUsageDictionary( beginDate, endDate, totalKwh, totalPeakKwh ) );

			return usageDictionary;
		}

		/// <summary>
		/// Adds to the generic dictionary collection of monthly usages.
		/// </summary>
		/// <param name="beginDate">Start of calendar month.</param> 
		/// <param name="endDate">End of calendar month.</param> 
		/// <param name="totalKwh">Total monthly usage.</param> 
		/// <param name="totalPeakKwh">Total peak kwh.</param>
		private static Usage AddToUsageDictionary( DateTime beginDate, DateTime endDate,
			decimal totalKwh, decimal totalPeakKwh )
		{
			IUsagePeak iUsagePeak = new Usage();
			iUsagePeak.BeginDate = beginDate;
			iUsagePeak.EndDate = endDate;
			iUsagePeak.OffPeakKwh = totalKwh - totalPeakKwh;
			iUsagePeak.OnPeakKwh = totalPeakKwh;
			iUsagePeak.TotalKwh = Convert.ToInt32( totalKwh );

			return (Usage) iUsagePeak;
		}

		/// <summary>
		/// Creates an aggregation of monthly peak and off peak values.
		/// </summary>
		/// <param name="usageDictionary">Generic dictionary collection of usage.</param> 
		/// <returns>Aggregated monthly peak and off peak values.</returns>		
		public static MonthlyUsageAggregate GetMonthlyUsageAggregate( UsageDictionary usageDictionary )
		{
			MonthlyUsageAggregate monthlyUsageAggregate = new MonthlyUsageAggregate();
			decimal? onPeakKwh = 0m;
			decimal? offPeakKwh = 0m;

			foreach( Usage usage in usageDictionary.Values )
			{
				onPeakKwh += usage.OnPeakKwh == null ? 0m : usage.OnPeakKwh;
				offPeakKwh += usage.OffPeakKwh == null ? 0m : usage.OffPeakKwh;
			}
			monthlyUsageAggregate.OnPeakKwh = onPeakKwh;
			monthlyUsageAggregate.OffPeakKwh = offPeakKwh;

			return monthlyUsageAggregate;
		}


		/// <summary>
		/// Overloaded method that gets a dictionary of profiled daily usage for one or more meter reads.
		/// </summary>
		/// <param name="normalizedProfileDictionary">Generic dictionary collection of normalized profiles.</param> 
		/// <param name="usage">Single meter read.</param> 
		/// <returns>Generic dictionary collection of profiled daily usage.</returns>
		public static DailyUsageDictionary GetProfiledDailyUsage( NormalizedProfileDictionary normalizedProfileDictionary, Usage usage )
		{
			DailyUsageDictionary dailyUsageDictionary = new DailyUsageDictionary();  // collection of daily usage

			// passing normalized profiles, a meter read, and a reference to the daily usage dictionary, 
			// so daily usage can be added to the collection.
			GenerateProfiledDailyUsage( normalizedProfileDictionary, usage, dailyUsageDictionary );

			return dailyUsageDictionary;
		}

		/// <summary>
		/// Overloaded method that gets a dictionary of profiled daily usage for one or more meter reads.
		/// </summary>
		/// <param name="normalizedProfileDictionary">Generic dictionary collection of normalized profiles.</param> 
		/// <param name="usageDictionary">Generic dictionary collection of billing cycle usage.</param> 
		/// <exception cref="InsufficientProfilesException">Thrown when profiles do not cover usage date range.</exception>
		/// <returns>Generic dictionary collection of profiled daily usage.</returns>
		public static DailyUsageDictionary GetProfiledDailyUsage( NormalizedProfileDictionary normalizedProfileDictionary, UsageDictionary usageDictionary )
		{
			DailyUsageDictionary dailyUsageDictionary = new DailyUsageDictionary(); // collection of daily usage
			string accountNumber = "";

			// iterate through meter reads, passing normalized profiles, a meter read,
			// and a reference to the daily usage dictionary, so daily usage can be added
			// to the collection.
			foreach( Usage usage in usageDictionary.Values )
			{
				accountNumber = usage.AccountNumber;
				GenerateProfiledDailyUsage( normalizedProfileDictionary, usage, dailyUsageDictionary );
			}

			// validate that there are enough profiles for usage date range
			if( !HasSufficientProfiles( normalizedProfileDictionary, usageDictionary ) )
				throw new InsufficientProfilesException( "Date range in Daily Profile for Account " + accountNumber + " does not cover the usage for the account.  Please exclude this account." );

			return dailyUsageDictionary;
		}

		/// <summary>
		/// Used to generate daily usage for single meter read.
		/// </summary>
		/// <param name="normalizedProfileDictionary">Generic dictionary collection of normalized profiles.</param> 
		/// <param name="usage">Single meter read.</param> 
		/// <param name="dailyUsageDictionary">Generic dictionary collection of daily usage.</param> 
		/// <exception cref="NormalizedProfileNotFoundException">Thrown when normalized profile is not found for a given date.</exception>
		private static void GenerateProfiledDailyUsage( NormalizedProfileDictionary normalizedProfileDictionary, Usage usage, DailyUsageDictionary dailyUsageDictionary )
		{
			NormalizedProfile normalizedProfile;  // normalized value of profile used in calculation of daily usage
			decimal dayUsage;  // daily usage derived by normalized value multiplied by total usage
			DateTime workingDate;  // date used to obtain normalized profile, for daily usage date, and begin iteration
			DateTime endDate = usage.EndDate;  // date used to determine end of iteration


			// iterate through days in meter read
			for( workingDate = usage.BeginDate; workingDate <= endDate; workingDate = workingDate.AddDays( 1 ) )
			{
				DailyUsage dailyUsg;

				// get normalized profile for each date
				if( normalizedProfileDictionary.TryGetValue( workingDate, out normalizedProfile ) )
				{
					if( !dailyUsageDictionary.TryGetValue( workingDate, out dailyUsg ) )
					{
						// daily usage calculation
						dayUsage = normalizedProfile.NormalizedValue * usage.TotalKwh;
						// create daily usage object
						DailyUsage dailyUsage = new DailyUsage( workingDate, dayUsage );
						// add to collection
						dailyUsageDictionary.Add( workingDate, dailyUsage );
					}
				}
				else
					throw new NormalizedProfileNotFoundException( "Normalized profile not found for " + usage.UtilityCode + " account: " + usage.AccountNumber + " date: " + workingDate.ToShortDateString() );
			}
		}

		/// <summary>
		/// Gets a dictionary of forecast daily usage using day shifting.
		/// </summary>
		/// <param name="forecastBeginDate">Forecast begin date.</param> 
		/// <param name="forecastEndDate">Forecast end date.</param> 
		/// <param name="dailyUsageDictionary">Generic dictionary collection of daily usage.</param> 
		/// <exception cref="InvalidFlowStartDateException">Thrown when flow start date is less than most recent daily usage.</exception>
		/// <exception cref="InsufficientUsageException">Thrown when there is less than 364 days of usage.</exception>
		/// <exception cref="DailyUsageNotFoundException">Thrown when daily usage is not found for a given date.</exception>				
		/// <returns>Generic dictionary collection of daily usage.</returns>
		public static DailyUsageDictionary GetForecastDailyUsage( DateTime forecastBeginDate, DateTime forecastEndDate, DailyUsageDictionary dailyUsageDictionary )
		{
			DailyUsageDictionary forecastDailyUsageDictionary = new DailyUsageDictionary();  // contains daily usage collection
			DailyUsage dailyUsage;  // object contains date and single day of usage

			int flowStartDateYear = forecastBeginDate.Year;  // year of flow start date
			int flowStartDateMonth = forecastBeginDate.Month;  // month of flow start date
			int flowStartDateDay = forecastBeginDate.Day;  // day of flow start date
			int flowStartDateDayOfWeek = (int) forecastBeginDate.DayOfWeek;  // day of week of flow start date

			DateTime workingDate;  // used in determining number of days to shift
			DateTime currentUsageDate;  // used in iteration for building forecast daily usage dictionary
			DateTime currentForecastDate;  // used in iteration for forcast usage date
			DateTime maxUsageDate = DateTime.MinValue;  // used to determine if flow start date is later than most recent usage date
			int totalDaysUsage = 0;  // used for validating complete year of usage
			int maxYear = 0;  // used to hold most recent year that matches the flow start date month
			int daysToAdjust = 0;  // calculated number of days to shift
			DateTime beginUsageDate;  // beginning of usage range
			DateTime endUsageDate;  // end of usage range
			List<DateTime> dateList = new List<DateTime>(); // hold the usage dates

			// iterate through daily usage, 
			// getting the most recent year in the DailyUsage that matches the flow start date month
			foreach( DailyUsage du in dailyUsageDictionary.Values )
			{
				if( (du.Date.Year > maxYear) && (du.Date.Month == flowStartDateMonth) )
					maxYear = du.Date.Year;

				// track most recent date
				if( maxUsageDate == DateTime.MinValue )
					maxUsageDate = du.Date;
				else if( maxUsageDate < du.Date )
					maxUsageDate = du.Date;

				dateList.Add( du.Date );

				totalDaysUsage++;
			}

			// get date range of usage
			DateRange range = DateHelper.GetDateRange( dateList );
			//beginUsageDate = range.StartDate;
			endUsageDate = range.EndDate;
			beginUsageDate = endUsageDate.AddDays( -363 );


			// begin validation  ********************************************************************

			// check that most recent usage date is less than flow start date.
			if( forecastBeginDate <= maxUsageDate )
				throw new InvalidFlowStartDateException( "Flow start date must be later than most recent usage date." );

			// check if flow start date month is in daily usage.
			if( maxYear == 0 )
				throw new InsufficientUsageException( "No year found in the daily usage that matches the flow start date month." );

			// check for complete year of usage.
			if( totalDaysUsage < 364 )
				throw new InsufficientUsageException( "Minimum 364 days of usage required. " + totalDaysUsage.ToString() + " days provided." );

			// end validation  **********************************************************************

			// change year of working date
			currentUsageDate = forecastBeginDate.AddYears( maxYear - forecastBeginDate.Year );

			// build forecast daily usage dictionary
			for( currentForecastDate = forecastBeginDate; currentForecastDate <= forecastEndDate; currentForecastDate = currentForecastDate.AddDays( 1 ) )
			{
				// determine days to adjust
				workingDate = GetMostRecentUsageDateWithMatchingMonth( currentForecastDate, dailyUsageDictionary );
				daysToAdjust = AdjustUsageDate( currentForecastDate, workingDate );
				currentUsageDate = workingDate.AddDays( daysToAdjust );

				// if forecast date or usage date is leap day,
				// check if days need shifting
				if( IsLeapDay( currentForecastDate ) ^ IsLeapDay( currentUsageDate ) )
				{
					daysToAdjust = AdjustForLeapDay( currentForecastDate, currentUsageDate );
					currentUsageDate = currentUsageDate.AddDays( daysToAdjust );
				}

				// if current usage date (mapped date) is outside of usage date range, change current usage date by 52 weeks
				if( currentUsageDate < beginUsageDate )
					currentUsageDate = currentUsageDate.AddDays( 364 );
				else if( currentUsageDate > endUsageDate )
					currentUsageDate = currentUsageDate.AddDays( -364 );

				// if current usage date (mapped date) is in daily usage dictionary, then use current usage date,
				if( !dailyUsageDictionary.TryGetValue( currentUsageDate, out dailyUsage ) )
				{
					// otherwise go back 52 weeks.
					currentUsageDate = currentUsageDate.AddDays( -364 );

					// if still not found, throw up
					if( !dailyUsageDictionary.TryGetValue( currentUsageDate, out dailyUsage ) )
						throw new DailyUsageNotFoundException( "Daily usage not found for date - " + currentUsageDate.AddDays( -364 ).ToShortDateString() + "." );
				}

				DailyUsage forecastUsage = new DailyUsage( currentForecastDate, dailyUsage.Kwh );
				forecastDailyUsageDictionary.Add( currentForecastDate, forecastUsage );
			}

			return forecastDailyUsageDictionary;
		}

		/// <summary>
		/// Validates that there are profiles for every day of usage that will be used
		/// </summary>
		/// <param name="normalizedProfileDictionary">Generic dictionary collection of normalized profiles.</param>
		/// <param name="usageDictionary">Generic dictionary collection of billing cycle usage</param>
		/// <returns>True if profiles cover date range, false if not.</returns>
		private static bool HasSufficientProfiles( NormalizedProfileDictionary normalizedProfileDictionary, UsageDictionary usageDictionary )
		{
			List<DateTime> dateList = new List<DateTime>();

			// get maximum usage end date
			foreach( Usage usage in usageDictionary.Values )
				dateList.Add( usage.EndDate );
			DateTime endUsageDateRange = DateHelper.GetMaximumDate( dateList );

			// get minimum date needed to validate profile date range
			DateTime beginUsageDateRange = endUsageDateRange.AddDays( -363 );

			// if beginUsageDateRange falls between usage begin and end dates,
			// change beginUsageDateRange to begin date of usage
			// so as to included entire usage date range
			foreach( Usage usage in usageDictionary.Values )
				if( (beginUsageDateRange > usage.BeginDate) && (beginUsageDateRange < usage.EndDate) )
				{
					beginUsageDateRange = usage.BeginDate;
					break;
				}

			dateList.Clear();
			foreach( NormalizedProfile np in normalizedProfileDictionary.Values )
				dateList.Add( np.Date );
			DateRange profileDateRange = DateHelper.GetDateRange( dateList );

			if( (beginUsageDateRange < profileDateRange.StartDate) || (endUsageDateRange > profileDateRange.EndDate) )
				return false;

			return true;
		}

		private static DateTime GetMostRecentUsageDateWithMatchingMonth( DateTime forecastDate, DailyUsageDictionary dailyUsageDictionary )
		{
			int flowStartDateMonth = forecastDate.Month;
			int maxYear = 0;

			foreach( DailyUsage du in dailyUsageDictionary.Values )
				if( (du.Date.Year > maxYear) && (du.Date.Month == flowStartDateMonth) )
					maxYear = du.Date.Year;

			return forecastDate.AddYears( maxYear - forecastDate.Year );
		}

		private static DateTime GetMostRecentProfileDateWithMatchingMonth( DateTime date, PeakProfileDictionary peakProfileDictionary )
		{
			int startDateMonth = date.Month;
			int maxYear = 0;

            foreach (PeakProfile pp in peakProfileDictionary.Values)
                if ((pp.ProfileDate.Year > maxYear) && (pp.ProfileDate.Month == startDateMonth))
                    maxYear = pp.ProfileDate.Year;
            
			return date.AddYears( maxYear - date.Year );
		}

		/// <summary>
		/// Day shifts
		/// </summary>
		/// <param name="currentForecastDate">Forecast date</param>
		/// <param name="currentUsageDate">Usage date</param>
		/// <returns>Number indicating number of days to shift</returns>
		private static int AdjustUsageDate( DateTime currentForecastDate, DateTime currentUsageDate )
		{
			int daysToAdjust = 0;
			int currentForecastDateDayOfWeek = (int) currentForecastDate.DayOfWeek;
			int currentUsageDateDayOfWeek = (int) currentUsageDate.DayOfWeek;

			daysToAdjust = (currentForecastDateDayOfWeek - currentUsageDateDayOfWeek);

			// if day of week difference is greater than or less than 3, then adjust by -7 or 7 respectively,
			if( daysToAdjust > 3 )
				return (daysToAdjust -= 7);
			else if( daysToAdjust < -3 )
				return (daysToAdjust += 7);

			// otherwise, do not adjust
			return daysToAdjust;
		}

		/// <summary>
		/// Adjust for leap day
		/// </summary>
		/// <param name="currentForecastDate">Forecast date</param>
		/// <param name="currentUsageDate">Usage date</param>
		/// <returns>Number indicating number of days to shift</returns>
		private static int AdjustForLeapDay( DateTime currentForecastDate, DateTime currentUsageDate )
		{
			int daysToAdjust = 0;
			int currentForecastDateDayOfWeek = (int) currentForecastDate.DayOfWeek;
			int currentUsageDateDayOfWeek = (int) currentUsageDate.DayOfWeek;

			daysToAdjust = (currentForecastDateDayOfWeek - currentUsageDateDayOfWeek);

			// if day of week difference is greater than or less than 3, then adjust by -7 or 7 respectively,
			if( daysToAdjust > 3 )
				return -7;
			else if( daysToAdjust < -3 )
				return 7;

			// otherwise, do not adjust
			return 0;
		}

		/// <summary>
		/// Determines if specified date is February 29th
		/// </summary>
		/// <param name="date">Date to be checked</param>
		/// <returns>True or false</returns>
		private static bool IsLeapDay( DateTime date )
		{
			return (date.Month == 2 && date.Day == 29) ? true : false;
		}
	}
}
