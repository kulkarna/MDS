

/*******************************************************************************
 * usp_DailyPricingCreateLegacyRatesIndex
 * Desc
 *
 * History
 *******************************************************************************
 * 11/3/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingCreateLegacyRatesIndex]

AS
BEGIN

CREATE NONCLUSTERED INDEX [ndx_RateSelect] ON [dbo].[DailyPricingLegacyRatesTemp] 
(
	[MarketID] ASC,
	[UtilityID] ASC,
	[ZoneID] ASC,
	[ServiceClassID] ASC,
	[ChannelGroupID] ASC,
	[AccountTypeID] ASC,
	[ChannelTypeID] ASC,
	[ProductTypeID] ASC
)WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]


END
-- Copyright 2011 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingCreateLegacyRatesIndex';

