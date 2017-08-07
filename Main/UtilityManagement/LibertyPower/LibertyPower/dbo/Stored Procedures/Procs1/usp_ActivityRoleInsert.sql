



  
  
CREATE PROCEDURE [dbo].[usp_ActivityRoleInsert]  
(  
    @RoleID int,  
    @ActivityID int ,
	@CreatedBy int	 
 )     
AS  
if not exists(select * from ActivityRole where RoleID =@RoleID and ActivityID = @ActivityID)  
INSERT INTO [ActivityRole] (  
    RoleID,  
    ActivityID,
	CreatedBy  
  )  
VALUES (  
    @RoleID,  
    @ActivityID,
	@CreatedBy  
    )  
  
  select r.RoleName, r.RoleID, a.ActivityDesc,
 a.ActivityKey, a.AppKey,a.DateCreated, a.CreatedBy,
a.DateModified, a.ModifiedBy
from role r inner join ActivityRole ar on r.RoleID= ar.RoleID
inner join Activity a on a.ActivityKey = ar.ActivityID





