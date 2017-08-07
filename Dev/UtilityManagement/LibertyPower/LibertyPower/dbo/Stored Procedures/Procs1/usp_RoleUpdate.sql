
CREATE PROCEDURE [dbo].[usp_RoleUpdate]
    @RoleID int,
    @RoleName varchar(50),
    @Description varchar(100) = null,
    @ModifiedBy int = 1
    
AS
UPDATE [Role]
SET
    RoleName = @RoleName,
    Description = @Description,
    ModifiedBy = @ModifiedBy
Where RoleID = @RoleID


Select     
	RoleID,    
	RoleName,    
	DateCreated,  
	DateModified,  
	CreatedBy,  
	ModifiedBY,
	Description  
From Role      
Where RoleID = @RoleId
