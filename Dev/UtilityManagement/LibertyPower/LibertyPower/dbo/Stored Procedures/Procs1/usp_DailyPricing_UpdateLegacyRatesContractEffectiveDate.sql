	
/*******************************************************************************
 * usp_DailyPricing_UpdateLegacyRatesContractEffectiveDate
 *
 *
 ******************************************************************************
 * Updated: 9/21/2010
 * Migrated table product_transition from [Workspace] to [LibertyPower]
 *******************************************************************************
 * 10/28/2010 - George Worthington
 * PROC DISABLED INTENTIONALLY... Will be phased out
 *******************************************************************************/
 
 
CREATE PROCEDURE [dbo].[usp_DailyPricing_UpdateLegacyRatesContractEffectiveDate]

AS	
-- intentionally turned off!
/****************************************************************************************************/
---- UPDATE the Contract_eff_start_date

---- Turn OFF the update trigger on the common product rate table.
--Alter Table lp_common.dbo.common_product_rate DISABLE TRIGGER upd_rate

--		SET NOCOUNT ON;
--		DECLARE	@ProductCrossPriceSetID	int	
		
--		SELECT	@ProductCrossPriceSetID	= ProductCrossPriceSetID
--		FROM	LibertyPower..ProductCrossPriceSet (NOLOCK)
--		WHERE	EffectiveDate = (	SELECT MAX(EffectiveDate)
--									FROM LibertyPower..ProductCrossPriceSet (NOLOCK)
--									WHERE EffectiveDate <= GETDATE()
--								)
			
--		Select UtilityId, min(StartDate) as MinStartDate
--		INTO #MinStartDateByUtility
--		From libertypower..ProductCrossPrice (nolock)
--		Where ProductCrossPriceSetID = @ProductCrossPriceSetID
--		Group By UtilityId


--		Declare @utilId int
--		Declare @MinStartDate DateTime

--		WHILE (select count(*) From #MinStartDateByUtility) > 0
--		BEGIN
--			Select Top 1  @utilId = UtilityID, @MinStartDate = MinStartDate From #MinStartDateByUtility
--			--print '@utilId = ' + cast(@utilId as varchar(5)) + ' and @MinStartDate = ' + cast(@MinStartDate as varchar(20))
			
--			Update r
--			Set Contract_eff_start_date =  DateAdd(m, (t.RelativeStartMonth - 1) , @MinStartDate)
--			From  lp_common..common_Product_rate r
--			Join LibertyPower.dbo.product_transition t ON t.product_id = r.product_id AND t.rate_id = r.rate_id
--			WHERE @utilId = UtilityID
			
			
--			delete from #MinStartDateByUtility
--			where @utilId = UtilityID 
--		END


--		drop table #MinStartDateByUtility
--		SET NOCOUNT OFF;
					
---- Turn ON the update trigger on the common product rate table.
--Alter Table lp_common.dbo.common_product_rate ENABLE TRIGGER upd_rate			
		
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricing_UpdateLegacyRatesContractEffectiveDate';

