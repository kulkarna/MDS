/*******************************************************************************
 * usp_PricingRequestOffersDelete
 * To clean up offers for specified pricing request
 *
 * History
 *******************************************************************************
 * 12/2/2008 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PricingRequestOffersDelete]                                                                                   

@PricingRequestId	varchar(50)

AS
BEGIN
    SET NOCOUNT ON

	DECLARE @ErrorCount	int
	SET		@ErrorCount = 0

	CREATE TABLE #OFFERIDS (OfferId varchar(50))

	-- get offer ids to clean up
	INSERT	INTO #OFFERIDS
	SELECT	DISTINCT OFFER_ID 
	FROM	OE_PRICING_REQUEST_OFFER
	WHERE	REQUEST_ID = @PricingRequestId


	BEGIN TRAN CLEANUP

	DELETE
	FROM	OE_OFFER
	WHERE	OFFER_ID IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_OFFER_ACCOUNTS
	WHERE	OFFER_ID IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_OFFER_AGGREGATES
	WHERE	OFFER_ID IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_OFFER_FLOW_DATES
	WHERE	OFFER_ID IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_TERMS_AND_PRICES
	WHERE	FLOW_START_DATE_ID IN 
	(
		SELECT	FLOW_START_DATE_ID 
		FROM	OE_OFFER_FLOW_DATES 
		WHERE	OFFER_ID IN ( SELECT OfferId FROM #OFFERIDS )
	)

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_OFFER_MARKET_PRICES_DETAIL
	WHERE	OFFER_ID IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_OFFER_MARKETS
	WHERE	OFFER_ID IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_OFFER_PRICE_FILES
	WHERE	OFFER_ID IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_OFFER_STATUS_MESSAGE
	WHERE	OFFER_ID IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_OFFER_UTILITIES
	WHERE	OFFER_ID IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_PRICING_REQUEST_OFFER
	WHERE	OFFER_ID IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_OFFER_REFRESH_LOG
	WHERE	OFFER_ID_REFRESH IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_PRICING_REQUEST_FILES
	WHERE	REQUEST_ID = @PricingRequestId

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_PRICING_REQUEST_OFFER
	WHERE	REQUEST_ID = @PricingRequestId

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	OE_PRICING_REQUEST_ACCOUNTS
	WHERE	PRICING_REQUEST_ID = @PricingRequestId

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	lp_historical_info..ProspectDeals
	WHERE	DealID IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	lp_historical_info..ProspectAccounts
	WHERE	[Deal ID] IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	DELETE
	FROM	lp_historical_info..HistLoadByZone
	WHERE	deal_id IN ( SELECT OfferId FROM #OFFERIDS )

	IF @@ERROR <> 0
		SET @ErrorCount = @ErrorCount + 1

	IF @ErrorCount > 0
		BEGIN
			ROLLBACK TRAN CLEANUP
			PRINT 'There were errors during process. No records were deleted for pricing request ' + @PricingRequestId + '.'
		END
	ELSE
		BEGIN
			COMMIT TRAN CLEANUP
			PRINT 'Offers were successfully deleted for pricing request ' + @PricingRequestId + '.'
		END


	DROP TABLE #OFFERIDS

    SET NOCOUNT OFF
END                                                                                                                                              
-- Copyright 2008 Liberty Power

