


CREATE PROCEDURE [dbo].[usp_ActivityInsert]
(
    @ActivityDesc varchar(50),
    @AppKey varchar(20),
	@CreatedBy int
)	
   
AS
if not exists(select * from Activity where ActivityDesc = @ActivityDesc and  AppKey =@AppKey)
INSERT INTO [Activity] (
        ActivityDesc,
    AppKey,
	CreatedBy,
	ModifiedBy)
VALUES (
      @ActivityDesc,
    @AppKey,
	@CreatedBy,
	@CreatedBy)

select ActivityKey,ActivityDesc,AppKey,DateCreated,DateModified, ModifiedBy ,CreatedBy 
from Activity 
where ActivityKey = SCOPE_IDENTITY()
