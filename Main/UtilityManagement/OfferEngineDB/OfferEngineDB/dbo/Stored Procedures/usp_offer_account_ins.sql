
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/26/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_account_ins]

@p_pricing_request_id	varchar(50),
@p_offer_id				varchar(50),
@p_account_id			varchar(50)	= NULL,
@p_account_number		varchar(50)	= NULL

AS

DECLARE	@w_oe_account_id	int,
		@UtilityCode		varchar(50),
		@MinUsageDate		datetime,
		@OldestUsageDate	datetime,
		@Today				datetime
		
SET	@Today = GETDATE()			

SELECT	@w_oe_account_id	= OE_ACCOUNT_ID
FROM	OE_PRICING_REQUEST_ACCOUNTS WITH (NOLOCK)
WHERE	PRICING_REQUEST_ID	= @p_pricing_request_id
AND		ACCOUNT_NUMBER		= @p_account_number

IF @w_oe_account_id IS NOT NULL
	BEGIN
		SELECT	@UtilityCode	= UTILITY
		FROM	dbo.OE_ACCOUNT WITH (NOLOCK)
		WHERE	ID				= @w_oe_account_id
		
		-- begin determine if usage is needed  ---------------------------------------------------------------------------
		SET		@MinUsageDate = DATEADD(day, -364, @Today)

		DECLARE @Usage TABLE (AccountNumber varchar(50), MaxDate datetime)

		INSERT INTO @Usage
		SELECT	DISTINCT u.AccountNumber, MAX(ToDate)
		FROM	Libertypower..UsageConsolidated u WITH (NOLOCK)
		WHERE	u.UtilityCode	= @UtilityCode
		AND		u.AccountNumber	= @p_account_number
		GROUP BY u.AccountNumber
		UNION
		SELECT	DISTINCT u.AccountNumber, MAX(ToDate)
		FROM	Libertypower..EstimatedUsage u WITH (NOLOCK)
		WHERE	u.UtilityCode	= @UtilityCode
		AND		u.AccountNumber	= @p_account_number
		GROUP BY u.AccountNumber

		SELECT @OldestUsageDate = MIN(MaxDate) FROM @Usage
		
		-- if usage is too old or does not exist, set need usage flag for account
		IF (@OldestUsageDate < @MinUsageDate) OR (@OldestUsageDate IS NULL)
			BEGIN
				UPDATE	dbo.OE_ACCOUNT
				SET		NeedUsage	= 1
				WHERE	ID			= @w_oe_account_id
			END
		-- end determine if usage is needed  -----------------------------------------------------------------------------

		IF NOT EXISTS (	SELECT	NULL
							FROM	dbo.OE_OFFER_ACCOUNTS WITH (NOLOCK)
							WHERE	OFFER_ID = @p_offer_id AND ACCOUNT_NUMBER = @p_account_number )
			BEGIN
				INSERT INTO	dbo.OE_OFFER_ACCOUNTS (OFFER_ID, OE_ACCOUNT_ID, ACCOUNT_ID, ACCOUNT_NUMBER)
				VALUES		(@p_offer_id, @w_oe_account_id, @p_account_id, @p_account_number)

				IF @@ERROR <> 0 OR @@ROWCOUNT = 0
					SELECT 1
				ELSE
					SELECT 0
			END
	END
ELSE
	SELECT 1




