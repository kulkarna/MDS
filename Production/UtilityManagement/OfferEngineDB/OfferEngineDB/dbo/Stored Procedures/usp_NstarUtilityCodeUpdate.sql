/*******************************************************************************
 * usp_NstarUtilityCodeUpdate
 * Updates utility code in offer engine with utility code in usage.
 * Pricing uploads all NSTAR accounts as NSTAR-BOS.
 *
 * History
 *******************************************************************************
 * 4/23/2010 - Rick Deigsler
 * Created.
 *
 * Modified 5/20/2010 - Rick Deigsler
 * Pull utility code from lp_transactions if available
 *
 * Modified 7/13/2011 - Rick Deigsler
 * Pull non NSTAR-BOS records from EDIAccount table
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_NstarUtilityCodeUpdate]
	@OfferId		varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

return;
	-- only run update if offer has NSTAR accounts
	IF EXISTS (	SELECT	NULL 
				FROM	dbo.OE_ACCOUNT a WITH (NOLOCK)
						INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON a.ACCOUNT_NUMBER = o.ACCOUNT_NUMBER 
				WHERE	o.OFFER_ID = @OfferId AND a.UTILITY LIKE '%NSTAR%'
			   )
		BEGIN
			-- update utility code from edi file data if available
			IF EXISTS (	SELECT	NULL 
						FROM	dbo.OE_ACCOUNT a WITH (NOLOCK)
								INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON a.ACCOUNT_NUMBER = o.ACCOUNT_NUMBER
								INNER JOIN lp_transactions..EdiAccount e WITH (NOLOCK) ON a.ACCOUNT_NUMBER = e.AccountNumber
						WHERE	o.OFFER_ID = @OfferId
						AND		e.UtilityCode LIKE '%NSTAR%'
					   )		
				BEGIN
					UPDATE	dbo.OE_ACCOUNT
					SET		UTILITY = z.UtilityCode
					FROM	dbo.OE_ACCOUNT o WITH (NOLOCK) INNER JOIN
					(	-- get the latest record from EDI table
						SELECT	e.AccountNumber, e.UtilityCode 
						FROM	lp_transactions..EdiAccount e WITH (NOLOCK)
								INNER JOIN dbo.OE_ACCOUNT a WITH (NOLOCK)
								INNER JOIN dbo.OE_OFFER_ACCOUNTS o 
								on a.account_number = o.account_number			
								ON e.AccountNumber = a.ACCOUNT_NUMBER
						WHERE	e.UtilityCode LIKE 'NSTAR%'
						AND		o.OFFER_ID = @OfferId
						AND		e.ID = (SELECT MAX(ID) FROM lp_transactions..EdiAccount WITH (NOLOCK) WHERE accountnumber = a.ACCOUNT_NUMBER)
					)z ON o.ACCOUNT_NUMBER = z.AccountNumber
					INNER JOIN dbo.OE_OFFER_ACCOUNTS a WITH (NOLOCK) ON a.ACCOUNT_NUMBER = o.ACCOUNT_NUMBER
					WHERE	a.OFFER_ID = @OfferId
				END
			ELSE -- update utility code from usage data, last option
				BEGIN
					UPDATE	dbo.OE_ACCOUNT
					SET		UTILITY = z.UtilityCode
					FROM	dbo.OE_ACCOUNT a WITH (NOLOCK) INNER JOIN
					(
						SELECT	DISTINCT UtilityCode, AccountNumber
						FROM	LibertyPower..UsageConsolidation WITH (NOLOCK)
						WHERE	UtilityCode LIKE 'NSTAR%'
						AND		UtilityCode NOT LIKE '%NSTAR-BOS%'
					) z ON a.ACCOUNT_NUMBER = z.AccountNumber
						INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON a.ACCOUNT_NUMBER = o.ACCOUNT_NUMBER
					WHERE	o.OFFER_ID = @OfferId
					AND		a.UTILITY <> z.UtilityCode
					AND		a.UTILITY LIKE '%NSTAR%'
					AND		a.UTILITY <> 'NSTAR-BOS'
				END
		END

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

