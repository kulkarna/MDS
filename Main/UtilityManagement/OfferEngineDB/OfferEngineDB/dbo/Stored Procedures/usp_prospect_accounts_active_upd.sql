
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 6/25/2008
-- Description:	Update active flag for accounts in 
--				lp_historical_info..ProspectAccounts
-- =============================================
CREATE PROCEDURE [dbo].[usp_prospect_accounts_active_upd]

@p_offer_id		varchar(50)

AS

-- make accounts active for accounts in offer
UPDATE	lp_historical_info..ProspectAccounts
SET		Active = 1
WHERE	[Deal ID] = @p_offer_id
AND		AccountNumber IN (	SELECT	ACCOUNT_NUMBER
							FROM	OE_OFFER_ACCOUNTS WITH (NOLOCK)
							WHERE	OFFER_ID = @p_offer_id )

-- make accounts inactive for accounts not in offer
UPDATE	lp_historical_info..ProspectAccounts
SET		Active = 0
WHERE	[Deal ID] = @p_offer_id
AND		AccountNumber NOT IN (	SELECT	ACCOUNT_NUMBER
								FROM	OE_OFFER_ACCOUNTS WITH (NOLOCK)
								WHERE	OFFER_ID = @p_offer_id )



