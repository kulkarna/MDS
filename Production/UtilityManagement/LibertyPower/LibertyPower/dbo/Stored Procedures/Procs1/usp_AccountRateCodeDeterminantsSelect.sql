


/**************************************************************************************************
 * [usp_AccountRateCodeDeterminantsSelect]
 * 
 * select accounts subject to rate update based on given utility, zone, and trip date
 *
 **************************************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountRateCodeDeterminantsSelect]  
	@UtilityID				varchar(50),
	@AccountNumber varchar(50)
	
AS

SELECT
      Acct.account_number, Acct.service_rate_class, Acct.zone, Acct.meter_type, Acct.[status], Acct.sub_status
FROM
      lp_account.dbo.Account Acct
      
WHERE
      Acct.utility_id = @UtilityID
      AND Acct.account_number = @AccountNumber

                                                                                                                                          
-- Copyright 2009 Liberty Power


