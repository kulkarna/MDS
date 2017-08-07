/*******************************************************************************
 * usp_OfferAccountsSelect
 * Get records for specified offer
 *
 * History
 *******************************************************************************
 * 2/18/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferAccountsSelect]                                                                                
	@OfferId	varchar(50)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT	ID AS OfferAccountsId, OFFER_ID AS OfferId, ACCOUNT_NUMBER AS AccountNumber
	FROM	OE_OFFER_ACCOUNTS WITH (NOLOCK)
	WHERE	OFFER_ID = @OfferId

    SET NOCOUNT OFF
END                                                                                                                                              
-- Copyright 2009 Liberty Power

