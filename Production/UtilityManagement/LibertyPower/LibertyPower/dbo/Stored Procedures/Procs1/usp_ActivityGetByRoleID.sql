
  
CREATE proc [dbo].[usp_ActivityGetByRoleID] ( @RoleID int)    
as    
select ActivityKey,  
a.ActivityDesc,  
a.AppKey,  
a.DateCreated,  
a.DateModified,  
a.CreatedBy,  
a.ModifiedBy   
from Activity  a
inner join ActivityRole   
on ActivityROle.ActivityID = a.ActivityKey
where  ActivityRole.RoleID = @RoleID 

