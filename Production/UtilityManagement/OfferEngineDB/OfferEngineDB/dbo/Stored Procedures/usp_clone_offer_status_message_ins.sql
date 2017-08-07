




-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_offer_status_message_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

DECLARE	@w_ID			int,
		@w_STATUS		varchar(50),
		@w_MESSAGE		varchar(MAX),
		@w_DATE_CREATED	datetime,
		@w_row_count	int

CREATE TABLE #Message	(id int IDENTITY(1,1) NOT NULL, STATUS varchar(50), [MESSAGE] varchar(MAX), DATE_CREATED datetime)

INSERT INTO #Message
SELECT	STATUS, [MESSAGE], DATE_CREATED
FROM	OE_OFFER_STATUS_MESSAGE
WHERE	OFFER_ID = @p_offer_id

SELECT	TOP 1 @w_ID = ID, @w_STATUS = STATUS, @w_MESSAGE = [MESSAGE], @w_DATE_CREATED = DATE_CREATED
FROM	#Message

SET		@w_row_count = @@ROWCOUNT

WHILE	@w_row_count > 0
	BEGIN
		INSERT INTO	OE_OFFER_STATUS_MESSAGE (OFFER_ID, STATUS, [MESSAGE], DATE_CREATED)
		VALUES		(@p_offer_id_clone, @w_STATUS, @w_MESSAGE, @w_DATE_CREATED)

		DELETE FROM	#Message
		WHERE		ID = @w_ID

		SELECT	TOP 1 @w_ID = ID, @w_STATUS = STATUS, @w_MESSAGE = [MESSAGE], @w_DATE_CREATED = DATE_CREATED
		FROM	#Message

		SET		@w_row_count = @@ROWCOUNT
	END

DROP TABLE #Message

