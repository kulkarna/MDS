







-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/21/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_file_ins_upd]

@p_pricing_id			int,
@p_retail_mkt_id		varchar(2),
@p_utility_id			varchar(20),
@p_display_name			varchar(100),
@p_file_name			varchar(200),
@p_file_path			varchar(200),
@p_link					varchar(200),
@p_file_type			int,
@p_has_sub_menu			int,
@p_menu_level			int,
@p_pricing_id_parent	int,
@p_pricing_id_new		int	OUTPUT

AS

DECLARE	@w_retail_mkt_id		varchar(2),
		@w_utility_id			varchar(20),
		@w_display_name			varchar(100),
		@w_file_name			varchar(200),
		@w_file_path			varchar(200),
		@w_link					varchar(200),
		@w_file_type			int,
		@w_has_sub_menu			int,
		@w_menu_level			int,
		@w_pricing_id_parent	int

SET		@p_pricing_id_new		= 0

IF @p_pricing_id = 0
	BEGIN
		INSERT INTO	pricing
				   (retail_mkt_id, utility_id, display_name, [file_name], 
					file_path, link, file_type, has_sub_menu, menu_level, pricing_id_parent)
		VALUES		(@p_retail_mkt_id, @p_utility_id, @p_display_name, @p_file_name, 
					@p_file_path, @p_link, @p_file_type, @p_has_sub_menu, @p_menu_level + 1, @p_pricing_id_parent)

		SET			@p_pricing_id_new = @@IDENTITY
	END
ELSE
	BEGIN
		-- determine state of link before update
		SELECT	@w_has_sub_menu = has_sub_menu, 
				@w_menu_level = menu_level, @w_pricing_id_parent = pricing_id_parent
		FROM	pricing
		WHERE	pricing_id = @p_pricing_id

		-- dropping sub-menus, change parent ids and levels of submenu items
		IF @p_has_sub_menu = 0 AND @w_has_sub_menu = 1
			BEGIN
				UPDATE	pricing
				SET		menu_level = CASE WHEN menu_level = 0 THEN menu_level ELSE (menu_level - 1) END, 
						pricing_id_parent = @w_pricing_id_parent
				WHERE	pricing_id_parent = @p_pricing_id
			END

		-- creating sub-menu link, change parent ids and levels of submenu items
		IF @p_has_sub_menu = 1 AND @w_has_sub_menu = 0
			BEGIN
				UPDATE	pricing
				SET		menu_level = (SELECT menu_level FROM pricing WHERE pricing_id = @w_pricing_id_parent), 
						pricing_id_parent = (SELECT pricing_id_parent FROM pricing WHERE pricing_id = @w_pricing_id_parent)
				WHERE	pricing_id = @p_pricing_id
			END

		UPDATE	pricing
		SET		retail_mkt_id = @p_retail_mkt_id, utility_id = @p_utility_id, display_name = @p_display_name, 
				[file_name] = @p_file_name, file_path = @p_file_path, link = @p_link, file_type = @p_file_type, has_sub_menu = @p_has_sub_menu
		WHERE	pricing_id = @p_pricing_id
	END

-- replace string with pricing id for any new sub-menu links
UPDATE	pricing
SET		link = REPLACE(link, '***PricingID***', pricing_id)


