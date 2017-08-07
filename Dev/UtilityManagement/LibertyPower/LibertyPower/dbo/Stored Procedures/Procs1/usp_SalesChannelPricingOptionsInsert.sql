/*******************************************************************************
 * usp_SalesChannelPricingOptionsInsert
 * Inserts pricing options for specified sales channel ID
 *
 * History
 *******************************************************************************
 * 4/13/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelPricingOptionsInsert]
	@ChannelID				int,
	@EnableTieredPricing	tinyint,
	@QuoteTolerance			decimal(12,6)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	int
    
    INSERT INTO SalesChannelPricingOptions (ChannelID, EnableTieredPricing, QuoteTolerance)
    VALUES		(@ChannelID, @EnableTieredPricing, @QuoteTolerance)
    
    SET @ID = SCOPE_IDENTITY()
    
    SELECT	ID, ChannelID, EnableTieredPricing, QuoteTolerance
    FROM	SalesChannelPricingOptions WITH (NOLOCK)
    WHERE	ID = @ID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
