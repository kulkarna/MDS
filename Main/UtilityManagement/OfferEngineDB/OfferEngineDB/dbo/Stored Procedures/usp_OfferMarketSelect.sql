/*******************************************************************************
 * usp_OfferMarketSelect
 * Gets market for offer
 *
 * History
 *******************************************************************************
 * 4/23/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferMarketSelect]
	@OfferId	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT	MARKET AS MarketCode
    FROM	OE_OFFER_MARKETS WITH (NOLOCK)
    WHERE	OFFER_ID = @OfferId

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

