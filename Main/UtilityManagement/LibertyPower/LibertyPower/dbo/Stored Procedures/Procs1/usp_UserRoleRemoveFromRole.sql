
CREATE PROCEDURE [dbo].[usp_UserRoleRemoveFromRole]      
(    
    @RoleID int,      
    @UserID int      
)    
AS      
delete UserRole    
where      
     RoleID = @RoleID      
 and      
    UserID = @UserID      
         
select r.RoleName,     
		r.RoleID, 
		ur.DateCreated,    
		u.UserID,    
		u.UserName,    
		u.Firstname,    
		u.Lastname,    
		u.Email,    
		u.Password,  
		u.dateCreated,  
		u.DateModified,  
		u.CreatedBy,  
		u.ModifiedBy,
		u.LegacyID,
		u.UserType,
		u.IsActive    
 from  [User] u     
LEFT outer join UserRole ur on  u.UserID = ur.UserID    
LEFT outer join Role r on ur.RoleID =r.RoleID    
where u.UserID = @UserID    
    
    
    
     
    
    
    
    
    
