
CREATE proc [dbo].[usp_ActivityGetByAppKey] (@AppKey varchar(20))  
as  
select ActivityKey,
ActivityDesc,
AppKey,
DateCreated,
DateModified,
CreatedBy,
ModifiedBy 
from Activity  
where AppKey = @AppKey
