
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/27/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_del]

@p_pricing_request_id			varchar(50),
@p_offer_id						varchar(50)

AS

DECLARE	@w_has_error			int,
		@w_flow_start_date_id	varchar(50)

SET		@w_has_error			= 0

BEGIN TRAN	offer_delete

-- pricing request offer
	DELETE FROM	OE_PRICING_REQUEST_OFFER
	WHERE		REQUEST_ID	= @p_pricing_request_id 
	AND			OFFER_ID	= @p_offer_id

	IF @@ERROR <> 0
		SET @w_has_error = 1

-- offer
	DELETE FROM	OE_OFFER
	WHERE		OFFER_ID	= @p_offer_id

	IF @@ERROR <> 0
		SET @w_has_error = 1

-- offer accounts
	DELETE FROM	OE_OFFER_ACCOUNTS
	WHERE		OFFER_ID	= @p_offer_id

	IF @@ERROR <> 0
		SET @w_has_error = 1

-- terms and prices
	DECLARE curFlow CURSOR FOR
		SELECT	FLOW_START_DATE_ID
		FROM	OE_OFFER_FLOW_DATES WITH (NOLOCK)
		WHERE	OFFER_ID = @p_offer_id
	OPEN curFlow 
	FETCH NEXT FROM curFlow INTO @w_flow_start_date_id
	WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
			DELETE FROM	OE_TERMS_AND_PRICES
			WHERE		FLOW_START_DATE_ID	= @w_flow_start_date_id

			IF @@ERROR <> 0
				SET @w_has_error = 1

			FETCH NEXT FROM curFlow INTO @w_flow_start_date_id
		END
	CLOSE curFlow 
	DEALLOCATE curFlow

-- flow start dates
	DELETE FROM	OE_OFFER_FLOW_DATES
	WHERE		OFFER_ID = @p_offer_id

	IF @@ERROR <> 0
		SET @w_has_error = 1

-- market
	DELETE FROM	OE_OFFER_MARKETS
	WHERE		OFFER_ID = @p_offer_id

	IF @@ERROR <> 0
		SET @w_has_error = 1

-- utilities
	DELETE FROM	OE_OFFER_UTILITIES
	WHERE		OFFER_ID = @p_offer_id

	IF @@ERROR <> 0
		SET @w_has_error = 1


IF @w_has_error = 0
	BEGIN
		COMMIT TRAN offer_delete
		SELECT 0
	END
ELSE
	BEGIN
		ROLLBACK TRAN offer_delete
		SELECT 1
	END



