
CREATE PROCEDURE [dbo].[usp_UserGetAssignedToRole] 
( 
	@RoleID int
)    
AS    
BEGIN
 SET NOCOUNT ON;
 SELECT a.UserID,    
		a.UserName,    
		a.[Password],    
		a.Firstname,    
		a.Lastname,    
		a.Email,    
		a.DateCreated,
		a.DateModified,
		a.CreatedBy,
		a.ModifiedBy,
		a.UserType,
		a.LegacyID,
		a.IsActive 
 FROM  [User] a join
	   UserRole b on a.UserID = b.UserID
 WHERE b.roleId = @RoleID
 SET NOCOUNT OFF;
END