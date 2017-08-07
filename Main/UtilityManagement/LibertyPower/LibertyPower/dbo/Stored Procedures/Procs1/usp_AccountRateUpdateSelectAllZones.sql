



/**************************************************************************************************
 * usp_AccountRateUpdateSelect
 * 
 * select accounts subject to rate update based on given utility, zone, and trip date
 *
 **************************************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountRateUpdateSelectAllZones]  
	@UtilityID				varchar(50),
	@TripDate				datetime,
	@LeadDays			int
	
AS

SELECT
      Acct.account_number, MRC.read_date,Acct.service_rate_class, Acct.zone, Acct.billing_group, Acct.rate_code, Acct.rate, Acct.meter_type
FROM
      lp_account.dbo.Account Acct
      LEFT JOIN 
            lp_common.dbo.meter_read_calendar MRC ON 
                                                                              MRC.utility_id =Acct.utility_id 
                                                                              AND MRC.read_cycle_id = Acct.billing_group 
                                                                              AND YEAR(GetDate())=MRC.calendar_year
                                                                              AND MONTH(GetDate()) =MRC.calendar_month
      
WHERE
      Acct.status IN ('906000','905000')
      AND MRC.read_date > @TripDate
      AND MRC.read_date < @TripDate + @LeadDays
      AND Acct.utility_id = @UtilityID


                                                                                                                                          
-- Copyright 2009 Liberty Power



