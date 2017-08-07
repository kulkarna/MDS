
/*******************************************************************************
 * usp_DailyPricing_LegacyRatesMarkAllInactive_Job
 * Updates all non custom rates to Inactive
 *
 * History
 *******************************************************************************
 * 8/05/2010 - George Worthington
 * Created.
 *******************************************************************************
 * 10/28/2010 - George Worthington
 * Updated to Disable then Enable the trigger on the common_product_rate table.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricing_LegacyRatesMarkAllInactive_Job]
AS
BEGIN

--	write to log
exec usp_DailyPricingLogInsert 3, 8, 'Legacy Rate update: Begin update of Inactive flags'

	-- Turn OFF the update trigger on the common product rate table.
	Alter Table lp_common.dbo.common_product_rate DISABLE TRIGGER upd_rate
	
	Update r
	Set  r.inactive_ind = 1  --mark as inactive
	From 
		lp_common..common_product_rate r WITH (NOLOCK) 
			INNER JOIN lp_common..common_product p (NOLOCK) ON p.product_id = r.product_id	
	Where 
		isCustom = 0	
	--And 1=0	-- Added to prevent update from running.... no records will get updated

	-- Turn ON the update trigger on the common product rate table.
	Alter Table lp_common.dbo.common_product_rate ENABLE TRIGGER upd_rate

--	write to log
exec usp_DailyPricingLogInsert 3, 8, 'Legacy Rate update: Inactive flags complete'	

-- Copyright 2010 Liberty Power
End


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricing_LegacyRatesMarkAllInactive_Job';

