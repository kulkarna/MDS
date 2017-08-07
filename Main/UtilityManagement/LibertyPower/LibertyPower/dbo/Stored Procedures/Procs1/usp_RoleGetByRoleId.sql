CREATE proc [dbo].[usp_RoleGetByRoleId] (@RoleId int)      
as      
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
