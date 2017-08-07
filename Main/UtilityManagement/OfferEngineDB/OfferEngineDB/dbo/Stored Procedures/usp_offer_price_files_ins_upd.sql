
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/14/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_price_files_ins_upd]

@p_price_request_id		varchar(50),
@p_offer_id				varchar(50),
@p_file_name			varchar(100),
@p_file_type			varchar(50)

AS

IF NOT EXISTS (	SELECT	NULL
				FROM	OE_OFFER_PRICE_FILES WITH (NOLOCK)
				WHERE	REQUEST_ID	= @p_price_request_id
				AND		OFFER_ID	= @p_offer_id
				AND		FILE_TYPE	= @p_file_type )
	BEGIN
		INSERT INTO	OE_OFFER_PRICE_FILES (REQUEST_ID, OFFER_ID, [FILE_NAME], FILE_TYPE)
		VALUES		(@p_price_request_id, @p_offer_id, @p_file_name, @p_file_type)
	END
ELSE
	BEGIN
		UPDATE	OE_OFFER_PRICE_FILES
		SET		[FILE_NAME] = @p_file_name
		WHERE	REQUEST_ID	= @p_price_request_id
		AND		OFFER_ID	= @p_offer_id
		AND		FILE_TYPE	= @p_file_type
	END

