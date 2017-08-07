


/*******************************************************************************
 * usp_RateCodeBillingTypeByAccountSelect
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeBillingTypeByAccountSelect]  
	@utilityID				varchar(50),                                                                                  
	@accountNumber	varchar(50)

AS

select lp_account..account.billing_type from lp_account..account where lp_account..account.utility_id = @utilityID and lp_account..account.account_number = @accountNumber
	                                                                                                                                
-- Copyright 2009 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeBillingTypeByAccountSelect';

