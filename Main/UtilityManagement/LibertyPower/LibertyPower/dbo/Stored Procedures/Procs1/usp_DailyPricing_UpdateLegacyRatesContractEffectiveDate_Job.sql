	
/*******************************************************************************
 * usp_DailyPricing_UpdateLegacyRatesContractEffectiveDate_Job
 *
 *
 ******************************************************************************
 * Updated: 9/21/2010
 * Migrated table product_transition from [Workspace] to [LibertyPower]
 *******************************************************************************
 * 10/28/2010 - George Worthington
 * Updated to Disable then Enable the trigger on the common_product_rate table.
 *******************************************************************************/
 
 
CREATE PROCEDURE [dbo].[usp_DailyPricing_UpdateLegacyRatesContractEffectiveDate_Job]

AS	
declare @msg	varchar(100)

--	write to log
exec usp_DailyPricingLogInsert_New 3, 8, 'Legacy Rate update: Begin update of effective dates', NULL, 0	

-- Turn OFF the update trigger on the common product rate table.
Alter Table lp_common.dbo.common_product_rate DISABLE TRIGGER upd_rate

exec usp_DailyPricingLogInsert_New 3, 8, 'Legacy Rate update: Trigger disabled', NULL, 0	

		SET NOCOUNT ON;
		DECLARE	@ProductCrossPriceSetID	int	
				
		SELECT	@ProductCrossPriceSetID	= ProductCrossPriceSetID
		FROM	LibertyPower..ProductCrossPriceSet (NOLOCK)
		WHERE	EffectiveDate = (	SELECT MAX(EffectiveDate)
									FROM LibertyPower..ProductCrossPriceSet (NOLOCK)
									WHERE EffectiveDate <= GETDATE()
								)
								
exec usp_DailyPricingLogInsert_New 3, 8, 'Legacy Rate update: Prices selected', NULL, 0	
					
		Select UtilityId, min(StartDate) as MinStartDate
		INTO #MinStartDateByUtility
		From libertypower..ProductCrossPrice (nolock)
		Where ProductCrossPriceSetID = @ProductCrossPriceSetID
		Group By UtilityId

exec usp_DailyPricingLogInsert_New 3, 8, 'Legacy Rate update: Min start dates selected', NULL, 0	

		Declare @utilId int
		Declare @MinStartDate DateTime

		WHILE (select count(*) From #MinStartDateByUtility) > 0
		BEGIN
			Select Top 1  @utilId = UtilityID, @MinStartDate = MinStartDate From #MinStartDateByUtility
			print '@utilId = ' + cast(@utilId as varchar(5)) + ' and @MinStartDate = ' + cast(@MinStartDate as varchar(20))
			
			Update r
			Set Contract_eff_start_date =  DateAdd(m, (t.RelativeStartMonth - 1) , @MinStartDate)
			From  lp_common..common_Product_rate r
			Join LibertyPower.dbo.product_transition t ON t.product_id = r.product_id AND t.rate_id = r.rate_id
			WHERE @utilId = UtilityID

set @msg = 'Legacy Rate update: Updated start dates for utility ID ' + cast(@utilId as varchar(10))			
exec usp_DailyPricingLogInsert_New 3, 8, @msg, NULL, 0	
			
			delete from #MinStartDateByUtility
			where @utilId = UtilityID 
		END


		drop table #MinStartDateByUtility
		SET NOCOUNT OFF;
										
-- Turn ON the update trigger on the common product rate table.
Alter Table lp_common.dbo.common_product_rate ENABLE TRIGGER upd_rate

exec usp_DailyPricingLogInsert_New 3, 8, 'Legacy Rate update: Trigger enabled', NULL, 0		

--	write to log
exec usp_DailyPricingLogInsert_New 3, 8, 'Legacy Rate update: Update of effective dates complete', NULL, 0			
		
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricing_UpdateLegacyRatesContractEffectiveDate_Job';

