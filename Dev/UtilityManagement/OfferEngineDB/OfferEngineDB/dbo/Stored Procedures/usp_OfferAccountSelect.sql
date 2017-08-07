/*******************************************************************************
 * usp_OfferAccountSelect
 * Get record for specified offer and account number
 *
 * History
 *******************************************************************************
 * 2/19/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferAccountSelect]                                                                                
	@OfferId		varchar(50),
	@AccountNumber	varchar(50)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT	ID AS OfferAccountsId, OFFER_ID AS OfferId, ACCOUNT_NUMBER AS AccountNumber
	FROM	OE_OFFER_ACCOUNTS WITH (NOLOCK)
	WHERE	OFFER_ID		= @OfferId
	AND		ACCOUNT_NUMBER	= @AccountNumber

    SET NOCOUNT OFF
END                                                                                                                                              
-- Copyright 2009 Liberty Power

