
CREATE PROCEDURE [dbo].[usp_RemoveRoleFromAllUsers] 
( 
	@RoleID int
)    
AS    
BEGIN
 SET NOCOUNT ON;
 DELETE FROM UserRole
 WHERE roleId = @RoleID
 SET NOCOUNT OFF;
END