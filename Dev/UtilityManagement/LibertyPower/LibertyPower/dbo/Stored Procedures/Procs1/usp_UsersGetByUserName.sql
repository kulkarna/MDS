

-- EXEC LibertyPower.dbo.usp_UsersGetByUserName 'libertypower\e3hernandez','Sales Channel/outboundtelesales'
CREATE proc [dbo].[usp_UsersGetByUserName] ( @UserName nvarchar(200), @Role nvarchar(200) = null)
as
select 
	u.UserID,
	u.Username, 
	u.Firstname, 
	u.Lastname, 
	u.Email, 
	DisplayName = u.Firstname + ' ' + u.Lastname,
	r.roleName,
	r.RoleID,
	r.Description
from [User] u
join UserRole ur on u.UserID = ur.UserID
join Role r on r.RoleID = ur.RoleID
where u.UserName = @UserName
and r.roleName = Isnull(@Role,r.roleName)
