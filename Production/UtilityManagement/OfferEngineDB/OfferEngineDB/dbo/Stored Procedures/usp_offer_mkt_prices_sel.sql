
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/25/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_mkt_prices_sel]

@p_offer_id		varchar(50)

AS

SELECT	ID, REQUEST_ID, OFFER_ID, MARKET, FLOW_START_DATE, TERM, FINAL_PRICE, SENT_TO_DEAL_CAPTURE
FROM	OE_OFFER_MARKET_PRICES_DETAIL WITH (NOLOCK)
WHERE	OFFER_ID = @p_offer_id



