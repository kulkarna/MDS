
      
        
CREATE PROCEDURE [dbo].[usp_UserRoleInsert]        
    (    
 @RoleID int,        
    @UserID int,    
 @CreatedBy int    
)    
         
AS        
DECLARE @UserRole INT
select @UserRole = UserRoleID from UserRole where RoleID = @RoleID and UserID = @UserID
if (@UserRole is null)       
BEGIN 
INSERT INTO [UserRole] (        
     RoleID,        
    UserID,    
 CreatedBy,    
 ModifiedBy)        
VALUES (        
    @RoleID,        
    @UserID,    
 @CreatedBy,    
 @CreatedBy)    
 
 set @UserRole = SCOPE_IDENTITY()
 
 END
   
select r.RoleName,     
	r.RoleID,  ur.DateCreated,    
	u.UserID,    
	u.UserName,    
	u.Firstname,    
	u.Lastname,    
	u.Email,    
	u.CreatedBy,    
	u.ModifiedBy,  
	u.DateModified,    
	u.Password,
	u.LegacyID,
	u.UserType,
	u.IsActive  
 from Role r    
inner join userRole ur on ur.RoleID =r.RoleID    
left outer join [User] u on  u.UserID = ur.UserID    
 where ur.UserRoleID = @UserRole
    
    
    
    
    
    
    
        
     
