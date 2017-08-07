




-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_offer_flow_dates_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

DECLARE	@w_ID							int,
		@w_ID_TERMS						int,
		@w_FLOW_START_DATE_ID			nvarchar(50),
		@w_FLOW_START_DATE_ID_CLONE		nvarchar(50),
		@w_FLOW_START_DATE				datetime,
		@w_TERMS_AND_PRICES_ID_CLONE	varchar(50),
		@w_TERM							int,
		@w_PRICE						decimal(16,2),
		@w_row_count					int,
		@w_row_count_terms				int			

CREATE TABLE #FlowDates	(ID int IDENTITY(1,1) NOT NULL, FLOW_START_DATE_ID nvarchar(50), FLOW_START_DATE datetime)
CREATE TABLE #Terms	(ID int IDENTITY(1,1) NOT NULL, TERM int, PRICE decimal(16,2))

INSERT INTO #FlowDates
SELECT		FLOW_START_DATE_ID, FLOW_START_DATE
FROM		OE_OFFER_FLOW_DATES
WHERE		OFFER_ID = @p_offer_id	

SELECT	TOP 1 @w_ID = ID, @w_FLOW_START_DATE_ID = FLOW_START_DATE_ID, @w_FLOW_START_DATE = FLOW_START_DATE
FROM	#FlowDates

SET		@w_row_count = @@ROWCOUNT

WHILE	@w_row_count > 0
	BEGIN
		-- get new flow start date id
		EXEC usp_clone_generate_id 'FLOW_START_DATE_ID', @w_FLOW_START_DATE_ID_CLONE output

		INSERT INTO	OE_OFFER_FLOW_DATES (FLOW_START_DATE_ID, OFFER_ID, FLOW_START_DATE)
		VALUES		(@w_FLOW_START_DATE_ID_CLONE, @p_offer_id_clone, @w_FLOW_START_DATE)

		-- term and prices
		INSERT INTO #Terms
		SELECT	TERM, PRICE
		FROM	OE_TERMS_AND_PRICES WITH (NOLOCK)
		WHERE	FLOW_START_DATE_ID = @w_FLOW_START_DATE_ID

		SELECT	TOP 1 @w_ID_TERMS = ID, @w_TERM = TERM, @w_PRICE = PRICE
		FROM	#Terms

		SET		@w_row_count_terms = @@ROWCOUNT

		WHILE	@w_row_count_terms > 0
			BEGIN

				-- get new terms and prices id
				EXEC usp_clone_generate_id 'TERMS_AND_PRICES_ID', @w_TERMS_AND_PRICES_ID_CLONE output

				INSERT INTO OE_TERMS_AND_PRICES (TERMS_AND_PRICES_ID, FLOW_START_DATE_ID, TERM, PRICE)
				VALUES		(@w_TERMS_AND_PRICES_ID_CLONE, @w_FLOW_START_DATE_ID_CLONE, @w_TERM, @w_PRICE)

				DELETE FROM	#Terms
				WHERE		ID = @w_ID_TERMS

				SELECT	TOP 1 @w_ID_TERMS = ID, @w_TERM = TERM, @w_PRICE = PRICE
				FROM	#Terms

				SET		@w_row_count_terms = @@ROWCOUNT
			END

		DELETE FROM	#FlowDates
		WHERE		ID = @w_ID

		SELECT	TOP 1 @w_ID = ID, @w_FLOW_START_DATE_ID = FLOW_START_DATE_ID, @w_FLOW_START_DATE = FLOW_START_DATE
		FROM	#FlowDates

		SET		@w_row_count = @@ROWCOUNT
	END

DROP TABLE #FlowDates


