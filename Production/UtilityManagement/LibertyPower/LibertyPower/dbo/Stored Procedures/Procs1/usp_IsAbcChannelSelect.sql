/*******************************************************************************
 * usp_IsAbcChannelSelect
 * Returns true or false, is an ABC channel or not
 *
 * History
 *******************************************************************************
 * 7/21/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_IsAbcChannelSelect]
	@SalesChannelRole	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE @Username	varchar(100),
			@UserId		int, 
			@RoleId		int
			
	SET	@Username = REPLACE(@SalesChannelRole, 'Sales Channel/', 'libertypower\')


	SELECT	@UserId = UserID  
	FROM	lp_portal..Users with (NOLOCK INDEX = IX_Users)  
	WHERE	Username = @Username  

	SELECT	@RoleId = RoleID
	FROM	lp_portal..Roles
	WHERE	RoleName = 'ABC flexible pricing'

	IF EXISTS (SELECT * FROM lp_portal..UserRoles WHERE UserID = @UserId AND RoleID = @RoleId)
		SELECT 'TRUE'
	ELSE
		SELECT 'FALSE'
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
