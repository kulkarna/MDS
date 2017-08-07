  
  
--exec usp_ActivityGetByUserIDAppKey @UserID=185
    
CREATE proc [dbo].[usp_ActivityGetByUserIDAppKey]
(
	@UserID int,  
	@AppKey varchar (20) = null
)        
As        

Select     
	a.ActivityKey, a.ActivityDesc, a.AppKey, a.DateCreated,    
	r.RoleName,     
	r.RoleID,    
	u.UserID,    
	u.UserName,    
	u.Firstname,    
	u.Lastname,    
	u.Email,    
	u.Password ,  
	u.DateCreated,  
	u.DateModified,  
	u.CreatedBy,  
	u.ModifiedBy,  
	u.LegacyID,  
	u.UserType,
	U.IsActive      
From [User] u    
join UserRole ur  on U.UserID = ur.UserID     
join Role r on r.RoleID = ur.RoleID    
join ActivityRole ar on  r.RoleID= ar.RoleiD    
left outer join Activity a on ar.ActivityID = a.ActivityKey        
         
Where u.UserID = @UserID     
And (a.AppKey = @AppKey OR @AppKey is null)


     
