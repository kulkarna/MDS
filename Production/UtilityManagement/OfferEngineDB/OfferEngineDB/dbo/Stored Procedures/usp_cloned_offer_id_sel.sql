
/*******************************************************************************
 * usp_cloned_offer_id_sel
 * copied from usp_clone_offer_id_sel but without logging (ticket 9753)
 *
 * History
 *******************************************************************************
 * 09/16/2009 - Eduardo Patino
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_cloned_offer_id_sel]
	@p_offer_id			varchar(50),
	@p_original			int
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE	@original_offer_id	varchar(50)
		DECLARE	@p_offer_id_clone	varchar(50)

		-- determine if this is an additional refresh
		SELECT	@p_offer_id_clone = OFFER_ID
		FROM	OE_OFFER_REFRESH_LOG
		WHERE	OFFER_ID_REFRESH = @p_offer_id

		-- is an additional refresh
		IF @p_offer_id_clone IS NOT NULL
			SET	@p_offer_id = @p_offer_id_clone

		--IF EXISTS (	SELECT NULL FROM OE_KEYS_OFFER_REFRESH WHERE OFFER_ID = @p_offer_id )
		--	BEGIN
		--		UPDATE	OE_KEYS_OFFER_REFRESH
		--		SET		OFFER_SUB_ID	= OFFER_SUB_ID + 1
		--		WHERE	OFFER_ID		= @p_offer_id
		--	END
		--ELSE
		--	BEGIN
		--		INSERT INTO	OE_KEYS_OFFER_REFRESH (OFFER_ID, OFFER_SUB_ID)
		--		VALUES		(@p_offer_id, 1)
		--	END

		SELECT	@original_offer_id = OFFER_ID, @p_offer_id_clone = (OFFER_ID + '-' + RIGHT('000' + CAST(OFFER_SUB_ID AS varchar(3)), 3))
		FROM	OE_KEYS_OFFER_REFRESH
		WHERE	OFFER_ID		= @p_offer_id

		IF @p_original = 0
			SELECT	@p_offer_id_clone offer_id_clone
		ELSE
			SELECT	@original_offer_id original_offer_id

		--INSERT INTO	OE_OFFER_REFRESH_LOG (OFFER_ID, OFFER_ID_REFRESH)
		--VALUES		(@p_offer_id, @p_offer_id_clone)
	SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power


