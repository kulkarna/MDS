
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/13/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_recheck_usage_complete_for_offer]

@p_offer_id			varchar(50),
@p_status_open		varchar(50),
@p_status_complete	varchar(50)

AS

DECLARE	@w_account_number	varchar(50),
		@w_created			datetime,
		@w_count1			int,
		@w_count2			int,
		@w_count3			int,
		@estimate			smallint			

SET		@w_created			= GETDATE()

-- if usage is missing, set offer status to open
SELECT	@w_count1 = COUNT(DISTINCT ACCOUNT_NUMBER)
FROM	dbo.OE_ACCOUNT a WITH (NOLOCK)
INNER JOIN
(
	SELECT	DISTINCT u.AccountNumber
	FROM	Libertypower..UsageConsolidated u WITH (NOLOCK)
			INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId AND u.UsageType = m.UsageType
			INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
	WHERE	o.OFFER_ID = @p_offer_id
	UNION
	SELECT	DISTINCT u.AccountNumber
	FROM	Libertypower..EstimatedUsage u WITH (NOLOCK)
			INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId AND m.UsageType = u.UsageType
			INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
	WHERE	o.OFFER_ID = @p_offer_id 
)z ON a.ACCOUNT_NUMBER = z.AccountNumber

SELECT	@w_count2 = COUNT(DISTINCT a.ACCOUNT_NUMBER)
FROM	OE_OFFER_ACCOUNTS o WITH (NOLOCK)
		INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
WHERE	o.OFFER_ID	= @p_offer_id

SELECT		@w_count3 = COUNT(DISTINCT a.ACCOUNT_NUMBER)
FROM		OE_OFFER_ACCOUNTS o WITH (NOLOCK)
			INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
WHERE		o.OFFER_ID	= @p_offer_id
AND			a.NeedUsage	= 1

--print 'count1: ' + cast(@w_count1 as varchar(2))
--print 'count2: ' + cast(@w_count2 as varchar(2))
--print 'count3: ' + cast(@w_count3 as varchar(2))

IF EXISTS		(	SELECT		NULL
					FROM		OfferUsageStatus WITH (NOLOCK)
					WHERE		OfferId = @p_offer_id
					AND			HasErrors = 1
				)
OR ((@w_count1 <> @w_count2) OR (@w_count1 = 0) OR (@w_count3 > 0))
	BEGIN
		UPDATE	OE_OFFER
		SET		STATUS		= @p_status_open
		WHERE	OFFER_ID	= @p_offer_id
	END
ELSE -- if offer status was open and all usage and zones exist, change offer status to usage complete
--	BEGIN
		IF ( SELECT	TOP 1 STATUS FROM OE_OFFER WITH (NOLOCK) WHERE OFFER_ID = @p_offer_id ORDER BY DATE_CREATED DESC ) = @p_status_open
			BEGIN
				-- check if deal is in ProspectDeals and ProspectAccounts tables.
				-- if not, copy from existing data
--				IF NOT EXISTS (	SELECT	NULL
--								FROM	lp_historical_info..ProspectDeals  WITH (NOLOCK)
--								WHERE	DealID = @p_offer_id )
--				AND NOT EXISTS (	SELECT	NULL
--									FROM	lp_historical_info..ProspectAccounts WITH (NOLOCK) 
--									WHERE	[Deal ID] = @p_offer_id )
--					BEGIN
--						DECLARE curCopyAccts CURSOR FOR
--							SELECT	a.ACCOUNT_NUMBER
--							FROM	OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
--							WHERE	b.OFFER_ID = @p_offer_id
--						OPEN curCopyAccts 
--						FETCH NEXT FROM curCopyAccts INTO @w_account_number
--						WHILE (@@FETCH_STATUS = 0) 
--							BEGIN 
--								-- ProspectDeals  -------------------------------------
--								IF EXISTS (	SELECT	NULL
--											FROM	lp_historical_info..ProspectDeals WITH (NOLOCK)
--											WHERE	AccountNumber	= @w_account_number
--											AND		DealID			LIKE 'OF-%' )
--									BEGIN
--										INSERT INTO	lp_historical_info..ProspectDeals
--										SELECT		TOP 1 Utility, AccountNumber, @p_offer_id, AcctName, AcctZip, Status, 
--													@w_created, 'Offer Engine', Modified, ModifiedBy, MeterNumber
--										FROM		lp_historical_info..ProspectDeals WITH (NOLOCK)
--										WHERE		AccountNumber	= @w_account_number
--										AND			DealID			LIKE 'OF-%'
--									END
--
--								-- ProspectAccounts  -----------------------------------
--								IF EXISTS (	SELECT	NULL
--											FROM	lp_historical_info..ProspectAccounts WITH (NOLOCK)
--											WHERE	AccountNumber	= @w_account_number
--											AND		[Deal ID]		LIKE 'OF-%' )
--									BEGIN
--										INSERT INTO	lp_historical_info..ProspectAccounts
--										SELECT		TOP 1 Utility, CustomerName, AccountNumber, ServiceAddress, ZipCode, 
--													LoadShapeID, RateClass, RateCode, Rider, StratumVariable, ICAP, TCAP, 
--													POLRType, BillGroup, Voltage, Zone, ISO, LoadProfile, IDR, TotalKWH, 
--													TotalDays, @p_offer_id, @w_created, 'Offer Engine', Modified, ModifiedBy, 
--													AlternativeAcctNum, CustomerType, SupplyGroup, MeterNumber, OnPeakKWH, 
--													OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, CurrentCharges, Comments, 1
--										FROM		lp_historical_info..ProspectAccounts WITH (NOLOCK)
--										WHERE		AccountNumber	= @w_account_number
--										AND			[Deal ID]		LIKE 'OF-%'
--									END
--
--								FETCH NEXT FROM curCopyAccts INTO @w_account_number
--							END
--						CLOSE curCopyAccts 
--						DEALLOCATE curCopyAccts
--					END

				-- push status
				UPDATE	OE_OFFER
				SET		STATUS		= @p_status_complete
				WHERE	OFFER_ID	= @p_offer_id

				--EXEC	Libertypower..usp_OfferUsageRemap @p_offer_id
			END
--	END


