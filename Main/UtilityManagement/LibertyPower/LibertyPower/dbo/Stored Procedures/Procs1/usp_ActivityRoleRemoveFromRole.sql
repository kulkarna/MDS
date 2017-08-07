CREATE PROCEDURE usp_ActivityRoleRemoveFromRole
(
    @RoleID int,
    @ActivityID int
 )   
AS
Delete [ActivityRole] 
    where RoleID= @RoleID and ActivityID = @ActivityID

