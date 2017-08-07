using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DAL= LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.CRMLibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class MeterReadCalendarFactory
	{

		private static void MapDataRowToMeterReadCalendar( DataRow dataRow, MeterReadCalendar meterReadCalendar )
		{
			meterReadCalendar.calendar_year = dataRow["calendar_year"] == DBNull.Value ?0 : Convert.ToInt32( dataRow["calendar_year"] );
			meterReadCalendar.calendar_month = dataRow["calendar_month"] == DBNull.Value ? 0 : Convert.ToInt32( dataRow["calendar_month"] );
			meterReadCalendar.utility_Id = dataRow["calendar_month"] == DBNull.Value ? "" : dataRow["utility_Id"].ToString();

			meterReadCalendar.read_cycle_id = dataRow["read_cycle_id"]== DBNull.Value ? "" : dataRow["read_cycle_id"].ToString();
			meterReadCalendar.read_date = dataRow["read_date"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dataRow["read_date"]);
			meterReadCalendar.Read_Month_Date = dataRow["Read_Month_Date"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime( dataRow["Read_Month_Date"] );
			meterReadCalendar.Read_Start_Date = dataRow["Read_Start_Date"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime( dataRow["Read_Start_Date"] );
			meterReadCalendar.Read_End_Date = dataRow["Read_End_Date"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime( dataRow["Read_End_Date"] );
			meterReadCalendar.Start_Month = dataRow["Start_Month"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime( dataRow["Start_Month"] );		

		}

		//Get the Meter Read Object for the Billing Cycle After the given date
	
		public MeterReadCalendar GetTheBillingCycleAfterGivenDate(string UtilityID, string ReadCycleId, DateTime GivenDate)
		{
			MeterReadCalendar meterReadCalendar= new MeterReadCalendar();

			DataSet ds=DAL.GetMeterReadBillingCycleAftertheGivenDate(UtilityID,ReadCycleId,GivenDate);
			
			
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				MapDataRowToMeterReadCalendar( ds.Tables[0].Rows[0], meterReadCalendar );
			else
				meterReadCalendar.Start_Month = new DateTime( GivenDate.Year, GivenDate.Month, 1 );
			
			return meterReadCalendar;


		
		}
		
		//Get the Meter Read Object for the Billing Cycle Containing the given date

		public MeterReadCalendar GetTheBillingCycleContainingGivenDate( string UtilityID, string ReadCycleId, DateTime GivenDate )
		{
			MeterReadCalendar meterReadCalendar = new MeterReadCalendar();

			DataSet ds = DAL.GetMeterReadBillingCycleContainingtheGivenDate( UtilityID, ReadCycleId, GivenDate );


			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
				MapDataRowToMeterReadCalendar( ds.Tables[0].Rows[0], meterReadCalendar );			

			return meterReadCalendar;



		}

		//Get the readCycle readStartDate for a given Start Month(derived)

		public DateTime GetTheReadStartDateforaGivenStartMonth( string UtilityID, string AccountNumber, DateTime GivenDate )
		{
			DateTime meterReadStartDate= DateTime.MinValue ;

			DataSet ds = DAL.GetMeterReadStartDateforagivenMonth( UtilityID, AccountNumber, GivenDate );


			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
				meterReadStartDate =ds.Tables[0].Rows[0]["Read_Start_Date"] == DBNull.Value ? DateTime.MinValue :Convert.ToDateTime( ds.Tables[0].Rows[0]["Read_Start_Date"] );
							
			
			return meterReadStartDate;


		}

	}

}
