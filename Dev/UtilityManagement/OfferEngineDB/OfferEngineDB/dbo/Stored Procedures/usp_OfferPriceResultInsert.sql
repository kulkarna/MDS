/*******************************************************************************
 * usp_OfferPriceResultInsert
 * Insert pricing data from pricing results file
 *
 * History
 *******************************************************************************
 * 2/23/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferPriceResultInsert]                                                                                
	@OfferId		varchar(50),
	@ProductType	varchar(50),
	@FlowStartDate	datetime,
	@Term			int,
	@Price			decimal(16,2),
	@DateExpire		datetime,
	@DateCreated	datetime
AS
BEGIN
    SET NOCOUNT ON
	
	DECLARE	@PriceRequestId	varchar(50),
			@Market			varchar(50),
			@MktId			int

	SELECT	TOP 1 @Market = a.MARKET
	FROM	OE_OFFER o
			INNER JOIN OE_OFFER_ACCOUNTS oa ON o.OFFER_ID = oa.OFFER_ID
			INNER JOIN OE_ACCOUNT a ON a.ACCOUNT_NUMBER = oa.ACCOUNT_NUMBER
	WHERE	o.OFFER_ID = @OfferId

	SELECT	@PriceRequestId = REQUEST_ID
	FROM	OE_PRICING_REQUEST_OFFER
	WHERE	OFFER_ID = @OfferId

	-- insert new record
	IF NOT EXISTS (	SELECT	NULL
					FROM	OE_OFFER_MARKET_PRICES_DETAIL
					WHERE	OFFER_ID		= @OfferId
					AND		FLOW_START_DATE	= @FlowStartDate
					AND		TERM			= @Term )
		BEGIN
			INSERT INTO	OE_OFFER_MARKET_PRICES_DETAIL 
						(REQUEST_ID, OFFER_ID, MARKET, FLOW_START_DATE, TERM, FINAL_PRICE, 
						SENT_TO_DEAL_CAPTURE, PRODUCT_TYPE, OFFER_EXPIRATION, OFFER_CREATED)
			 VALUES		(@PriceRequestId, @OfferId, @Market, @FlowStartDate, @Term, @Price, 0, 
						@ProductType, @DateExpire, @DateCreated)

			SET	@MktId = @@IDENTITY
		END
	-- update existing record
	ELSE
		BEGIN
			UPDATE	OE_OFFER_MARKET_PRICES_DETAIL
			SET		FINAL_PRICE			= @Price,
					PRODUCT_TYPE		= @ProductType, 
					OFFER_EXPIRATION	= @DateExpire,
					OFFER_CREATED		= @DateCreated
			WHERE	OFFER_ID			= @OfferId
			AND		FLOW_START_DATE		= @FlowStartDate
			AND		TERM				= @Term

			SELECT	@MktId = [ID]
			FROM	OE_OFFER_MARKET_PRICES_DETAIL
			WHERE	OFFER_ID			= @OfferId
			AND		FLOW_START_DATE		= @FlowStartDate
			AND		TERM				= @Term
		END

	-- insert/update components record
	EXEC usp_offer_component_details_ins_upd 
			@p_market_prices_detail_id	= @MktId,
			@p_total_cost				= @Price, 
			@p_fixed_price				= @Price,
			@p_price_type				= 'calculated'

    SET NOCOUNT OFF
END                                                                                                                                              
-- Copyright 2009 Liberty Power

