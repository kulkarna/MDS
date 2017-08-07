CREATE VIEW [dbo].[vw_ufn_account_sales_channel_username_bak]
AS



	SELECT	sales_channel_role                    = c.RoleName,
			a.Username  as username
	FROM	lp_portal..Users a with (NOLOCK), 
			lp_portal..UserRoles b with (NOLOCK), 
			lp_portal..Roles c with (NOLOCK), 
			lp_common..common_config d
	where 1=1 -- a.Username                             = @p_username
	and   a.UserID                               = b.UserID
	and   b.RoleID                               = c.RoleID
	and   c.RoleName                          like ltrim(rtrim(d.sales_channel_prefix)) + '%'
