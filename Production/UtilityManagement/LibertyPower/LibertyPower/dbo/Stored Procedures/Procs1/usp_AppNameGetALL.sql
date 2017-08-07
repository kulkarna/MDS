
CREATE proc [dbo].[usp_AppNameGetALL]
as
select 
ApplicationKey,
AppKey,
AppDescription,
DateCreated,
DateModified,
CreatedBy,
ModifiedBy
from AppName 
