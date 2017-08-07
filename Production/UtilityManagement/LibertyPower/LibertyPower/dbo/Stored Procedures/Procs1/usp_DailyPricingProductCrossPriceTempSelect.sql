
/*******************************************************************************
 * usp_DailyPricingProductCrossPriceTempSelect
 * Selects cross product price records for specified parameters
 *
 * History
 *******************************************************************************
 * 11/4/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingProductCrossPriceTempSelect]
	@MarketID		int, 
	@UtilityID		int, 
	@ZoneID			int, 
	@ServiceClassID	int, 
	@ChannelGroupID	int,
	@AccountTypeID	int, 
	@ChannelTypeID	int, 
	@ProductTypeID	int
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	ProductCrossPriceID, ProductCrossPriceSetID, ProductMarkupRuleID, ProductCostRuleID, ProductTypeID, MarketID, 
			UtilityID, SegmentID, ZoneID, ServiceClassID, ChannelTypeID, ChannelGroupID, CostRateEffectiveDate, StartDate, 
			Term, CostRateExpirationDate, MarkupRate, CostRate, CommissionsRate, POR, GRT, SUT, Price, CreatedBy, DateCreated, RateCodeID
	FROM	Libertypower.dbo.DailyPricingProductCrossPriceTemp WITH (NOLOCK)
	WHERE	MarketID		= @MarketID
	AND		UtilityID		= @UtilityID
	AND		ZoneID			= @ZoneID
	AND		ServiceClassID	= @ServiceClassID
	AND		ChannelGroupID	= @ChannelGroupID
	AND		SegmentID		= @AccountTypeID
	AND		ChannelTypeID	= @ChannelTypeID
	AND		ProductTypeID	= @ProductTypeID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingProductCrossPriceTempSelect';

