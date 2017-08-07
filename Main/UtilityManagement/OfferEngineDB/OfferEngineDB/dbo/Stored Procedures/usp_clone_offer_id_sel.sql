


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/16/2008
-- Description:	Generate new refresh offer id
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_offer_id_sel]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)	OUTPUT

AS

DECLARE	@w_offer_id_orig	varchar(50)

-- determine if this is an additional refresh
SELECT	@w_offer_id_orig = OFFER_ID
FROM	OE_OFFER_REFRESH_LOG
WHERE	OFFER_ID_REFRESH = @p_offer_id

-- is an additional refresh
IF @w_offer_id_orig IS NOT NULL
	SET	@p_offer_id = @w_offer_id_orig


IF EXISTS (	SELECT NULL FROM OE_KEYS_OFFER_REFRESH WHERE OFFER_ID = @p_offer_id )
	BEGIN
		UPDATE	OE_KEYS_OFFER_REFRESH
		SET		OFFER_SUB_ID	= OFFER_SUB_ID + 1
		WHERE	OFFER_ID		= @p_offer_id
	END
ELSE
	BEGIN
		INSERT INTO	OE_KEYS_OFFER_REFRESH (OFFER_ID, OFFER_SUB_ID)
		VALUES		(@p_offer_id, 1)
	END

SELECT	@p_offer_id_clone = (OFFER_ID + '-' + RIGHT('000' + CAST(OFFER_SUB_ID AS varchar(3)), 3))
FROM	OE_KEYS_OFFER_REFRESH
WHERE	OFFER_ID		= @p_offer_id

INSERT INTO	OE_OFFER_REFRESH_LOG (OFFER_ID, OFFER_ID_REFRESH)
VALUES		(@p_offer_id, @p_offer_id_clone)
