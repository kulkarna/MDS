
CREATE proc [dbo].[usp_ActivityGetAll]   
as  
Select ActivityKey,
	ActivityDesc,
	AppKey,
	DateCreated,
	DateModified,
	CreatedBy,
	ModifiedBy 
From LibertyPower.dbo.Activity  



