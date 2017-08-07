


/*******************************************************************************
 * usp_RateCodeBillingTypeByAccountSelect
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeBillingTypeByAccountUpdate]  
	@utilityID				varchar(50),                                                                                  
	@accountNumber	varchar(50),
	@billingType			varchar(50)

AS

update lp_account..account set lp_account..account.billing_type = @billingType 
where lp_account..account.utility_id = @utilityID and lp_account..account.account_number = @accountNumber
	                                                                                                                                
-- Copyright 2009 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeBillingTypeByAccountUpdate';

