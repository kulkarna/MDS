
USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelMarketlist]    Script Date: 06/27/2014 15:15:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	[usp_SalesChannelMarketlist] 
 * PURPOSE:		Selects all markets for selected sales channels
 * HISTORY:		 
 *******************************************************************************
 * 12/23/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************
Added : and m.inactive_ind=0
7/2/2014 Sara - Qualifiers page was pulling the Illinois market =14

 */

ALTER PROCEDURE [dbo].[usp_SalesChannelMarketlist] 
@p_salesChannelIds varchar(4000)	=null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

if (isnull(@p_salesChannelIds,'')='')
		SELECT	Distinct  m.ID, m.retail_mkt_descp AS MarketDesc
		FROM	lp_common..common_retail_market m with (NOLock)
		JOIN	lp_security..security_role_retail_mkt s with (NOLock) ON m.retail_mkt_id = s.retail_mkt_id
		JOIN	lp_portal..Roles r with (NOLock) ON r.RoleName = s.role_name		
		JOIN	lp_portal..UserRoles ur with (NOLock) ON r.RoleID = ur.RoleID
		JOIN	lp_portal..Users u with (NOLock) ON ur.userid = u.userid
		WHERE	u.Username in( select 'libertypower\'+sc.ChannelName from  LibertyPower..SalesChannel sc  with (NOLock)
									where sc.Inactive=0 and sc.SalesStatus=2)
		  AND   s.role_name <> 'All Utility Access'
		  and m.inactive_ind=0
		    --and m.ID = (SELECT MAX(b.ID) FROM lp_common..common_retail_market b WITH (NOLOCK) 
						--WHERE m.retail_mkt_id  = b.retail_mkt_id )
		  ORDER BY m.retail_mkt_descp	
else
		SELECT	DISTINCT  m.ID, m.retail_mkt_descp AS MarketDesc
		FROM	lp_common..common_retail_market m with (NOLock)
		JOIN	lp_security..security_role_retail_mkt s with (NOLock) ON m.retail_mkt_id = s.retail_mkt_id
		JOIN	lp_portal..Roles r with (NOLock) ON r.RoleName = s.role_name		
		JOIN	lp_portal..UserRoles ur with (NOLock) ON r.RoleID = ur.RoleID
		JOIN	lp_portal..Users u with (NOLock) ON ur.userid = u.userid
		WHERE	u.Username in( select 'libertypower\'+sc.ChannelName from  LibertyPower..SalesChannel sc  with (NOLock)
									where sc.Inactive=0 and sc.SalesStatus=2 and sc.ChannelID in (select * from dbo.split(@p_salesChannelIds,',')))
		  AND   s.role_name <> 'All Utility Access'
		  and m.inactive_ind=0
		    --and m.ID = (SELECT MAX(b.ID) FROM lp_common..common_retail_market b WITH (NOLOCK) 
						--WHERE m.retail_mkt_id  = b.retail_mkt_id )
		  ORDER BY m.retail_mkt_descp		  
		
Set NOCOUNT OFF;
END
-- Copyright 12/23/2013 Liberty Power