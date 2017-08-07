/*******************************************************************************
 * usp_OfferUtilitiesDelete
 * Deletes offer utilities
 *
 * History
 *******************************************************************************
 * 11/2/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferUtilitiesDelete]
	@OfferId	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	DELETE FROM	OE_OFFER_UTILITIES
	WHERE		OFFER_ID = @OfferId

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

