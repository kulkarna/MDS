
-- =============================================
-- Author:		Rick Deigsler
-- Create date: //
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_mkt_prices_ins_upd]

@p_pricing_request_id		varchar(50),
@p_offer_id					varchar(50),
@p_retail_mkt_id			varchar(50),
@p_flow_start_date			datetime,
@p_term						int,
@p_final_price				decimal(16,2),
@p_sent_to_deal_capture		int

AS

IF NOT EXISTS (	SELECT	NULL
				FROM	OE_OFFER_MARKET_PRICES_DETAIL WITH (NOLOCK)
				WHERE	REQUEST_ID		= @p_pricing_request_id
				AND		OFFER_ID		= @p_offer_id
				AND		MARKET			= @p_retail_mkt_id
				AND		FLOW_START_DATE	= @p_flow_start_date
				AND		TERM			= @p_term )
	BEGIN
		INSERT INTO	OE_OFFER_MARKET_PRICES_DETAIL
					(REQUEST_ID, OFFER_ID, MARKET, FLOW_START_DATE, TERM, FINAL_PRICE, SENT_TO_DEAL_CAPTURE)
		VALUES		(@p_pricing_request_id, @p_offer_id, @p_retail_mkt_id, @p_flow_start_date, 
					@p_term, @p_final_price, @p_sent_to_deal_capture)
	END
ELSE
	BEGIN
		UPDATE	OE_OFFER_MARKET_PRICES_DETAIL
		   SET	REQUEST_ID				= @p_pricing_request_id,
				OFFER_ID				= @p_offer_id,
				MARKET					= @p_retail_mkt_id,
				FLOW_START_DATE			= @p_flow_start_date,
				TERM					= @p_term,
				FINAL_PRICE				= @p_final_price,
				SENT_TO_DEAL_CAPTURE	= @p_sent_to_deal_capture
		WHERE	REQUEST_ID				= @p_pricing_request_id
		AND		OFFER_ID				= @p_offer_id
		AND		MARKET					= @p_retail_mkt_id
		AND		FLOW_START_DATE			= @p_flow_start_date
		AND		TERM					= @p_term
	END

