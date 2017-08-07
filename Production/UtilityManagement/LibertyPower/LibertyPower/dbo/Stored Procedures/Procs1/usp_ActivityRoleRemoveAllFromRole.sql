CREATE procEDURE [dbo].[usp_ActivityRoleRemoveAllFromRole]
(
    @RoleID int
 )   
AS
Delete [ActivityRole] 
    where RoleID= @RoleID 

