
  
CREATE proc [dbo].[usp_ActivityGetByActivityKey] ( @ActivityKey int)    
as    
select ActivityKey,  
	ActivityDesc,  
	AppKey,  
	DateCreated,  
	DateModified,  
	CreatedBy,  
	ModifiedBy   
From Activity  
Where  ActivityKey = @ActivityKey 


