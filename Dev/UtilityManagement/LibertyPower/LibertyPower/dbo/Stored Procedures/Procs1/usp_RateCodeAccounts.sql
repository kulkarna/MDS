


/*******************************************************************************
 * [usp_AccountByRateCode]
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeAccounts]
	@RateCode				varchar(50)                                                                              
AS
	SELECT		
	a.account_number as [Account #], 
	a.contract_nbr as [Contract #],
	a.rate_code as [Rate Code],
	a.utility_id as [Utility], 
	a.service_rate_class as  [Service Class], 
	a.zone as [Zone], 
	a.meter_type as [Meter Type], 
	a.rate as [Rate],
	b.product_category as [Product Type],
	CONVERT(CHAR(10),a.contract_eff_start_date,101) as [Start Date],
	a.term_months as [Term Months]
	FROM	lp_account..account a
	LEFT JOIN
	lp_common..common_product b on a.product_id = b.product_id
	WHERE a.rate_code = @RateCode
	
	
    
-- Copyright 2009 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeAccounts';

