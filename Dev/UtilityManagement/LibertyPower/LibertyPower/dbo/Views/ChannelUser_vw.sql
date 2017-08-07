




--select * from ufn_account_sales_channel('libertypower\I2C')

CREATE VIEW [dbo].[ChannelUser_vw]
AS
	SELECT u.UserName, sales_channel_role = r.RoleName, sc.ChannelID, sc.ChannelName
	FROM LibertyPower..[User] u (NOLOCK)
	JOIN LibertyPower..UserRole ur (NOLOCK) ON u.userid = ur.userid 
	JOIN LibertyPower..Role r (NOLOCK) ON ur.roleid = r.roleid
	JOIN LibertyPower..SalesChannel sc (NOLOCK) ON sc.ChannelName = REPLACE(r.RoleName, 'Sales Channel/', '')
	WHERE r.RoleName LIKE 'Sales Channel/%'









