
/*******************************************************************************
 * usp_OfferUsageRemap
 * Remaps usage for offer when a new offer is created for same account(s)
 *
 * History
 *			07/30/2011 (EP) - adding usage type + changing source of usage table - IT022
 *			08/15/2011 (EP) - compensating for new usage type column added to EstimatedUsage
 *******************************************************************************
 * 2/26/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferUsageRemap]
	@OfferId	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@AccountId		bigint,
			@AccountNumber	varchar(50),
			@UtilityCode	varchar(50),			
			@UsageId		bigint,
			@AccountCount	int,
			@UsageCount		int,
			@AnnualUsage	bigint,
			@TotalUsage		float,
			@TotalDays		float,
			@MaxEndDate		datetime,
--			@estimate		smallint,
			@usageType		smallint

--	select	@estimate = value from usagetype where description = 'Estimated'

	CREATE TABLE #Accounts	(AccountId bigint, AccountNumber varchar(50), UtilityCode varchar(50))
	CREATE TABLE #UsageIds	(UsageId bigint, usageType	smallint)

	-- get list of offer account ids and account numbers for offer
	INSERT INTO	#Accounts
	SELECT	o.[ID], a.ACCOUNT_NUMBER, a.UTILITY
	FROM	OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK)
			INNER JOIN OfferEngineDB..OE_ACCOUNT a ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE	o.OFFER_ID = @OfferId

	SELECT	@AccountCount = COUNT(AccountId)
	FROM	#Accounts

	-- loop through accounts
	WHILE	@AccountCount > 0
		BEGIN
			-- get single offer account id and account number
			SELECT	TOP 1 @AccountId = AccountId, @AccountNumber = AccountNumber, @UtilityCode = UtilityCode
			FROM	#Accounts

			-- delete any existing records
			-- avoids duplicates, faster than if exists
			EXEC	usp_OfferAccountUsageMappingDelete @OfferId, @AccountNumber

			-- get list of usage ids for account number
			INSERT INTO	#UsageIds
			SELECT	[ID], UsageType
			FROM	UsageConsolidated WITH (NOLOCK)
			WHERE	AccountNumber	= @AccountNumber
				AND	UtilityCode		= @UtilityCode
			UNION
			SELECT	[ID], UsageType
			FROM	EstimatedUsage WITH (NOLOCK)
			WHERE	AccountNumber	= @AccountNumber
				AND	UtilityCode		= @UtilityCode

			SELECT	@UsageCount = COUNT(UsageId)
			FROM	#UsageIds

			-- loop through usage records for account number
			WHILE	@UsageCount > 0
				BEGIN
					-- get single usage id record
					SELECT	TOP 1 @UsageId = UsageId, @usageType = usageType
					FROM	#UsageIds

					-- insert offer account id and usage id
					EXEC	usp_OfferUsageMappingInsert @AccountId, @UsageId, @usageType

					DELETE
					FROM	#UsageIds
					WHERE	UsageId = @UsageId

					SELECT	@UsageCount = COUNT(UsageId)
					FROM	#UsageIds
				END

			-- begin update annual usage  -----------------------------------------
			SELECT	@MaxEndDate = MAX(z.ToDate), @TotalUsage = SUM(z.TotalKwh), @TotalDays = SUM(z.DaysUsed)
			FROM
			(
				SELECT	ToDate, TotalKwh, DaysUsed
				FROM	LibertyPower..UsageConsolidated u WITH (NOLOCK)
						INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
						INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				WHERE	o.OFFER_ID			= @OfferId 
				AND		o.ACCOUNT_NUMBER	= @AccountNumber
				GROUP BY ToDate, TotalKwh, DaysUsed
				UNION
				SELECT	ToDate, TotalKwh, DaysUsed
				FROM	LibertyPower..EstimatedUsage u WITH (NOLOCK)
						INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
						INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				WHERE	o.OFFER_ID			= @OfferId 
				AND		o.ACCOUNT_NUMBER	= @AccountNumber
--				AND		m.UsageType			= @estimate
				GROUP BY ToDate, TotalKwh, DaysUsed
			)z

			IF @TotalDays > 0 AND @TotalUsage > 0
				SET	@AnnualUsage = CAST((CAST(@TotalUsage AS decimal(18,5)) * (CAST(365 AS decimal(18,5)) / CAST(@TotalDays AS decimal(18,5)))) AS int)
			ELSE
				SET	@AnnualUsage = 0	
				
			UPDATE	OfferEngineDB..OE_ACCOUNT
			SET		ANNUAL_USAGE	= CASE WHEN LEN(@AnnualUsage) > 0	THEN @AnnualUsage	ELSE ANNUAL_USAGE	END, 
					USAGE_DATE		= CASE WHEN @MaxEndDate IS NOT NULL	THEN @MaxEndDate	ELSE USAGE_DATE		END
			WHERE	ACCOUNT_NUMBER	= @AccountNumber AND UTILITY = @UtilityCode						
			-- end update annual usage  -------------------------------------------			
			
			DELETE
			FROM	#Accounts
			WHERE	AccountId		= @AccountId
			AND		AccountNumber	= @AccountNumber

			SELECT	@AccountCount = COUNT(AccountId)
			FROM	#Accounts
		END

	DROP TABLE	#Accounts
	DROP TABLE	#UsageIds

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

