/*******************************************************************************
 * usp_ProductCrossPriceForMultiTermSelect
 * Gets product cross prices that are multi-term product type for specified set ID
 *
 * History
 *******************************************************************************
 * 9/19/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceForMultiTermSelect]
	@ProductCrossPriceSetID	int
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	[ProductCrossPriceID]
			,[ProductCrossPriceSetID]
			,[ProductMarkupRuleID]
			,[ProductCostRuleID]
			,[ProductTypeID]
			,[MarketID]
			,[UtilityID]
			,[SegmentID]
			,[ZoneID]
			,[ServiceClassID]
			,[ChannelTypeID]
			,[ChannelGroupID]
			,[CostRateEffectiveDate]
			,[StartDate]
			,[Term]
			,[CostRateExpirationDate]
			,[MarkupRate]
			,[CostRate]
			,[CommissionsRate]
			,[POR]
			,[GRT]
			,[SUT]
			,[Price]
			,[CreatedBy]
			,[DateCreated]
			,[RateCodeID]
			,[PriceTier]
	FROM	LibertyPower..ProductCrossPrice WITH (NOLOCK)
	WHERE	[ProductCrossPriceSetID] = @ProductCrossPriceSetID  
	AND		[ProductTypeID] = 7

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
