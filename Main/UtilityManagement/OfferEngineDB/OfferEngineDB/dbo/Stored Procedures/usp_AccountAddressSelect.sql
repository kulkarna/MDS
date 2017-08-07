/*******************************************************************************
 * usp_AccountAddressSelect
 * Get address
 *
 * History
 *******************************************************************************
 * 10/7/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountAddressSelect]                                                                                     
	@AccountNumber	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@AccountId	int

	SELECT	OE_ACCOUNT_ID, ACCOUNT_NUMBER, [ADDRESS], SUITE, CITY, [STATE], ZIP
	FROM	OE_ACCOUNT_ADDRESS WITH (NOLOCK)
	WHERE	ACCOUNT_NUMBER = @AccountNumber


    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

