
/*******************************************************************************
 * [usp_DailyPricing_UpdateLegacyRates]
 * Updates the rate records in the Legacy table
 *
 * History
 *******************************************************************************
 * 8/04/2010 - George Worthington
 * Created.
 * 9/2/2010 Updated - George Worthington 
 * Updated to save today's date in eff_date
 *******************************************************************************
 * Updated: 9/21/2010
 * Migrated table product_transition from [Workspace] to [LibertyPower]
 *******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricing_UpdateLegacyRates]
	@ProductId			varchar(20),
	@RateId				int,
	@Rate				float,
	@Terms				int, 
	@EffDate			dateTime,
	@DueDate			dateTime,
	@GrossMargin		decimal(9,6),		
	@RateDescription	varchar(250) =null
AS
BEGIN


-- UPDATE the rate and term (term if super saver)
Update lp_common..common_product_rate
SET rate = @Rate
	, term_months = @Terms
	, inactive_ind = 0
	, eff_date = convert(varchar(100),getDate(), 101)
	, due_date = @DueDate
	, username = 'SYSTEM'
	, GrossMargin = @GrossMargin
	--, rate_descp = @RateDescription
WHERE product_id = @ProductId	
	AND rate_id = @RateId		
	
	
Update LibertyPower.dbo.product_transition
SET term = @Terms
WHERE product_id = @ProductId	
	AND rate_id = @RateId
End
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricing_UpdateLegacyRates';

