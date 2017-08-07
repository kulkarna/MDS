/* **********************************************************************************************
 *
 *	Author:		Eduardo Patino
 *	Created:	Summer 2008
 *	Descp:		This class makes sure that all the periods have consistent data (i.e. no bogus usage,
 *				no gaps, no invalid periods, etc.)
 *
 ********************************************************************************************** */

using System;
using System.Collections.Generic;
using System.Linq;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.Business.CommonBusiness.TimeSeries;
using System.Data;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	public class UsageFiller
	{
		private static List<KeyValuePair<UsageSource, int>> usageSourcePriorities = null;

		//3/6/2014 5:02 pm Jikku: We will get the usagesource priorities only once from the db. The lower the numeric value of priority the higher actual priority
		public static List<KeyValuePair<UsageSource, int>> UsageSourcePriorities
		{
			get
			{
				if( usageSourcePriorities == null )
					GetUsageSourcePriorities();
				return usageSourcePriorities;
			}

		}

		//3/6/2014 5:02 pm Jikku:Remove entries from consolidatedusage when there are overlapping entries from rawusage
		public static void RemoveConflictingEntriesFromConsolidatedusage( UsageList rawUsages, UsageList consolidatedUsages, bool multipleMeters )
		{
			List<int> usageIndexesToRemove = new List<int>();
			List<int> rawUsageIndexesToRemove = new List<int>();
			for( int i = 0; i < consolidatedUsages.Count; i++ )
			{
				Usage consolidatedUsage = consolidatedUsages[i];
				for( int rawUsageIndex = 0; rawUsageIndex < rawUsages.Count; rawUsageIndex++ )
				{
					Usage rawUsage = rawUsages[rawUsageIndex];
					if( (!multipleMeters || rawUsage.MeterNumber == consolidatedUsage.MeterNumber) //if multiplemeter, we need to check for meternumber
					&& UsageFactory.UsageOverlaps( consolidatedUsage, rawUsage )
					&& rawUsage.UsageType != UsageType.Canceled
					)
					{

						if( rawUsage.TotalKwh == consolidatedUsage.TotalKwh && rawUsage.BeginDate == consolidatedUsage.BeginDate && rawUsage.EndDate == consolidatedUsage.EndDate )
							if( !rawUsageIndexesToRemove.Contains( rawUsageIndex ) )
								rawUsageIndexesToRemove.Add( rawUsageIndex );
							else
							{
								consolidatedUsage.IsActive = 0;
								consolidatedUsage.ReasonCode = ReasonCode.ConflictInUsage;
								UsageFactory.UpdateUsageRecord( consolidatedUsage );
								//remove from the in-memory consolidated usagelist
								if( !usageIndexesToRemove.Contains( i ) )
									usageIndexesToRemove.Add( i );
							}
					}
				}
			}
			rawUsageIndexesToRemove.Sort();
			//rawUsageIndexesToRemove.Reverse();

			for( int i = rawUsageIndexesToRemove.Count - 1; i >= 0; i-- )
			{
				rawUsages.RemoveAt( rawUsageIndexesToRemove[i] );
			}

			for( int i = usageIndexesToRemove.Count - 1; i >= 0; i-- )
			{
				consolidatedUsages.RemoveAt( usageIndexesToRemove[i] );
			}

		}

		//3/6/2015 5:04 pm Jikku :Remove overlapping entries from usages across usagesources based on priority of the usagesource.
		public static void RemoveConflictsBasedOnPriority( UsageList usages, bool multipleMeters )
		{
			List<int> indexesToRemove = new List<int>();
			foreach( KeyValuePair<UsageSource, int> kVP in UsageSourcePriorities )
			{
				//for each usage belonging to each usagesource, we will remove any lower prirority usages which overlap
				foreach( Usage higherPriorityUsage in usages.Where( u => u.UsageSource == kVP.Key
					&& u.UsageType != UsageType.Canceled ) )
				{
					for( int usageIndex = 0; usageIndex < usages.Count; usageIndex++ )
					//( Usage lowerPriorityUsage in usages.Where( u => UsageFactory.UsageOverlaps( higherPriorityUsage, u ) && u.UsageType != UsageType.Canceled ) )
					{
						Usage candidateLowerPriorityUsage = usages[usageIndex];
						if( (!multipleMeters || candidateLowerPriorityUsage.MeterNumber == higherPriorityUsage.MeterNumber) //if multiplemeter, we need to check for meternumber
							&& UsageFactory.UsageOverlaps( candidateLowerPriorityUsage, higherPriorityUsage )
							&& candidateLowerPriorityUsage.UsageType != UsageType.Canceled
							&& UsageSourcePriorities.Where( usp => usp.Key == candidateLowerPriorityUsage.UsageSource ).FirstOrDefault().Value >
							UsageSourcePriorities.Where( usp => usp.Key == higherPriorityUsage.UsageSource ).FirstOrDefault().Value )//greater numerical value of priority means lower actual priority
							if( !indexesToRemove.Contains( usageIndex ) )
								indexesToRemove.Add( usageIndex );
					}
				}

			}
			indexesToRemove.Sort();
			//indexesToRemove.Reverse();
			for( int i = indexesToRemove.Count - 1; i >= 0; i-- )
			{
				usages.RemoveAt( indexesToRemove[i] );
			}
		}

		public static void GetUsageSourcePriorities()
		{
			usageSourcePriorities = new List<KeyValuePair<UsageSource, int>>();
			foreach( DataRow dr in UsageSql.GetUsageSourcePriorities().Tables[0].Rows )
			{
				UsageSource src = (UsageSource) Enum.Parse( typeof( UsageSource ), dr["Value"].ToString() );
				usageSourcePriorities.Add( new KeyValuePair<UsageSource, int>( src, Convert.ToInt32( dr["Priority"].ToString() ) ) );
			}
			usageSourcePriorities = usageSourcePriorities.OrderBy( u => u.Value ).ToList();
		}

		// March 2010
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Logs meter reads used to calculate the annual usage (for starters)..
		/// </summary>
		/// <param name="snapshot"></param>
		/// <param name="triggeringEvent"></param>
		/// <param name="userName"></param>
		public static void AuditUsageUsed( UsageList snapshot, string triggeringEvent, string userName )
		{
			string eventId = String.Format( "{0:yyyy/MM/dd hh:mm}", DateTime.Now );

			foreach( Usage item in snapshot )
			{
				UsageSql.MapUsageUsedPerAccount( item.AccountNumber, item.ID, triggeringEvent, userName, eventId );
			}
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Given two usage lists this method will concatenate them into a single usage list
		/// </summary>
		/// <returns></returns>
		public static UsageList AddLists( UsageList list1, UsageList list2 )
		{
			if( list1 != null && list1.Count != 0 )
			{
				if( list2 != null && list2.Count != 0 )
					list1.AddRange( list2 );
			}
			else
				list1 = list2;

			return list1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Given two usage lists this method will concatenate them into a (new) single usage list
		/// </summary>
		/// <param name="list1"></param>
		/// <param name="list2"></param>
		/// <returns></returns>
		public static UsageList ConsolidateLists( UsageList list1, UsageList list2 )
		{
			UsageList consolidated = new UsageList();

			foreach( Usage usg1 in list1 )
				consolidated.Add( usg1 );

			foreach( Usage usg2 in list2 )
				consolidated.Add( usg2 );

			return consolidated;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Given a raw usage list this method will purge what the business has defined as invalid usage types (in order to calculate annual usage)
		/// </summary>
		/// <param name="dirty"></param>
		/// <returns></returns>
		public static UsageList AnnualUsageValidTypes( UsageList dirtyList )
		{
			UsageList cleanList = new UsageList();
			int[] record = new int[15];
			int removeAt = 0, resize = 0;
			Int16 dirtyRow = 0;
			string market = MarketFactory.GetRetailMarketByUtility( dirtyList[0].UtilityCode );

			foreach( Usage dirty in dirtyList )									//loop through dirty list to see if it's a valid type..
			{
				cleanList.Add( dirty );
				if( !(dirty.UsageType == UsageType.Billed || dirty.UsageType == UsageType.Historical) )	//duggy - only billed/historical
				{
                    if (!(dirty.UsageType == UsageType.File && (market == "TX" || market == "OH" || market == "CA" || market == "ME")))	//duggy - file is ok if it's from texas (ohio and california and Maine as well)..
					{
						record[removeAt] = dirtyRow;
						removeAt++;
						resize++;

						if( resize > 14 )
						{ resize = 0; Array.Resize( ref record, record.GetUpperBound( 0 ) + 16 ); }
					}

				}
				dirtyRow++;
			}

			if( removeAt != 0 )
			{
				int[] remove = new int[removeAt];

				for( int cnt = 0; cnt <= removeAt - 1; cnt++ )
					remove[cnt] = record[cnt];

				Array.Sort( remove );

				for( int cnt = removeAt - 1; cnt >= 0; cnt-- )
					cleanList.RemoveAt( Convert.ToInt16( remove[cnt] ) );
			}

			return cleanList;
		}

		// ------------------------------------------------------------------------------------
		public static bool ComparaUsage( Usage oldUsage, Usage newUsage )
		{
			if( DateRangeFactory.IsSameDate( oldUsage.EndDate, newUsage.EndDate ) && oldUsage.TotalKwh == newUsage.TotalKwh )
				return true;
			else
				return false;
		}

        public static bool CompareUsage(Usage oldUsage, Usage newUsage)
        {
            if (DateRangeFactory.IsSameDate(oldUsage.EndDate, newUsage.EndDate) && DateRangeFactory.IsSameDate(oldUsage.BeginDate, newUsage.BeginDate) && oldUsage.TotalKwh == newUsage.TotalKwh)
                return true;
            else
                return false;
        }

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns 0 if there are no differences -or- match (same record) with the item that needs to be updated: -1 = previous record, 1 = current record (i.e. item1)
		/// </summary>
		/// <param name="existingUsage"></param>
		/// <param name="newUsage"></param>
		/// <returns></returns>
		/// <remarks>The precedence for determining which meter reads are "more reliable" is as follows: Billed, Historical & UtilityEstimate</remarks>
		public static Int16 ComparaMeterReads( Usage item1, DateTime end, Int32 kwh )
		{
			//sort order determines hierarchy: update consolidated record + delete the non-consolidated one
			if( DateRangeFactory.IsSameDate( item1.EndDate, end ) && item1.TotalKwh == kwh )
			{
				if( item1.ID == null )
					return 1;
				else
					return -1;
			}

			return 0;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Overloaded method that returns 0 if there are no differences -or- match (same record) with the item that needs to be updated: -1 = previous record, 1 = current record (i.e. item1)
		/// </summary>
		/// <param name="existingUsage"></param>
		/// <param name="newUsage"></param>
		/// <returns></returns>
		/// <remarks>The precedence for determining which meter reads are "more reliable" is as follows: Billed, Historical & UtilityEstimate</remarks>
		public static Int16 ComparaMeterReads( Usage item1, DateTime end, Int32 kwh, string meter )
		{
			//sort order determines hierarchy: update consolidated record + delete the non-consolidated one
			if( DateRangeFactory.IsSameDate( item1.EndDate, end ) && item1.TotalKwh == kwh && item1.MeterNumber == meter )
			{
				if( item1.ID == null )
					return 1;
				else
					return -1;
			}

			return 0;
		}


        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Takes in a usage list and returns the annual usage based on a prorated 365 date range
        /// </summary>
        /// <param name="list"></param>
        /// <param name="multipleMeters"</param>
        /// <returns></returns>
        public static double ComputeAnnualUsage(UsageList usageList)
        {
            double usage = 0;
            usage = UsageFactory.GetAnnualUsage(usageList);
            return usage;
        }





		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Takes in a usage list and returns the annual usage based on a prorated 365 date range
		/// </summary>
		/// <param name="list"></param>
		/// <param name="multipleMeters"</param>
		/// <returns></returns>
		public static double ComputeAnnualUsage( UsageList usageList, bool multipleMeters )
		{
			double usage = 0;
			//usageList = UsageFactory.SortMeterReads( usageList, multipleMeters );
            usageList = UsageFactory.SortMeterForAnuualUsage(usageList, multipleMeters);

			// break up usage list for utilities with multiple meter numbers before calculating the annual usage
			if( multipleMeters )
			{
				UsageList newList = new UsageList();
				string previousM = "yyy";

				foreach( Usage meterRead in usageList )
				{
					if( meterRead.MeterNumber != previousM && previousM != "yyy" )	//new meter-number
					{
						usage += DoTheMath( newList );							// calculate the annual usage..

						newList = new UsageList();
						newList.Add( meterRead );						//first record for this meter-number
					}
					else
						newList.Add( meterRead );								//add record to temporary list

					previousM = meterRead.MeterNumber;
				}

				if( newList != null && newList.Count != 0 )
					usage += DoTheMath( newList );

			}
			else
				usage += DoTheMath( usageList );

			return usage;
		}

		/// <summary>
		/// Takes in a usage list and returns the annual usage based on a prorated 365 date range
		/// </summary>
		/// <param name="list"></param>
		/// <returns></returns>
		private static double DoTheMath( UsageList list )
		{
			double totalKwh = 0;
			double days = 0;
			double annualUsage = 0;

			foreach( Usage item in list )
			{
				totalKwh += item.TotalKwh;
				days += (double) item.Days - 1;									//usage class adds a day
			}

			annualUsage = (totalKwh / (days + 1)) * 365;

			return Math.Round( annualUsage );
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Deletes usage from a usage list that is not within a certain date range
		/// </summary>
		/// <param name="rawList"></param>
		/// <param name="range"></param>
		/// <returns></returns>
		public static UsageList DeleteUsageNotInRange( UsageList rawList, CommonBusiness.CommonHelper.DateRange range )
		{
			UsageList validRange = new UsageList();

			foreach( Usage inRange in rawList )
			{
				if( inRange.EndDate >= range.StartDate )
					validRange.Add( inRange );
			}

			return validRange;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// This method returns a usage list consisting of estimated (external) usage gaps
		/// </summary>
		/// <param name="acctList">List containing gap(s)</param>
		/// <param name="user"></param>
		/// <param name="ratio">Daily profile ratio</param>
		/// <param name="peakProfiles">Peak profile dictionary</param>
		public static UsageList EstimateExternalGap( UsageList acctList, string user, decimal ratio, string profile, string zone )
		{
			UsageList estimatedPeriod = new UsageList();
			DateTime start, end;

			end = acctList[0].EndDate;
			start = end.AddDays( -363 );

			//loop until you determine where the whole begins..
			foreach( Usage list in acctList )
			{
				if( list.UsageType != UsageType.Canceled )
				{
					end = list.BeginDate.AddDays( -1 );
					if( end < start )							//no external gap..
						return estimatedPeriod;
				}
			}

			// ticket 10654
			DateTime tempraryDate = end.AddDays( -32 );

			if( tempraryDate >= start )
			{
				estimatedPeriod = BreakUpExternalMeterRead( start, end, acctList[0], ratio, user, profile, zone );
				return estimatedPeriod;
			}

			//EstimatedPeriod = InsertEstimatedPeriod( meterRead.UtilityCode, accountNumber, meterRead.EndDate, previousBegin, gap, usage, user, meterRead.UsageSource );
			Usage newUsage = new Usage( acctList[0].AccountNumber, acctList[0].UtilityCode, UsageSource.User, UsageType.Estimated, start, end );
			newUsage.CreatedBy = user;
			newUsage.MeterNumber = acctList[0].MeterNumber;
			estimatedPeriod.Add( newUsage );

			//i will now get the daily profiles of the entire usage object (since i don't have a usage list until this point)..
			CommonBusiness.CommonHelper.DateRange range = UsageFiller.GetDateRange( estimatedPeriod );
			PeakProfileDictionary peakProfiles = ProfileFactory.SelectDailyProfiles( estimatedPeriod[0].UtilityCode, profile, zone, range );

			if( peakProfiles.Count - 1 < (range.EndDate - range.StartDate).Days )
				throw new InsufficientProfiledUsageException( "Account " + acctList[0].AccountNumber + " from " + acctList[0].UtilityCode + " doesn�t have sufficient profiles in order to fill in the external gaps from " + range.StartDate + " to " + range.EndDate + "." );

			//sum up the daily profile values for the gap..
			decimal dailyUsage = 0;

			for( DateTime date = start; date <= end; date = date.AddDays( 1 ) )
				dailyUsage += peakProfiles[date].DailyValue;

			int usage = Convert.ToInt32( dailyUsage * ratio );

			estimatedPeriod[0].TotalKwh = usage;

			UpdateSingleDayMeters( estimatedPeriod );							// 1-2732991

			return estimatedPeriod;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Takes a bigass (external) period and breaks it up into months (calendarized)
		/// </summary>
		/// <param name="start"></param>
		/// <param name="end"></param>
		/// <param name="meterRead"></param>
		/// <param name="ratio"></param>
		/// <param name="user"></param>
		/// <param name="profile"></param>
		/// <param name="zone"></param>
		/// <returns> Returns an estimated usage list </returns>
		internal static UsageList BreakUpExternalMeterRead( DateTime start, DateTime end, Usage meterRead, decimal ratio, string user, string profile, string zone )
		{
			UsageList estimatedPeriod = new UsageList();
			UsageList list;
			Usage newUsage;
			CommonBusiness.CommonHelper.DateRange range;
			PeakProfileDictionary peakProfiles;
			decimal dailyUsage = 0;
			int usage = 0, cnt = 0;

			// get me the last day of the month..
			DateTime dtTo = start;

			dtTo = dtTo.AddMonths( 1 );
			dtTo = dtTo.AddDays( -(dtTo.Day) );

			while( dtTo <= end )
			{
				list = new UsageList();
				newUsage = new Usage( meterRead.AccountNumber, meterRead.UtilityCode, UsageSource.User, UsageType.Estimated, start, dtTo );
				newUsage.CreatedBy = user;
				newUsage.MeterNumber = meterRead.MeterNumber;
				list.Add( newUsage );

				//i will now get the daily profiles of the entire usage object (since i don't have a usage list until this point)..
				range = UsageFiller.GetDateRange( list );
				peakProfiles = ProfileFactory.SelectDailyProfiles( list[0].UtilityCode, profile, zone, range );

				if( peakProfiles.Count - 1 < (range.EndDate - range.StartDate).Days )
					throw new InsufficientProfiledUsageException( "Account " + meterRead.AccountNumber + " from " + meterRead.UtilityCode + " doesn�t have sufficient profiles in order to fill in the external gaps from " + range.StartDate + " to " + range.EndDate + "." );

				//sum up the daily profile values for the gap..
				for( DateTime date = start; date <= dtTo; date = date.AddDays( 1 ) )
					dailyUsage += peakProfiles[date].DailyValue;

				usage = Convert.ToInt32( dailyUsage * ratio );

				list[0].TotalKwh = usage;
				estimatedPeriod.Add( newUsage );

				// does last (internal) gap-day coincide in the end of the gap?
				if( DateRangeFactory.IsSameDate( dtTo, end ) )
					return estimatedPeriod;

				// keep going..
				cnt += 1;
				start = dtTo.AddDays( 1 );
				dtTo = start;
				dtTo = dtTo.AddMonths( 1 );
				dtTo = dtTo.AddDays( -(dtTo.Day) );
				dailyUsage = 0;
			}

			list = new UsageList();
			newUsage = new Usage( meterRead.AccountNumber, meterRead.UtilityCode, UsageSource.User, UsageType.Estimated, start, end );
			newUsage.CreatedBy = user;
			newUsage.MeterNumber = meterRead.MeterNumber;
			list.Add( newUsage );

			//i will now get the daily profiles of the entire usage object (since i don't have a usage list until this point)..
			range = UsageFiller.GetDateRange( list );
			peakProfiles = ProfileFactory.SelectDailyProfiles( list[0].UtilityCode, profile, zone, range );

			if( peakProfiles.Count - 1 < (range.EndDate - range.StartDate).Days )
				throw new InsufficientProfiledUsageException( "Account " + meterRead.AccountNumber + " from " + meterRead.UtilityCode + " doesn�t have sufficient profiles in order to fill in the external gaps from " + range.StartDate + " to " + range.EndDate + "." );

			//sum up the daily profile values for the gap..
			for( DateTime date = start; date <= end; date = date.AddDays( 1 ) )
				dailyUsage += peakProfiles[date].DailyValue;

			usage = Convert.ToInt32( dailyUsage * ratio );

			list[0].TotalKwh = usage;
			estimatedPeriod.Add( newUsage );

			UpdateSingleDayMeters( estimatedPeriod );							// 1-2732991

			return estimatedPeriod;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// This method returns a usage list consisting of estimated (internal) usage gaps
		/// </summary>
		/// <param name="acctList">List containing gap(s)</param>
		/// <param name="user"></param>
		/// <param name="ratio">Daily profile ratio</param>
		/// <param name="peakProfiles">Peak profile dictionary</param>
		public static UsageList EstimateInternalGap( UsageList acctList, string user, decimal ratio, PeakProfileDictionary peakProfiles )
		{
			//Dim acctUsageList As UsageList = UsageFactory.GetAccountUsage(AccountNumber) '09/16/2008 
			DateTime previousBegin = DateTime.MinValue, previousEnd = DateTime.MinValue;
			Usage newUsage;
			UsageList estimatedPeriod = new UsageList();
			UsageList zeroUsageList = new UsageList();

			foreach( Usage meterRead in acctList )
			{
				if( !((previousBegin == DateTime.MinValue) | meterRead.UsageType == UsageType.Canceled) || (meterRead.TotalKwh == 0 && meterRead.UsageType != UsageType.Canceled) )	//skip record
				{
					// handle zero meter read
					if( meterRead.TotalKwh == 0 )
					{
						//sum up the daily profile values for the gap..
						decimal dailyUsage = 0;

						DateTime start;
						DateTime end;

						start = meterRead.BeginDate;
						end = meterRead.EndDate;

						for( DateTime date = start; date <= end; date = date.AddDays( 1 ) )
							dailyUsage += peakProfiles[date].DailyValue;

						int usage = Convert.ToInt32( dailyUsage * ratio );

						//EstimatedPeriod = InsertEstimatedPeriod( meterRead.UtilityCode, accountNumber, meterRead.EndDate, previousBegin, gap, usage, user, meterRead.UsageSource );
						newUsage = new Usage( meterRead.AccountNumber, meterRead.UtilityCode, UsageSource.User, UsageType.Estimated, start, end, usage );
						newUsage.MeterNumber = meterRead.MeterNumber;
						newUsage.CreatedBy = user;

						// ticket 12401 - :-# (1/12/10)
						DateTime temporaryDate = start.AddDays( 32 );

						if( temporaryDate <= end )
						{
							BreakUpInternalMeterRead( end, newUsage, peakProfiles, ratio, estimatedPeriod, user, false, previousBegin, previousEnd );
						}
						else
							estimatedPeriod.Add( newUsage );

						// keep track of zero usage reads for deletion later.
						// * can't remove from list during loop
						zeroUsageList.Add( meterRead );
					}

					// handle gap
					if( meterRead.EndDate != previousBegin && meterRead.EndDate.AddDays( 1 ) != previousBegin && previousBegin != DateTime.MinValue )
					{
						//sum up the daily profile values for the gap..
						decimal dailyUsage = 0;

						DateTime start;
						DateTime end;

						//always calculate gaps by retrieving the inner range of days (i.e. no double-dipping)
						start = meterRead.EndDate.AddDays( 1 );
						end = previousBegin.AddDays( -1 );

						// ticket 10654
						DateTime temporaryDate = start.AddDays( 32 );

						if( temporaryDate <= end )
						{
							BreakUpInternalMeterRead( end, meterRead, peakProfiles, ratio, estimatedPeriod, user, true, previousBegin, previousEnd );
						}
						else
						{
							for( DateTime date = start; date <= end; date = date.AddDays( 1 ) )
								dailyUsage += peakProfiles[date].DailyValue;

							int usage = Convert.ToInt32( dailyUsage * ratio );

							//EstimatedPeriod = InsertEstimatedPeriod( meterRead.UtilityCode, accountNumber, meterRead.EndDate, previousBegin, gap, usage, user, meterRead.UsageSource );
							newUsage = new Usage( meterRead.AccountNumber, meterRead.UtilityCode, UsageSource.User, UsageType.Estimated, start, end, usage );
							newUsage.CreatedBy = user;
							newUsage.MeterNumber = meterRead.MeterNumber;
							estimatedPeriod.Add( newUsage );
						}

					}
				}

				if( meterRead.UsageType != UsageType.Canceled )
				{
					previousBegin = meterRead.BeginDate;
					previousEnd = meterRead.EndDate;
				}
			}

			// remove any zero meter reads from list, they have been estimated and added to estimatedPeriod
			foreach( Usage usage in zeroUsageList )
				acctList.Remove( usage );

			UpdateSingleDayMeters( estimatedPeriod );							// 1-2732991

			//acctList.AddRange( EstimatedPeriod );
			return estimatedPeriod;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Check whether there are any single meter read dates and adds a date to the end-date if it finds one - 1-2732991
		/// Assumption: works for estimated usage list..
		/// </summary>
		/// <param name="estimatedPeriod">usage list</param>
		private static void UpdateSingleDayMeters( UsageList meterReads )
		{
			IEnumerable<Usage> remove = from t in meterReads
										where t.BeginDate == t.EndDate
										select t;

			if( remove.Count() > 0 )
			{
				foreach( Usage delete in remove )
				{
					foreach( Usage meter in meterReads )
					{
						if( delete.BeginDate == meter.BeginDate && delete.EndDate == meter.EndDate )
							meter.EndDate = meter.EndDate.AddDays( 1 );
					}
				}
			}
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Take a bigass period and break it up into months (calendarized)
		/// </summary>
		/// <param name="end"></param>
		/// <param name="meterRead"></param>
		/// <param name="peakProfiles"></param>
		/// <param name="ratio"></param>
		/// <param name="estimatedPeriod"></param>
		/// <param name="user"></param>
		internal static void BreakUpInternalMeterRead( DateTime end, Usage meterRead, PeakProfileDictionary peakProfiles,
			decimal ratio, UsageList estimatedPeriod, string user, bool isGap, DateTime previousBegin, DateTime previousEnd )
		{
			Usage newUsage;
			DateTime start;
			decimal dailyUsage = 0;
			int usage = 0;

			if( !isGap )			//no whole..
				start = meterRead.BeginDate;
			else
				start = meterRead.EndDate.AddDays( 1 );

			if( DateRangeFactory.IsSameDate( meterRead.EndDate, previousBegin ) )
				end = end.AddDays( -1 );

			// get me the last day of the month..
			DateTime dtTo = start;

			dtTo = dtTo.AddMonths( 1 );
			dtTo = dtTo.AddDays( -(dtTo.Day) );

			while( dtTo <= end )
			{
				for( DateTime date = start; date <= dtTo; date = date.AddDays( 1 ) )
					dailyUsage += peakProfiles[date].DailyValue;

				usage = Convert.ToInt32( dailyUsage * ratio );

				newUsage = new Usage( meterRead.AccountNumber, meterRead.UtilityCode, UsageSource.User, UsageType.Estimated, start, dtTo, usage );
				newUsage.MeterNumber = meterRead.MeterNumber;
				newUsage.CreatedBy = user;

				if( start <= dtTo )
					estimatedPeriod.Add( newUsage );

				// does last (internal) gap-day coincide in the end of the gap?
				if( DateRangeFactory.IsSameDate( dtTo, end ) )
					return;

				// keep going..
				start = dtTo.AddDays( 1 );
				dtTo = start;
				dtTo = dtTo.AddMonths( 1 );
				dtTo = dtTo.AddDays( -(dtTo.Day) );
				dailyUsage = 0;
			}

			for( DateTime date = start; date <= end; date = date.AddDays( 1 ) )
				dailyUsage += peakProfiles[date].DailyValue;

			usage = Convert.ToInt32( dailyUsage * ratio );

			newUsage = new Usage( meterRead.AccountNumber, meterRead.UtilityCode, UsageSource.User, UsageType.Estimated, start, end, usage );
			newUsage.MeterNumber = meterRead.MeterNumber;
			newUsage.CreatedBy = user;

			if( start <= end )
				estimatedPeriod.Add( newUsage );

			UpdateSingleDayMeters( estimatedPeriod );							// 1-2732991
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Determines what the 364 day window is..
		/// </summary>
		/// <param name="acctUsageList"></param>
		/// <param name="day1"></param>
		/// <param name="day2"></param>
		/// <remarks>This method expects a sorted list and returns a date range of at least 364 days</remarks>
		public static CommonBusiness.CommonHelper.DateRange Get364DateRange( UsageList acctUsageList )
		{
			//determine what the 364 day window is..
			DateTime day1 = DateTime.MinValue, day2 = DateTime.MinValue, end;

			day2 = acctUsageList[0].EndDate;
			end = day2.AddDays( -363 );

			//loop until you find the date range..
			foreach( Usage list in acctUsageList )
			{
				if( list.EndDate >= end & list.UsageType != UsageType.Canceled )
					day1 = list.BeginDate;
				else
					break;
			}

			//if we dodn't have 364 days worth of (metered) usage then pick the last meter read as the 2nd parameter..
			if( day1 >= end )
				day1 = end;

			CommonBusiness.CommonHelper.DateRange range = new CommonBusiness.CommonHelper.DateRange( day1, day2 );
			return range;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Similar to Get364DateRange but this one determines the date range of all the meter reads in the usage object
		/// </summary>
		/// <param name="acctUsageList"></param>
		/// <returns></returns>
		/// <remarks>This method expects a sorted list</remarks>
		public static CommonBusiness.CommonHelper.DateRange GetDateRange( UsageList acctUsageList )
		{
			DateTime day1 = DateTime.MinValue, day2 = DateTime.MinValue;

			day2 = acctUsageList[0].EndDate;

			foreach( Usage list in acctUsageList )
			{
				if( list.UsageType != UsageType.Canceled )
					day1 = list.BeginDate;
			}

			CommonBusiness.CommonHelper.DateRange range = new CommonBusiness.CommonHelper.DateRange( day1, day2 );
			return range;
		}


		// April 2010
		// ------------------------------------------------------------------------------------
		internal static UsageList GetEdiUsageByOffer( string offerID, string utility, DateTime from, DateTime to )
		{
			UsageList list = new UsageList();

			list = EdiMeterReadFactory.GetListByOffer( offerID, utility, from, to );
			return list;
		}

		// April 2010
		// ------------------------------------------------------------------------------------
        internal static UsageList GetEdiUsage(string accountNumber, string utility, DateTime from, DateTime to)
        {
            UsageList list = new UsageList();
            try
            {
                list = EdiMeterReadFactory.GetList(accountNumber, utility, from, to);
                return list;
            }
            catch (Exception) { throw; }
        }

		internal static UsageList GetEdiUsage( string accountNumber, string utility, DateTime from, DateTime to, bool forUsageConsolidation )
		{
			UsageList list = new UsageList();

			list = EdiMeterReadFactory.GetList( accountNumber, utility, from, to, forUsageConsolidation );
			return list;
		}

		// ------------------------------------------------------------------------------------
		internal static UsageList GetIstaBilledUsageByOffer( string offerID, string utility, DateTime from, DateTime to )
		{
			UsageList list = new UsageList();

			list = IstaMeterReadFactory.GetListByOffer( offerID, utility, from, to );
			return list;
		}

		// ------------------------------------------------------------------------------------
		internal static UsageList GetIstaBilledUsage( string accountNumber, string utility, DateTime from, DateTime to )
		{
			UsageList list = new UsageList();
            try
            {
                list = IstaMeterReadFactory.GetList(accountNumber, utility, from, to);
            }
            catch (Exception) { throw; }
			return list;
		}

		internal static UsageList GetFileUsageByOffer( string offerID, string utility, DateTime from, DateTime to )
		{
			UsageList list = new UsageList();

			list = FileMeterReadFactory.GetListByOffer( offerID, utility, from, to );
			return list;
		}

		internal static UsageList GetFileUsage( string accountNumber, string utility, DateTime from, DateTime to )
		{
			UsageList list = new UsageList();
            try
            {
                list = FileMeterReadFactory.GetList(accountNumber, utility, from, to);
            }
            catch (Exception) { throw; }
			return list;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Given a list of existing and new (raw) records this method returns whatever is new (i.e. in rawUsage but not in consolidated)
		/// </summary>
		/// <param name="consolidated"></param>
		/// <param name="legacyUsage"></param>
		/// <returns></returns>
		public static UsageList GetNewRawUsage( UsageList consolidated, UsageList rawUsage )
		{
			UsageList cleanList = new UsageList();

			consolidated.Sort( UsageFactory.SortUsage );

			if( consolidated != null && consolidated.Count != 0 )
			{
				if( rawUsage != null && rawUsage.Count != 0 )
				{
					foreach( Usage newU in rawUsage )							//for each new meter read check if it already exists..
					{
						int lastRow = 0;

						foreach( Usage oldU in consolidated )
						{
							lastRow++;
							//let cancels make it to the consolidated table..
							if( oldU.BeginDate >= newU.BeginDate && newU.UsageType != UsageType.Canceled && oldU.IsActive != 0 )
							{
								if( ComparaUsage( oldU, newU ) )				//record already exists; keep going..
									break;
								else
								{
									//if this is the last record and the row hasn't been found then append to list..
									if( consolidated.Count == lastRow )
										cleanList.Add( newU );
									continue;									//keep going..
								}
							}
							else
							{
								//since we are expecting a sorted list then i can assume that this record was not found..
								cleanList.Add( newU );
								break;											//next..
							}
						}
					}
				}
			}
			else
				cleanList = rawUsage;											//only new records available..

			return cleanList;
		}

		// ------------------------------------------------------------------------------------
		internal static UsageList GetScrapedUsageByOffer( string offerID, string utility, DateTime from, DateTime to, bool isEnrolled )
		{
			UsageList list = new UsageList();

			list = ScraperFactory.GetListByOffer( offerID, utility, from, to, isEnrolled );

			return list;
		}

		// ------------------------------------------------------------------------------------
		internal static UsageList GetScrapedUsage( string accountNumber, string utility, DateTime from, DateTime to, bool isEnrolled )
		{
			UsageList list = new UsageList();
            try
            {
                list = ScraperFactory.GetList(accountNumber, utility, from, to, isEnrolled);
                return list;
            }
            catch (Exception) { throw; }
		}

		internal static UsageList GetScrapedUsage( string accountNumber, string utility, DateTime from, DateTime to, bool isEnrolled, bool forUsageConsolidation )
		{
			UsageList list = new UsageList();
			list = ScraperFactory.GetList( accountNumber, utility, from, to, isEnrolled, forUsageConsolidation );

			return list;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Determines the ratio that will be used in order to fill in the gaps
		/// </summary>
		/// <param name="usageList"></param>
		/// <param name="peakProfiles"></param>
		/// <returns>Returns the ratio which is the sum of the known historical usage divided by the corresponding sum of daily profiles</returns>
		public static decimal GetRatio( UsageList usageList, PeakProfileDictionary peakProfiles, CommonBusiness.CommonHelper.DateRange range )
		{
			decimal dailyUsage = 0, monthlyUsage = 0;
			DateTime previousDate = DateTime.MinValue;

			foreach( Usage cycle in usageList )
			{
				if( cycle.BeginDate >= range.StartDate & cycle.EndDate <= range.EndDate & (cycle.UsageType != UsageType.Estimated && cycle.UsageType != UsageType.Canceled) )
				{
					monthlyUsage += cycle.TotalKwh;
					for( DateTime date = cycle.BeginDate; date <= cycle.EndDate; date = date.AddDays( 1 ) )
					{
						if( previousDate != date )								//no double dipping (between periods)..
							dailyUsage += peakProfiles[date].DailyValue;
					}
					previousDate = cycle.BeginDate;
				}
				else
					continue;
			}
			if( dailyUsage == 0 )
				throw new InsufficientUsageException( "Usage cannot be zero when calculating ratio" );

			return (monthlyUsage / dailyUsage);
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Given a Usage List, this method will return a list of usages that have not been consolidated
		/// </summary>
		/// <param name="semiConsolidated"></param>
		/// <returns></returns>
		public static UsageList NotConsolidated( UsageList semiConsolidated )
		{
			UsageList list = new UsageList();

			foreach( Usage usage in semiConsolidated )
			{
				if( usage.ID == null )
					list.Add( usage );
			}

			return list;
		}

		public static UsageList removeLingeringInactiveOptimized( IEnumerable<Usage> dirty )
		{
			UsageList list = new UsageList();

			foreach( Usage usage in dirty )
			{
				if( usage.IsActive == 1 )
					list.Add( usage );
			}

			return list;
		}

		// ------------------------------------------------------------------------------------
		public static UsageList removeLingeringInactive( UsageList dirty )
		{
			UsageList list = new UsageList();

			foreach( Usage usage in dirty )
			{
				if( usage.IsActive == 1 )
					list.Add( usage );
			}

			return list;
		}

		// ------------------------------------------------------------------------------------
		private static void UpdateConsolidatedWithRaw( UsageList list, int idx, bool isConsolidated, long? Id )
		{
			list[idx].ReasonCode = ReasonCode.UpdatedSourceTypeFromRaw;
			list[idx].IsConsolidated = isConsolidated;

			if( Id != null )
				UsageFactory.UpdateUsageRecord( list[idx], Id );
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Marks matching Cancel meter reads as Invalid in the database
		/// Deactivating the consolidated read which corresponds to the incoming cancelled and removes the incoming and consolidated reads from the usageListk
		/// </summary>
		/// <param name="usageList"></param>
		public static UsageList HandleCancels( UsageList usageList, string userName )
		{
			UsageList newList = new UsageList();
			Int16 outerLoop = 0, innerLoop;
			int[] record = new int[15];
			int removeAt = 0, resize = 0;

			foreach( Usage cycle in usageList )
			{
				if( cycle.UsageType == UsageType.Canceled )
				{
					innerLoop = 0;
					cycle.IsActive = 0;

					foreach( Usage loop in usageList )
					{
						if( DateRangeFactory.IsSameDate( cycle.BeginDate, loop.BeginDate ) && ComparaUsage( loop, cycle ) && loop.UsageType != UsageType.Canceled )
						{
							loop.IsActive = 0;
							loop.ReasonCode = ReasonCode.ReceivedCancel;

							if( loop.IsConsolidated == true )
								UsageFactory.UpdateUsageRecord( loop );

							record[removeAt] = innerLoop;						// remove meter-read being canceled
							removeAt++;
							resize++;

							if( resize > 14 )
							{ resize = 0; Array.Resize( ref record, record.GetUpperBound( 0 ) + 16 ); }
						}
						innerLoop++;
					}

					record[removeAt] = outerLoop;								// remove cancels
					removeAt++;
					resize++;

					if( resize > 14 )
					{ resize = 0; Array.Resize( ref record, record.GetUpperBound( 0 ) + 16 ); }
				}

				newList.Add( cycle );
				outerLoop++;
			}

			if( removeAt != 0 )
			{
				int[] remove = new int[removeAt];

				for( int cnt = 0; cnt <= removeAt - 1; cnt++ )
					remove[cnt] = record[cnt];

				Array.Sort( remove );

				for( int cnt = removeAt - 1; cnt >= 0; cnt-- )
					newList.RemoveAt( remove[cnt] );

			}

			return newList;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Determines if the usage is less than one year's worth..
		/// </summary>
		/// <param name="acctUsageList"></param>
		/// <param name="day1"></param>
		/// <param name="day2"></param>
		/// <remarks>This method expects a sorted list and returns true (there is enough data) or false (otherwise)</remarks>
		public static bool IsThereAnExternalGap( UsageList acctUsageList )
		{
			//determine what the 364 day window is..
			DateTime start, end = DateTime.MinValue;

			end = acctUsageList[0].EndDate;
			start = end.AddDays( -364 );

			//loop until you determine whether we have enough usage..
			foreach( Usage list in acctUsageList )
			{
				if( start >= list.BeginDate & list.UsageType != UsageType.Canceled )
					return false;
			}

			//if we don't have 364 days worth of (metered) usage then return true..
			return true;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// This method determines if there is a gap
		/// </summary>
		/// <param name="acctUsageList"></param>
		/// <returns>Returns true if there is an internal (account) gap</returns>
		public static bool IsThereAnInternalGap( UsageList acctUsageList )
		{
			DateTime previousBegin = DateTime.MinValue;

			if( HasZeroUsageMeterRead( acctUsageList ) && !HasZeroTotalUsage( acctUsageList ) )
				return true;

			foreach( Usage meterRead in acctUsageList )
			{
				//skip record
				if( !((previousBegin == DateTime.MinValue) | meterRead.UsageType == UsageType.Canceled) )	//skip record
				{
					//bad period
					if( meterRead.EndDate != previousBegin & meterRead.EndDate.AddDays( 1 ) != previousBegin )
						return true;
				}

				if( meterRead.UsageType != UsageType.Canceled )
					previousBegin = meterRead.BeginDate;
			}

			return false;
		}

		/// <summary>
		/// Determines if there is zero usage for list
		/// </summary>
		/// <param name="acctUsageList">Usage list</param>
		/// <returns>Returns true if total usage is zero, otherwise returns false.</returns>
		private static bool HasZeroTotalUsage( UsageList acctUsageList )
		{
			int totalUsage = 0;

			foreach( Usage meterRead in acctUsageList )
				totalUsage += meterRead.TotalKwh;

			return totalUsage == 0;
		}

		private static bool HasZeroUsageMeterRead( UsageList acctUsageList )
		{
			foreach( Usage meterRead in acctUsageList )
			{
				if( meterRead.TotalKwh == 0 )
					return true;
			}

			return false;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Given a list this method eliminates duplite records
		/// </summary>
		/// <param name="dirtyList"></param>
		/// <returns></returns>
		/// <remarks>This method matches records by begin/end dates + kwh so if we have two identical
		/// meter reads then the one that has more hierarchy will prevail.</remarks>
		public static UsageList HandleDuplicates( UsageList dirtyList, bool multipleMeters )
		{
			UsageList cleanList = new UsageList();
			int[] record = new int[15];
			int removeAt = 0, resize = 0;
			Int16 dirtyRow = 0, returnValue = 0;
			DateTime previousBegin = DateTime.MinValue, previousEnd = DateTime.MinValue;
			Int32 previousKwh = 0;
			string previousMeter = "";

			foreach( Usage dirty in dirtyList )									//loop through dirty list to see if record exists..
			{
				cleanList.Add( dirty );
				if( previousBegin != DateTime.MinValue )
				{
					if( DateRangeFactory.IsSameDate( previousBegin, dirty.BeginDate ) )
					{
						if( multipleMeters )
							returnValue = ComparaMeterReads( dirty, previousEnd, previousKwh, previousMeter );
						else
							returnValue = ComparaMeterReads( dirty, previousEnd, previousKwh );

						if( returnValue == 1 )									//update previous, remove dirty..
						{
							//don't make unnecessary updates..
							if( cleanList[dirtyRow - 1].UsageSource != dirty.UsageSource && cleanList[dirtyRow - 1].UsageType != dirty.UsageType )
								UpdateConsolidatedWithRaw( cleanList, dirtyRow, cleanList[dirtyRow - 1].IsConsolidated, cleanList[dirtyRow - 1].ID );

							record[removeAt] = dirtyRow;
							removeAt++;
							resize++;

							if( resize > 14 )
							{ resize = 0; Array.Resize( ref record, record.GetUpperBound( 0 ) + 16 ); }
						}
						else if( returnValue == -1 )							//update dirty, remove previous..
						{
							//don't make expensive updates..
							if( dirty.UsageSource != cleanList[dirtyRow - 1].UsageSource && dirty.UsageType != cleanList[dirtyRow - 1].UsageType )
							{
								//update current record's ut/us with previous record's data (since it has precedence)..
								dirty.UsageSource = cleanList[dirtyRow - 1].UsageSource;
								dirty.UsageType = cleanList[dirtyRow - 1].UsageType;

								UpdateConsolidatedWithRaw( cleanList, dirtyRow - 1, dirty.IsConsolidated, dirty.ID );
							}

							record[removeAt] = (dirtyRow - 1);
							removeAt++;
							resize++;

							if( resize > 14 )
							{ resize = 0; Array.Resize( ref record, record.GetUpperBound( 0 ) + 16 ); }
						}
					}
				}

				dirtyRow++;
				if( returnValue != 1 )
				{
					//keep last (valid) record in the buffer..
					previousBegin = dirty.BeginDate;
					previousEnd = dirty.EndDate;
					previousKwh = dirty.TotalKwh;
					previousMeter = dirty.MeterNumber;
				}
				returnValue = 0;
			}

			if( removeAt != 0 )
			{
				int[] remove = new int[removeAt];

				for( int cnt = 0; cnt <= removeAt - 1; cnt++ )
					remove[cnt] = record[cnt];

				Array.Sort( remove );

				for( int cnt = removeAt - 1; cnt >= 0; cnt-- )
					cleanList.RemoveAt( remove[cnt] );

			}

			return cleanList;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// This procedure validates (removes) invalid -or- duplicate usage gotten from the disparate sources
		/// </summary>
		/// <param name="acctUsageList"></param>
		/// <remarks>This procedure expects a sorted (descending based on begin meter read) list of Usage 
		/// (i.e. use the built in sort method passing SortMeterReads as a parameter)</remarks>
		public static UsageList ValidateUsage( UsageList acctUsageList, string user, bool multipleMeters )
		{
			System.DateTime previousEnd = DateTime.MinValue;
			System.DateTime previousBegin = default( System.DateTime );
			UsageSource previousSource = UsageSource.User;
			bool sameMeter;														// for those utilities w/multiple meters..
			UsageList newList = new UsageList();
			ReasonCode reason = ReasonCode.InitialLoad;

			//since we are no longer using invalid usage types we need to remove the invalid records from the newList
			int[] record = new int[15];
			int removeAt = 0, resize = 0;
			string previousM = "";
			Int16 dirtyRow = 0;

			foreach( Usage meterRead in acctUsageList )
			{
				newList.Add( meterRead );
				sameMeter = multipleMeters == true ? meterRead.MeterNumber == previousM : true;

				if( !(previousEnd == DateTime.MinValue) && (sameMeter) )		//skip record
				{
					//current start period > last end period
					if( meterRead.BeginDate > previousEnd )
						reason = ReasonCode.ExceptionBetweenDifferentMeterReads;	// don't think this will ever execute..?

					//new end date > last start period
					if( meterRead.EndDate > previousBegin )
						reason = ReasonCode.EndDateGreaterThanPreviousBegin;

					//same end date (different periods)
					if( DateRangeFactory.IsSameDate( previousEnd, meterRead.EndDate ) )
						reason = ReasonCode.SameEndBetweenDifferentMeterReads;

					//same begin date (different periods)
					if( DateRangeFactory.IsSameDate( previousBegin, meterRead.BeginDate ) )
						reason = ReasonCode.SameBeginBetweenDifferentMeterReads;
				}

				//current start period = current end period
				if( DateRangeFactory.IsSameDate( meterRead.EndDate, meterRead.BeginDate ) )
					reason = ReasonCode.BeginDateEqualEndDate;

				//usage cannot be less than zero..
				if( meterRead.TotalKwh < 0 )
					reason = ReasonCode.NegativeUsage;

				//new end date < current start period
				if( meterRead.EndDate < meterRead.BeginDate )
					reason = ReasonCode.EndDateLessThanBeginDate;
                // Due to the idea of linked account in account_number_history
                if(meterRead.MeterNumber!=previousM)
                    reason = ReasonCode.InitialLoad;

				//fix then keep last record in buffer
				if( reason != ReasonCode.InitialLoad )
				{
					//					meterRead.IsActive = 0;
					meterRead.ReasonCode = reason;
					record[removeAt] = dirtyRow;

					removeAt++;
					resize++;

					if( resize > 14 )
					{ resize = 0; Array.Resize( ref record, record.GetUpperBound( 0 ) + 16 ); }
				}

				dirtyRow++;
				if( reason == ReasonCode.InitialLoad )
				{
					previousEnd = meterRead.EndDate;
					previousBegin = meterRead.BeginDate;
					previousSource = meterRead.UsageSource;
					previousM = meterRead.MeterNumber;
				}
				reason = ReasonCode.InitialLoad;
			}

			if( removeAt != 0 )
			{
				int[] remove = new int[removeAt];

				for( int cnt = 0; cnt <= removeAt - 1; cnt++ )
					remove[cnt] = record[cnt];

				int idx = 0;
				Array.Sort( remove );

				for( int cnt = removeAt - 1; cnt >= 0; cnt-- )
				{
					idx = remove[cnt];

					if( newList[idx].ID != null && acctUsageList[idx].IsActive != 0 )
					{
						newList[idx].IsActive = 0;
						UsageFactory.UpdateUsageRecord( newList[idx] );
					}

					newList.RemoveAt( idx );
				}
			}

			return newList;
		}

	}
}
