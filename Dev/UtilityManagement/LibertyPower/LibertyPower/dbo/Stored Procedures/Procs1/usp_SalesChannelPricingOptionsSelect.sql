/*******************************************************************************
 * usp_SalesChannelPricingOptionsSelect
 * Select pricing options for specified sales channel ID
 *
 * History
 *******************************************************************************
 * 4/13/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelPricingOptionsSelect]
	@ChannelID int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, ChannelID, EnableTieredPricing, QuoteTolerance
    FROM	SalesChannelPricingOptions WITH (NOLOCK)
    WHERE	ChannelID = @ChannelID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
