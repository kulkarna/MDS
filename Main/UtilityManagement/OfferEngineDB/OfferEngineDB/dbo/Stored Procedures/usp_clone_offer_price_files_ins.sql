



-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_offer_price_files_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

DECLARE	@w_ID						int,
		@w_REQUEST_ID				varchar(50),
		@w_FILE_NAME				varchar(100),
		@w_FILE_TYPE				varchar(50),
		@w_DATE_CREATED				datetime,
		@w_row_count				int

CREATE TABLE #PriceFiles	(ID int IDENTITY(1,1) NOT NULL, REQUEST_ID varchar(50), 
							[FILE_NAME] varchar(100), FILE_TYPE  varchar(50), DATE_CREATED datetime)

INSERT INTO #PriceFiles
SELECT		REQUEST_ID, [FILE_NAME], FILE_TYPE, DATE_CREATED
FROM		OE_OFFER_PRICE_FILES
WHERE		OFFER_ID = @p_offer_id	

SELECT	TOP 1 @w_ID = ID, @w_REQUEST_ID = REQUEST_ID, @w_FILE_NAME = [FILE_NAME], 
		@w_FILE_TYPE = FILE_TYPE, @w_DATE_CREATED = DATE_CREATED
FROM	#PriceFiles

SET		@w_row_count = @@ROWCOUNT

WHILE	@w_row_count > 0
	BEGIN
		INSERT INTO	OE_OFFER_PRICE_FILES (REQUEST_ID, OFFER_ID, [FILE_NAME], FILE_TYPE, DATE_CREATED)
		VALUES		(@w_REQUEST_ID, @p_offer_id_clone, @w_FILE_NAME, @w_FILE_TYPE, @w_DATE_CREATED)

		DELETE FROM	#PriceFiles
		WHERE		ID = @w_ID

		SELECT	TOP 1 @w_ID = ID, @w_REQUEST_ID = REQUEST_ID, @w_FILE_NAME = [FILE_NAME], 
		@w_FILE_TYPE = FILE_TYPE, @w_DATE_CREATED = DATE_CREATED
		FROM	#PriceFiles

		SET		@w_row_count = @@ROWCOUNT
	END

DROP TABLE #PriceFiles
