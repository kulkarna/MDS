
  
        
CREATE PROCEDURE [dbo].[usp_RoleInsert]        
( 
	@RoleName varchar(50),
	@Description varchar(100),    
	@CreatedBy int       
)        
AS        
if not exists(select null from Role where Rolename =@RoleName)        
        
INSERT INTO [Role] (        
    RoleName,
    Description,        
    CreatedBy,    
	ModifiedBy)        
VALUES (        
     @RoleName, 
     @Description, 
	 @CreatedBy,    
	 @CreatedBy    
    )        
      
select RoleID, RoleName, Description,  DateCreated ,dateModified, CreatedBy, ModifiedBy     
 from Role      
where Rolename =@RoleName
 --where RoleID  = SCOPE_IDENTITY()        
