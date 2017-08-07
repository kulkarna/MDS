CREATE proc [dbo].[usp_RoleGetAll]     
as      
Select     
	RoleID,    
	RoleName,    
	DateCreated,  
	DateModified,  
	CreatedBy,  
	ModifiedBy,
	Description
From Role
 
 
