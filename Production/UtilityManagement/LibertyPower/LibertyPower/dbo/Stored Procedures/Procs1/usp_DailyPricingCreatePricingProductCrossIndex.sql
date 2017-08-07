

/*******************************************************************************
 * usp_DailyPricingCreatePricingProductCrossIndex
 * Desc
 *
 * History
 *******************************************************************************
 * 11/4/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingCreatePricingProductCrossIndex]

AS
BEGIN

	CREATE NONCLUSTERED INDEX [ndx_PriceSelect] ON [dbo].[DailyPricingProductCrossPriceTemp] 
	(
		[ProductTypeID] ASC,
		[MarketID] ASC,
		[UtilityID] ASC,
		[SegmentID] ASC,
		[ZoneID] ASC,
		[ServiceClassID] ASC,
		[ChannelTypeID] ASC,
		[ChannelGroupID] ASC
	)WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

END
-- Copyright 2011 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingCreatePricingProductCrossIndex';

