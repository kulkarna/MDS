  
CREATE PROCEDURE [dbo].[usp_AppNameInsert]  
    @AppKey varchar(20),  
    @AppDescription varchar(100),
   @CreatedBy varchar(50)  
    AS  
declare @ModifiedBy varchar(50)

if not exists( select * from AppName where AppKey = @AppKey) 
set @ModifiedBy = @CreatedBy 
INSERT INTO [AppName] (  
    AppKey,  
    AppDescription,
	CreatedBy,
	ModifiedBy)  
VALUES (  
    @AppKey,  
    @AppDescription,
	@CreatedBy,
	@ModifiedBy

)  

select 
	ApplicationKey,
	AppKey,
	AppDescription,
	DateCreated,
	DateModified,
	CreatedBy,
	ModifiedBy
from AppName
where ApplicationKey = SCOPE_IDENTITY()
  


