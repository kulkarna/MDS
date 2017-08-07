

/*******************************************************************************
 * [usp_RateCodeByAccount]
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeByAccount]  
	@AccountNumber				varchar(50)                                                                              
AS
	SELECT		
	lp_account..account.rate_code as [Rate Code],
	lp_account..account.account_number as [Account Number], 
	lp_account..account.utility_id as [Utility], 
	lp_account..account.service_rate_class as  [Service Class], 
	lp_account..account.zone as [Zone], 
	lp_account..account.meter_type as [Meter Type], 
	lp_account..account.rate	 as [Rate]
	FROM	lp_account..account 
	WHERE account_number = @AccountNumber
	
	
    
-- Copyright 2009 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeByAccount';

