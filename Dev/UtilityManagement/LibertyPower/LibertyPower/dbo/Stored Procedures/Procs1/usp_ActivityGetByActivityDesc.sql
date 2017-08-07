
  
CREATE proc [dbo].[usp_ActivityGetByActivityDesc] ( @ActivityDesc varchar(50))    
as    
select ActivityKey,  
	ActivityDesc,  
	AppKey,  
	DateCreated,  
	DateModified,  
	CreatedBy,  
	ModifiedBy   
From Activity  
Where  ActivityDesc = @ActivityDesc 


