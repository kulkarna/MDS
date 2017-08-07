/*******************************************************************************
 * usp_OfferAccountUsageMap
 * Maps usage for offer account
 *
 * History
 *			07/30/2011 (EP) - adding usage type + changing source of usage table - IT022
 *			08/15/2011 (EP) - compensating for new usage type column added to EstimatedUsage
 *******************************************************************************
 * 6/9/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferAccountUsageMap]                                                                                   
	@OfferId		varchar(50),
	@AccountNumber	varchar(50)	
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@AccountId		bigint,
			@UsageId		bigint,
			@UsageCount		int,
--			@estimate		int,
			@usageType		smallint

--	select	@estimate = value from usagetype where description = 'Estimated'

	CREATE TABLE #UsageIds		(UsageId bigint, usageType	smallint)

	-- get account id of account number for offer
	SELECT	@AccountId		= [ID]
	FROM	OfferEngineDB..OE_OFFER_ACCOUNTS WITH (NOLOCK)
	WHERE	OFFER_ID		= @OfferId
	AND		ACCOUNT_NUMBER	= @AccountNumber

	-- delete any existing records
	-- avoids duplicates, faster than if exists
	EXEC	usp_OfferAccountUsageMappingDelete @OfferId, @AccountNumber

	-- get list of usage ids for account number
	INSERT INTO	#UsageIds
	SELECT	[ID], UsageType
	FROM	UsageConsolidated WITH (NOLOCK)
	WHERE	AccountNumber = @AccountNumber
	UNION
	SELECT	[ID], UsageType
	FROM	EstimatedUsage WITH (NOLOCK)
	WHERE	AccountNumber = @AccountNumber

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

	DROP TABLE	#UsageIds

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
