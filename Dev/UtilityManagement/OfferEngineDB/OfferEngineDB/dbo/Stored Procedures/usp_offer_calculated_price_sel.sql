
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/12/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_calculated_price_sel]

@p_pricing_request_id		varchar(50),
@p_offer_id					varchar(50),
@p_retail_mkt_id			varchar(50),
@p_flow_start_date			datetime,
@p_term						int

AS

DECLARE	@p_fixed_price		float

SELECT	@p_fixed_price			= FIXED_PRICE
FROM	OE_OFFER_COMPONENT_DETAILS WITH (NOLOCK)
WHERE	PRICE_TYPE				= 'calculated'
AND		MARKET_PRICES_DETAIL_ID = 
		(
			SELECT	ID
			FROM	OE_OFFER_MARKET_PRICES_DETAIL WITH (NOLOCK)
			WHERE	REQUEST_ID		= @p_pricing_request_id
			AND		OFFER_ID		= @p_offer_id
			AND		MARKET			= @p_retail_mkt_id
			AND		FLOW_START_DATE	= @p_flow_start_date
			AND		TERM			= @p_term 
		)

IF @p_fixed_price IS NOT NULL
	BEGIN
		SELECT	@p_fixed_price
	END
ELSE
	BEGIN
		SELECT 0
	END



