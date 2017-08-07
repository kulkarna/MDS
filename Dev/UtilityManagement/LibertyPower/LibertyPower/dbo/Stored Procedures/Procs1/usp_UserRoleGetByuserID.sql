  
     
CREATE PROCEDURE [dbo].[usp_UserRoleGetByuserID]          
    (      
         
    @UserID int        
)      
           
AS          
      
select r.RoleName,       
		r.RoleID, ur.DateCreated,      
		u.UserID,      
		u.UserName,      
		u.Firstname,      
		u.Lastname,      
		u.Email,      
		u.Password,    
		 u.CreatedBy,   
		u.ModifiedBy,   
		u.DateModified,   
		u.LegacyID,  
		u.UserType ,
		u.IsActive   
From [User] u 
left outer join userRole ur on  u.UserID = ur.UserID   
left outer join  [Role] r on ur.RoleID = r.RoleID    
     
 where u.UserID = @UserID    
      
      
      
      
      
      
