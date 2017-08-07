/*
*******************************************************************************
* 04/26/2012 - Jose Munoz - SWCS
* Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
		and use the new table in libertypower database
*******************************************************************************
*/
CREATE VIEW [dbo].[vw_ufn_account_sales_channel_username_jmunoz]
AS
	SELECT	sales_channel_role			= c.RoleName
			,username					= a.Username
	FROM	libertypower..[User] a with (NOLOCK)
	inner join libertypower..[UserRole] b with (NOLOCK)
	on b.UserID					= a.UserID
	inner join libertypower..[Role] c with (NOLOCK)
	on c.RoleID					= b.RoleID 
	inner join lp_common..common_config d with (NOLOCK)
	on c.RoleName like ltrim(rtrim(d.sales_channel_prefix)) + '%' 
