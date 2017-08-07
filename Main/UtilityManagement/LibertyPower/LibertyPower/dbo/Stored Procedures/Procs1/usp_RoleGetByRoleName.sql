CREATE proc [dbo].[usp_RoleGetByRoleName] (@RoleName varchar(50))      
as      
select     
RoleID,    
RoleName,    
DateCreated,  
DateModified,  
CreatedBy,  
ModifiedBY,
Description  
 from Role      
where RoleName = @RoleName
