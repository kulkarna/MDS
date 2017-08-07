/*******************************************************************************
 * usp_DailyPricingProductAndRateIdSelect
 * Gets the legacy product and rate id for specified parameters
 *
 * History
 *******************************************************************************
 * 2/20/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingProductAndRateIdSelect]
	@MarketID			int,
	@UtilityID			int,
	@ZoneID				int,
	@ServiceClassID		int,
	@Term				int,
	@AccountTypeID		int,
	@ProductTypeID		int,
	@ChannelTypeID		int,
	@RelativeStartMonth	int,
	@ChannelGroupID		int,
	@ProductBrandID		int
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@ChannelGroupIDStr	varchar(5)
	
	IF		LEN(@ChannelGroupID) = 1 SET @ChannelGroupIDStr = '10' + CAST(@ChannelGroupID AS varchar(1))
	ELSE	SET @ChannelGroupIDStr = '1' + CAST(@ChannelGroupID AS varchar(5))	
	
	SELECT	t.product_id AS ProductId, t.rate_id AS RateId
	FROM	Libertypower..product_transition t WITH (NOLOCK)
			INNER JOIN lp_common..common_product_rate r  WITH (NOLOCK)
			ON t.product_id = r.product_id AND t.rate_id = r.rate_id
			INNER JOIN lp_common..common_product p  WITH (NOLOCK)
			ON t.product_id = p.product_id	
	WHERE	MarketID			= @MarketID
	AND		UtilityID			= @UtilityID
	AND		ZoneID				= @ZoneID
	AND		ServiceClassID		= @ServiceClassID
	AND		Term				= @Term
	AND		AccountTypeID		= @AccountTypeID
	AND		ProductTypeID		= @ProductTypeID
	AND		ChannelTypeID		= @ChannelTypeID
	AND		RelativeStartMonth	= CASE WHEN @RelativeStartMonth = 0 THEN 1 ELSE @RelativeStartMonth END
	AND		LEFT(t.rate_id, 3)	= @ChannelGroupIDStr
	--AND		r.inactive_ind		= 0	
	AND		p.ProductBrandID	= @ProductBrandID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
