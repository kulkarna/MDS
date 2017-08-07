/*******************************************************************************
 * usp_OfferAccountUsageMappingDelete
 * Delete association between offer accounts and usage records
 *
 * History
 *******************************************************************************
 * 2/19/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferAccountUsageMappingDelete]                                                                                     
	@OfferId		varchar(50),
	@AccountNumber	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	DELETE
	FROM	OfferUsageMapping
	WHERE	OfferAccountsId IN (	SELECT	[ID] 
									FROM	OfferEngineDB..OE_OFFER_ACCOUNTS 
									WHERE	OFFER_ID		= @OfferId 
									AND		ACCOUNT_NUMBER	= @AccountNumber
								)

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
