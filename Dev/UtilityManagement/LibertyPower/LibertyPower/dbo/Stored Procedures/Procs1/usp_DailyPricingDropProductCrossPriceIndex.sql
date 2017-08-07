


/*******************************************************************************
 * usp_DailyPricingDropProductCrossPriceIndex
 * Desc
 *
 * History
 *******************************************************************************
 * 11/4/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingDropProductCrossPriceIndex]

AS
BEGIN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DailyPricingProductCrossPriceTemp]') AND name = N'ndx_PriceSelect')
	DROP INDEX [ndx_PriceSelect] ON [dbo].[DailyPricingProductCrossPriceTemp] WITH ( ONLINE = OFF )

END
-- Copyright 2011 Liberty Power




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingDropProductCrossPriceIndex';

