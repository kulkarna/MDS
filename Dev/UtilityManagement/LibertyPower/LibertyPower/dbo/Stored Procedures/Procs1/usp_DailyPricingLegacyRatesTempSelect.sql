
/*******************************************************************************
 * usp_DailyPricingLegacyRatesTempSelect
 * Selects legacy rate records for specified parameters
 *
 * History
 *******************************************************************************
 * 11/3/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingLegacyRatesTempSelect]
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
    
    SELECT	ProductID, RateID, MarketID, UtilityID, ZoneID, ServiceClassID, ChannelGroupID, Term, 
			AccountTypeID, ChannelTypeID, ProductTypeID, RateDesc, DueDate, ContractEffStartDate, 
			TermMonths, Rate, IsTermRange
	FROM	Libertypower..DailyPricingLegacyRatesTemp WITH (NOLOCK)
	WHERE	MarketID				= @MarketID
	AND		UtilityID				= @UtilityID
	AND		ZoneID					= @ZoneID
	AND		ServiceClassID			= @ServiceClassID
	AND		ChannelGroupID			= @ChannelGroupID
	AND		AccountTypeID			= @AccountTypeID
	AND		ChannelTypeID			= @ChannelTypeID
	AND		ProductTypeID			= @ProductTypeID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingLegacyRatesTempSelect';

