


CREATE proc [dbo].[usp_UserRoleRemoveAllRoles] (@UserID int)
as

Delete from UserRole
where UserID = @UserID

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
 where u.UserID = @UserID  

