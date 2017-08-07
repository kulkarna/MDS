CREATE proc [dbo].[usp_RoleGetByActivityKey] (@ActivityKey int)      
as      
Select r.RoleID,    
	r.RoleName,    
	r.DateCreated,  
	r.DateModified,  
	r.CreatedBy,  
	r.ModifiedBY,
	r.Description  
From ActivityRole ar
Join Role r on ar.RoleId = r.RoleId
where ActivityID = @ActivityKey
