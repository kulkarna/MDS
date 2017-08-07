


/*******************************************************************************
 * usp_DailyPricingDropLegacyRatesIndex
 * Desc
 *
 * History
 *******************************************************************************
 * 11/3/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingDropLegacyRatesIndex]

AS
BEGIN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DailyPricingLegacyRatesTemp]') AND name = N'ndx_RateSelect')
	DROP INDEX [ndx_RateSelect] ON [dbo].[DailyPricingLegacyRatesTemp] WITH ( ONLINE = OFF )

END
-- Copyright 2011 Liberty Power




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingDropLegacyRatesIndex';

