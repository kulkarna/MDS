

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/23/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_file_del]

@p_pricing_id	int

AS

DECLARE	@w_menu_level			int,
		@w_pricing_id_parent	int

-- determine level for logic
SELECT	@w_menu_level = menu_level, @w_pricing_id_parent = pricing_id_parent
FROM	pricing
WHERE	pricing_id = @p_pricing_id

-- delete all sub-menu items
IF @w_menu_level = 0
	BEGIN
		CREATE TABLE #Level1 (pricing_id int)
		CREATE TABLE #Level2 (pricing_id int)

		INSERT INTO	#Level1
		SELECT		pricing_id
		FROM		pricing
		WHERE		pricing_id_parent = @p_pricing_id

		INSERT INTO	#Level2
		SELECT		pricing_id
		FROM		pricing
		WHERE		pricing_id_parent IN (SELECT pricing_id FROM #Level1)

		DELETE FROM	pricing
		WHERE		pricing_id IN (SELECT pricing_id FROM #Level1)
		OR			pricing_id IN (SELECT pricing_id FROM #Level2)

		DROP TABLE	#Level1
		DROP TABLE	#Level2
	END

-- changed sub-menu items' parent id and level to that of deleted item
IF @w_menu_level = 1
	BEGIN
		UPDATE	pricing
		SET		menu_level = @w_menu_level, pricing_id_parent = @w_pricing_id_parent
		WHERE	pricing_id_parent = @p_pricing_id
	END

DELETE FROM	pricing
WHERE		pricing_id = @p_pricing_id

DELETE FROM	pricing_role
WHERE		pricing_id = @p_pricing_id