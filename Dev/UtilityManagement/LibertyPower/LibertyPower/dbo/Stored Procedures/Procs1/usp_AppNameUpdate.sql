  
CREATE PROCEDURE [dbo].[usp_AppNameUpdate]  
    @AppKey varchar(20),  
    @AppDescription varchar(100),
   @ModifiedBy varchar(50)  
    AS  

Update AppName
set AppDescription = @AppDescription,
	ModifiedBy= @ModifiedBy,
	DateModified = Getdate()
where AppKey = @AppKey

select 
ApplicationKey,
AppKey,
AppDescription,
DateCreated,
DateModified,
CreatedBy,
ModifiedBy
from AppName
where AppKey = @AppKey


  


