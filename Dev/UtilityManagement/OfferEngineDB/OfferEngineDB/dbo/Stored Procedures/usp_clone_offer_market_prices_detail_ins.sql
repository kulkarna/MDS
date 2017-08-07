




-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_offer_market_prices_detail_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

DECLARE	@w_ID					int,
		@w_REQUEST_ID			varchar(50),
		@w_MARKET				varchar(50),
		@w_FLOW_START_DATE		datetime,
		@w_TERM					int,
		@w_FINAL_PRICE			decimal(16,2),
		@w_SENT_TO_DEAL_CAPTURE	int,
		@w_row_count			int

CREATE TABLE #PricesDetail	(ID int IDENTITY(1,1) NOT NULL, REQUEST_ID varchar(50), 
							MARKET varchar(50), FLOW_START_DATE datetime, TERM int, 
							FINAL_PRICE decimal(16,2), SENT_TO_DEAL_CAPTURE int)

INSERT INTO #PricesDetail
SELECT		REQUEST_ID, MARKET, FLOW_START_DATE, TERM, FINAL_PRICE, SENT_TO_DEAL_CAPTURE
FROM		OE_OFFER_MARKET_PRICES_DETAIL
WHERE		OFFER_ID = @p_offer_id

SELECT	TOP 1 @w_ID = ID, @w_REQUEST_ID = REQUEST_ID, @w_MARKET = MARKET, @w_FLOW_START_DATE = FLOW_START_DATE, 
		@w_TERM = TERM, @w_FINAL_PRICE = FINAL_PRICE, @w_SENT_TO_DEAL_CAPTURE = SENT_TO_DEAL_CAPTURE
FROM	#PricesDetail

SET		@w_row_count = @@ROWCOUNT

WHILE	@w_row_count > 0
	BEGIN
		INSERT INTO	OE_OFFER_MARKET_PRICES_DETAIL (REQUEST_ID, OFFER_ID, MARKET, FLOW_START_DATE, 
					TERM, FINAL_PRICE, SENT_TO_DEAL_CAPTURE)
		VALUES		(@w_REQUEST_ID, @p_offer_id_clone, @w_MARKET, @w_FLOW_START_DATE, 
					@w_TERM, @w_FINAL_PRICE, @w_SENT_TO_DEAL_CAPTURE)

		DELETE FROM	#PricesDetail
		WHERE		ID = @w_ID

		SELECT	TOP 1 @w_ID = ID, @w_REQUEST_ID = REQUEST_ID, @w_MARKET = MARKET, @w_FLOW_START_DATE = FLOW_START_DATE, 
				@w_TERM = TERM, @w_FINAL_PRICE = FINAL_PRICE, @w_SENT_TO_DEAL_CAPTURE = SENT_TO_DEAL_CAPTURE
		FROM	#PricesDetail

		SET		@w_row_count = @@ROWCOUNT
	END

DROP TABLE #PricesDetail
