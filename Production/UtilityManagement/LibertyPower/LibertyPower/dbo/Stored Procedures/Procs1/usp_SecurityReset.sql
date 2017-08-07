
    
CREATE proc [dbo].[usp_SecurityReset]    
as    
delete from userRole    
where RoleID in( Select RoleID from Role where RoleName like 'TEST%')    
    
delete from ActivityRole    
where RoleID in (Select RoleID from Role where RoleName like 'TEST%')    
    
delete from Role where RoleName like 'TEST%'    
    
delete from Activity where AppKey like 'TEST%'    
    
delete from [User] where Username like 'TEST%'    
  
delete from AppName where AppKey like 'TEST%' 