/*
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/17/2008
-- Description:	Pull data for creating pricing sheet links
-- =============================================
*******************************************************************************
* 04/26/2012 - Jose Munoz - SWCS
* Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
		and use the new table in libertypower database
*******************************************************************************

EXEC [usp_pricing_files_sel] 'libertypower\jmunoz'
EXEC [usp_pricing_files_sel_jmunoz] 'libertypower\jmunoz'

*/
CREATE PROCEDURE [dbo].[usp_pricing_files_sel_jmunoz]

@p_username		varchar(100), 
@p_is_editing	smallint	= 0

AS
SET NOCOUNT ON
DECLARE	@w_pricing_id1	int,
		@w_pricing_id2	int,
		@w_pricing_id3	int,
		@w_row_count1	int,
		@w_row_count2	int,
		@w_row_count3	int

CREATE TABLE #Pricing1		(pricing_id int, retail_mkt_id char(2), utility_id varchar(20), 
							display_name varchar(100), [file_name] varchar(200), file_path varchar(200), 
							link varchar(200), file_type int, has_sub_menu tinyint, menu_level int, pricing_id_parent int)

CREATE TABLE #Pricing2		(pricing_id int, retail_mkt_id char(2), utility_id varchar(20), 
							display_name varchar(100), [file_name] varchar(200), file_path varchar(200), 
							link varchar(200), file_type int, has_sub_menu tinyint, menu_level int, pricing_id_parent int)

CREATE TABLE #PricingSorted	(pricing_id int, retail_mkt_id char(2), utility_id varchar(20), 
							display_name varchar(100), [file_name] varchar(200), file_path varchar(200), 
							link varchar(200), file_type int, has_sub_menu tinyint, menu_level int, pricing_id_parent int)

CREATE TABLE #Roles			(pricing_id int, role_id int)

-- check if user has administrator role.
-- if so treat as if editing, display all records
IF EXISTS (	SELECT	NULL
			FROM	libertypower..[UserRole] u WITH (NOLOCK)
					INNER JOIN libertypower..[Role] r WITH (NOLOCK) ON u.RoleID = r.RoleID
			WHERE	u.UserID = (	SELECT	UserID
									FROM	libertypower..[User] WITH (NOLOCK INDEX = User__Username_I)
									WHERE	Username = @p_username )
			AND		r.RoleName LIKE '%admin%' )
	BEGIN
		SET @p_is_editing = 1
	END

-- not editing, show only records for applicable roles
IF @p_is_editing = 0
	BEGIN
		INSERT INTO	#Roles
		SELECT	p.pricing_id, p.role_id
		FROM	libertypower..[UserRole]	u WITH (NOLOCK)
		INNER JOIN libertypower..[Role]		r WITH (NOLOCK) ON u.RoleID = r.RoleID
		INNER JOIN pricing_role p WITH (NOLOCK) ON r.RoleID = p.role_id
		WHERE	u.UserID = (	SELECT	UserID
								FROM	libertypower..[User] WITH (NOLOCK INDEX = User__Username_I)
								WHERE	Username = @p_username )
	END

-- get root elements
IF @p_is_editing = 0
	BEGIN
		INSERT INTO	#Pricing1
		SELECT		pricing_id, retail_mkt_id, utility_id, display_name, 
					[file_name], file_path, link, file_type, has_sub_menu, menu_level, pricing_id_parent
		FROM		pricing WITH (NOLOCK)
		WHERE		pricing_id_parent = 0
		AND			pricing_id IN (SELECT pricing_id FROM #Roles)
		ORDER BY	display_name
	END
ELSE
	BEGIN
		INSERT INTO	#Pricing1
		SELECT		pricing_id, retail_mkt_id, utility_id, display_name, 
					[file_name], file_path, link, file_type, has_sub_menu, menu_level, pricing_id_parent
		FROM		pricing WITH (NOLOCK)
		WHERE		pricing_id_parent = 0
		ORDER BY	display_name
	END

SET		@w_row_count1 = @@ROWCOUNT

WHILE	@w_row_count1 <> 0
	BEGIN
		-- get pricing id for record to determine if there are any sub items
		SELECT	TOP 1 @w_pricing_id1 = pricing_id
		FROM	#Pricing1

		-- sorted records  -------------------------------------------------------------
		INSERT INTO	#PricingSorted
		SELECT		pricing_id, retail_mkt_id, utility_id, display_name, 
					[file_name], file_path, link, file_type, has_sub_menu, menu_level, pricing_id_parent
		FROM		#Pricing1
		WHERE		pricing_id = @w_pricing_id1

		-- sub level 1
		IF @p_is_editing = 0
			BEGIN
				INSERT INTO	#Pricing2
				SELECT		pricing_id, retail_mkt_id, utility_id, display_name, 
							[file_name], file_path, link, file_type, has_sub_menu, menu_level, pricing_id_parent
				FROM		pricing WITH (NOLOCK)
				WHERE		pricing_id_parent = @w_pricing_id1
				AND			pricing_id IN (SELECT pricing_id FROM #Roles)
				ORDER BY	display_name
			END
		ELSE
			BEGIN
				INSERT INTO	#Pricing2
				SELECT		pricing_id, retail_mkt_id, utility_id, display_name, 
							[file_name], file_path, link, file_type, has_sub_menu, menu_level, pricing_id_parent
				FROM		pricing WITH (NOLOCK)
				WHERE		pricing_id_parent = @w_pricing_id1
				ORDER BY	display_name
			END

		SET		@w_row_count2 = @@ROWCOUNT

		WHILE	@w_row_count2 <> 0
			BEGIN
				-- get pricing id for record to determine if there are any sub items
				SELECT	TOP 1 @w_pricing_id2 = pricing_id
				FROM	#Pricing2

				INSERT INTO	#PricingSorted
				SELECT		pricing_id, retail_mkt_id, utility_id, display_name, 
							[file_name], file_path, link, file_type, has_sub_menu, menu_level, pricing_id_parent
				FROM		#Pricing2
				WHERE		pricing_id = @w_pricing_id2

				-- sub level 2
				IF @p_is_editing = 0
					BEGIN
						INSERT INTO	#PricingSorted
						SELECT		pricing_id, retail_mkt_id, utility_id, display_name, 
									[file_name], file_path, link, file_type, has_sub_menu, menu_level, pricing_id_parent
						FROM		pricing WITH (NOLOCK)
						WHERE		pricing_id_parent = @w_pricing_id2
						AND			pricing_id IN (SELECT pricing_id FROM #Roles)
						ORDER BY	display_name
					END
				ELSE
					BEGIN
						INSERT INTO	#PricingSorted
						SELECT		pricing_id, retail_mkt_id, utility_id, display_name, 
									[file_name], file_path, link, file_type, has_sub_menu, menu_level, pricing_id_parent
						FROM		pricing WITH (NOLOCK)
						WHERE		pricing_id_parent = @w_pricing_id2
						ORDER BY	display_name
					END


				DELETE FROM	#Pricing2
				WHERE		pricing_id = @w_pricing_id2

				SELECT @w_row_count2 = COUNT(pricing_id) FROM #Pricing2
			END

		DELETE FROM	#Pricing1
		WHERE		pricing_id = @w_pricing_id1

		SELECT @w_row_count1 = COUNT(pricing_id) FROM #Pricing1
	END

SELECT		*
FROM		#PricingSorted

DROP TABLE	#Pricing1
DROP TABLE	#Pricing2
DROP TABLE	#PricingSorted
DROP TABLE	#Roles

SET NOCOUNT OFF
