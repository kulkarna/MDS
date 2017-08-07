


--select * from ufn_account_sales_channel('libertypower\I2C')

CREATE function [dbo].[ufn_account_sales_channel] (@p_username NCHAR(100))
RETURNS TABLE
AS
RETURN
	(
		SELECT sales_channel_role = r.RoleName
		FROM LibertyPower..[User] u (NOLOCK)
		JOIN LibertyPower..UserRole ur (NOLOCK) ON u.userid = ur.userid 
		JOIN LibertyPower..Role r (NOLOCK) ON ur.roleid = r.roleid
		JOIN (
			SELECT TOP 1 ltrim(rtrim(sales_channel_prefix)) AS Prefix
			FROM lp_common..common_config (NOLOCK)
			) d ON 1=1
		WHERE u.UserName = @p_username 
		AND r.RoleName LIKE d.Prefix + '%'
	)

/*
	select sales_channel_role = c.RoleName 
	from lp_portal..Users a with (NOLOCK), 
	lp_portal..UserRoles b with (NOLOCK),
	lp_portal..Roles c with (NOLOCK),
	lp_common..common_config d
	where a.Username = @p_username
	and   a.UserID = b.UserID
	and   b.RoleID = c.RoleID
	and   c.RoleName like ltrim(rtrim(d.sales_channel_prefix)) + '%'
*/
