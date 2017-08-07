using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using System.Data;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    /// <summary>
    /// This is the factory for ScheduledMeterRead instances. It retrieves utility 
    /// scheduled meter read information.
    /// </summary>
    /// <remarks>This class is a classical factory sealed class. Cannot be inherited or
    /// instantiated and its members returning BillingCycle instances are all static.</remarks>
    public static class MeterReadScheduleFactory
    {
        #region Public Members

        /// <summary>
        /// Returns a list of all scheduled meter reads found for the given utility.
        /// </summary>
        /// <param name="utilityCode">The Utility identifier.</param>
        /// <returns>A ScheduleMeterReadList of all scheduled meter reads for the given utility.</returns>
        public static MeterReadScheduleList GetList( string utilityCode )
        {
            DataSet ds = MeterReadCalendarSql.GetScheduledMeterReads( utilityCode );
            return MeterReadScheduleFactory.GetList( ds );
        }

        public static DataSet GetMeterReadsByFilter( string queryString )
        {
            return MeterReadCalendarSql.GetMeterReadsByFilter( queryString );
        }

        public static void InsertMeterReadCalendar( DateTime startDate, string utility, string groupId, DateTime readDate )
        {
            int calendarYear = 0;
            int calendarMonth = 0;

            calendarYear = startDate.Year;
            calendarMonth = startDate.Month;

            MeterReadCalendarSql.InsertMeterReadCalendar( calendarYear, calendarMonth, utility, groupId, readDate );
        }

        /// <summary>
        /// Returns all meter read data from the lp_common.meter_read_calendar table
        /// </summary>
        public static DataSet GetAllMeterReads()
        {
            return MeterReadCalendarSql.GetAllMeterReads();
        }

        public static void UpdateMeterReadCalendar( int calendarYear, int calendarMonth, string utility, string groupId, DateTime readDate, string oldData )
        {
            string[] oldDataArray = oldData.Split( ':' );
            string oldUtility = string.Empty;
            string oldGroupId = string.Empty;
            string oldReadDate = string.Empty;

            oldUtility = oldDataArray[2];
            oldGroupId = oldDataArray[3];
            oldReadDate = oldDataArray[4];

            MeterReadCalendarSql.UpdateMeterReadCalendar( calendarYear, calendarMonth, utility, groupId, readDate, oldUtility, oldGroupId, Convert.ToDateTime( oldReadDate ) );

        }

        /// <summary>
        /// Returns a list of all scheduled meter reads found for the given 
        /// utility in the given calendar year.
        /// </summary>
        /// <param name="utilityCode">The code identifying the utility.</param>
        /// <param name="calendarYear">The schedule calendar year.</param>
        /// <returns>A ScheduleMeterReadList of all scheduled meter reads for the given utility
        /// in the given calendar year.</returns>
        public static MeterReadScheduleList GetList( string utilityCode, int calendarYear )
        {
            DataSet ds = MeterReadCalendarSql.GetScheduledMeterReads( utilityCode, calendarYear );
            return MeterReadScheduleFactory.GetList( ds );
        }

        /// <summary>
        /// Returns a list of all scheduled meter reads found for the given 
        /// utility in the given calendar year and month.
        /// </summary>
        /// <param name="utilityCode">The code identifying the utility.</param>
        /// <param name="calendarYear">The billing cycles year.</param>
        /// <param name="calendarMonth">The billing cycles month.</param>
        /// <returns>A MeterReadScheduleList of all scheduled meter reads in the given calendar month.</returns>
        public static MeterReadScheduleList GetList( string utilityCode, int calendarYear, int calendarMonth )
        {
            DataSet ds = MeterReadCalendarSql.GetScheduledMeterReads( utilityCode, calendarYear, calendarMonth );
            return MeterReadScheduleFactory.GetList( ds );
        }

        /// <summary>
        /// Returns the BillingCycle instance of the given utility in the given meter read date.
        /// </summary>
        /// <param name="utilityCode">The code identifying the utility.</param>
        /// <param name="meterReadDate">The meter read date.</param>
        /// <returns>The BillingCycle instance in the given meter read date for the given utility.</returns>
        public static MeterReadScheduleList GetList( string utilityCode, DateTime meterReadDate )
        {
            DataSet ds = MeterReadCalendarSql.GetScheduledMeterReads( utilityCode, meterReadDate );
            return MeterReadScheduleFactory.GetList( ds );
        }

        /// <summary>
        /// Returns the read schedule for the given meter read cycle in the given utility.
        /// </summary>
        /// <param name="utilityCode">The code uniquely identifying the utility.</param>
        /// <param name="readCycleId">The read cycle identifier.</param>
        /// <returns>A ScheduleMeterReadList containing the meter read schedule.</returns>
        public static MeterReadScheduleList GetSchedule( string utilityCode, string readCycleId )
        {
            DataSet ds = MeterReadCalendarSql.GetSchedule( utilityCode, readCycleId );
            return MeterReadScheduleFactory.GetList( ds );
        }

        /// <summary>
        /// Returns the scheduled meter read information for the given utility
        /// and the given calendar year and month and the read cycle identifier.
        /// </summary>
        /// <param name="utilityCode">The code uniquely identifying the utility.</param>
        /// <param name="calendarYear">The billing cycles year.</param>
        /// <param name="calendarMonth">The billing cycles month.</param>
        /// <param name="readCycleId">The read cycle identifier.</param>
        /// <returns>A MeterReadScheduleItem instance containing meter read schedule information for the given parameters.</returns>
        public static MeterReadScheduleItem GetInstance( string utilityCode, int calendarYear, int calendarMonth, string readCycleId )
        {
            MeterReadScheduleItem scheduledRead = null;
            DataSet ds = MeterReadCalendarSql.GetScheduleItem( utilityCode, calendarYear, calendarMonth, readCycleId );

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                scheduledRead = MeterReadScheduleFactory.GetInstance( ds.Tables[0].Rows[0] );
            }

            return scheduledRead;
        }

        #endregion

        #region Private Members

        /// <summary>
        /// Returns the list of scheduled meter reads contained in the given dataset.
        /// </summary>
        /// <param name="ds">The dataset containing the scheduled meter reads.</param>
        /// <returns>A ScheduledMeterReadList of the scheduled meter reads 
        /// extracted from the given dataset.</returns>
        private static MeterReadScheduleList GetList( DataSet ds )
        {
            MeterReadScheduleList list = null;

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    if (list == null)
                    {
                        list = new MeterReadScheduleList();
                    }

                    list.Add( MeterReadScheduleFactory.GetInstance( dr ) );
                }
            }

            return list;
        }

        /// <summary>
        /// Returns an instance of a ScheduledMeterRead with information extracted
        /// from the given data row.
        /// </summary>
        /// <param name="row">The data row containing the scheduled meter read information.</param>
        /// <returns>An instance of the ScheduledMeterRead with information extracted
        /// from the given data row.</returns>
        private static MeterReadScheduleItem GetInstance( DataRow row )
        {
            MeterReadScheduleItem scheduledRead = null;

            if (row != null)
            {
                string utility = (string)row["UtilityCode"];
                int year = (int)row["CalendarYear"];
                int month = (int)row["CalendarMonth"];
                string cycleId = (string)row["ReadCycleId"];
                DateTime read = (DateTime)row["ReadDate"];

                scheduledRead = new MeterReadScheduleItem( utility, year, month, cycleId, read );
            }

            return scheduledRead;
        }

        /// <summary>
        /// Gets the next meter read date based on date, utility, and bill cycle id
        /// </summary>
        /// <param name="date">Start Date of search for next meter read</param>
        /// <param name="utilityCode">Identifier of utility</param>
        /// <param name="readCycleId">Read cycle ID</param>
        /// <returns>MeterReadScheduleItem object</returns>
        public static MeterReadScheduleItem GetNextMeterReadDate( DateTime date, string utilityCode, string readCycleId )
        {
            MeterReadScheduleItem item;
            DataSet ds = MeterReadCalendarSql.GetNextScheduledItem( utilityCode, date, readCycleId );

            if (ds == null || ds.Tables[0] == null || ds.Tables[0].Rows.Count == 0)
            {
                ThrowMeterReadDateNotFoundException( utilityCode, date.Year, date.Month, readCycleId );
            }
            item = GetInstance( ds.Tables[0].Rows[0] );

            return item;
        }

        /// <summary>
        /// Gets the next meter read date based on date, utility, and bill cycle id
        /// </summary>
        /// <param name="date">Start Date of search for next meter read</param>
        /// <param name="utilityCode">Identifier of utility</param>
        /// <param name="readCycleId">Read cycle ID</param>
        /// <param name="accountId">Account ID</param>
        /// <returns>MeterReadScheduleItem object</returns>
        public static MeterReadScheduleItem GetNextMeterReadDate( DateTime date, string utilityCode, string readCycleId, string accountId )
        {
            MeterReadScheduleItem item;
            DataSet ds = MeterReadCalendarSql.GetNextScheduledItem( utilityCode, date, readCycleId );

            //SR1-6949960
            if (ds == null || ds.Tables[0] == null || ds.Tables[0].Rows.Count == 0)
            {
                //    ds = MeterReadCalendarSql.GetNextScheduledItemByAccountId(accountId);
                //    if (ds == null || ds.Tables[0] == null || ds.Tables[0].Rows.Count == 0)
                //    {
                ThrowMeterReadDateNotFoundException( utilityCode, date.Year, date.Month, readCycleId );
                //    }
            }
            item = GetInstance( ds.Tables[0].Rows[0] );

            return item;
        }

        /// <summary>
        /// Gets the next meter read date based on date, utility, and bill cycle id.
        /// This function doesnt throw an exception
        /// </summary>
        /// <param name="date">Start Date of search for next meter read</param>
        /// <param name="utilityCode">Identifier of utility</param>
        /// <param name="readCycleId">Read cycle ID</param>
        /// <param name="accountId">Account ID</param>
        /// <returns>MeterReadScheduleItem object</returns>
        public static MeterReadScheduleItem GetNextMeterReadDateNoThrow( DateTime date, string utilityCode, string readCycleId ) //, out string error )
        {
            MeterReadScheduleItem item = null;
            //error = "";
            DataSet ds = MeterReadCalendarSql.GetNextScheduledItem( utilityCode, date, readCycleId );
            if (ds == null || ds.Tables[0] == null || ds.Tables[0].Rows.Count == 0)
            {
                //string format = "Meter read date not found for Utility {0} Bill cycle ID {1} - {2}/{3}.";
                //error = String.Format( format, utilityCode, readCycleId, date.Month.ToString(), date.Year.ToString() );
            }
            else
            {
                item = GetInstance( ds.Tables[0].Rows[0] );
            }
            return item;
        }


        /// <summary>
        /// Gets the meter read date based on date, utility, and bill cycle id
        /// </summary>
        /// <param name="date">date to base meter read date on</param>
        /// <param name="utilityCode">Identifier of utility</param>
        /// <param name="readCycleId">Read cycle ID</param>
        /// <returns>MeterReadScheduleItem object</returns>
        public static MeterReadScheduleItem GetMeterReadDate( DateTime date,
            string utilityCode, string readCycleId )
        {
            return GetMeterReadDate( date.Year, date.Month, utilityCode, readCycleId );
        }

        /// <summary>
        /// Gets the meter read date based on year, month, utility, and bill cycle id
        /// </summary>
        /// <param name="year">Year of base date</param>
        /// <param name="month">Month of base date</param>
        /// <param name="utilityCode">Identifier of utility</param>
        /// <param name="readCycleId">Read cycle ID</param>
        /// <returns>MeterReadScheduleItem object</returns>
        public static MeterReadScheduleItem GetMeterReadDate( int year, int month,
            string utilityCode, string readCycleId )
        {
            MeterReadScheduleItem item;
            DataSet ds = MeterReadCalendarSql.GetScheduleItem( utilityCode, year, month, readCycleId );

            if (ds == null)
                ThrowMeterReadDateNotFoundException( utilityCode, year, month, readCycleId );
            else if (ds.Tables[0] == null)
                ThrowMeterReadDateNotFoundException( utilityCode, year, month, readCycleId );
            else if (ds.Tables[0].Rows.Count == 0)
                ThrowMeterReadDateNotFoundException( utilityCode, year, month, readCycleId );

            item = GetInstance( ds.Tables[0].Rows[0] );

            return item;
        }

        internal static void ThrowMeterReadDateNotFoundException( string utilityCode,
            int month, int year, string readCycleId )
        {
            string format = "Meter read date not found for Utility {0} Bill cycle ID {1} - {2}/{3}.";
            throw new MeterReadDateNotFoundException( String.Format( format, utilityCode, readCycleId, month.ToString(), year.ToString() ) );

        }

        #endregion
    }
}
