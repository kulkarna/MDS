/*******************************************************************************
 * usp_SalesChannelPricingOptionsUpdate
 * Updates pricing options for specified record ID
 *
 * History
 *******************************************************************************
 * 4/13/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelPricingOptionsUpdate]
	@ChannelID				int,
	@EnableTieredPricing	tinyint,
	@QuoteTolerance			decimal(12,6)
AS
BEGIN
    SET NOCOUNT ON;
       
    UPDATE	SalesChannelPricingOptions
    SET		EnableTieredPricing	= @EnableTieredPricing, 
			QuoteTolerance		= @QuoteTolerance
    WHERE	ChannelID			= @ChannelID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
