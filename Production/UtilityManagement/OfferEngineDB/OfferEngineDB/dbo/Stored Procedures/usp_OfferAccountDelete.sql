/*******************************************************************************
 * usp_OfferAccountDelete
 * Deletes an account from offer
 *
 * History
 *******************************************************************************
 * 11/1/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferAccountDelete]
	@OfferId		varchar(50),
	@AccountNumber	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	DELETE FROM	OE_OFFER_ACCOUNTS
	WHERE		OFFER_ID		= @OfferId
	AND			ACCOUNT_NUMBER	=  @AccountNumber 


    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

