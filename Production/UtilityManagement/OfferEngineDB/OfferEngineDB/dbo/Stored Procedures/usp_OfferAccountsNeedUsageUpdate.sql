/*******************************************************************************
 * usp_OfferAccountsNeedUsageUpdate
 * To update the need usage flag for accounts in offer
 *
 * History
 *******************************************************************************
 * 10/6/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferAccountsNeedUsageUpdate]
	@OfferId	varchar(50),
	@NeedUsage	tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
	UPDATE	OE_ACCOUNT
	SET		NeedUsage = @NeedUsage
	FROM	OE_ACCOUNT a2 WITH (NOLOCK) INNER JOIN
	(
		SELECT	a.UTILITY, o.ACCOUNT_NUMBER
		FROM	OE_ACCOUNT a WITH (NOLOCK)
				INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
		WHERE	o.OFFER_ID = @OfferId
	) z
	ON	a2.UTILITY			= z.Utility
	AND	a2.ACCOUNT_NUMBER	= z.ACCOUNT_NUMBER
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power

