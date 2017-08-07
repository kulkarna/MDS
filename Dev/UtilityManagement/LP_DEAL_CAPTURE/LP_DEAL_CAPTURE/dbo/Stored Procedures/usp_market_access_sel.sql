-- =============================================
-- Author:		Rick Deigsler
-- Create date: 12/12/2007
-- Description:	Get market access roles
-- =============================================
CREATE PROCEDURE [dbo].[usp_market_access_sel]

AS

SELECT	m.retail_mkt_descp AS option_id, r.RoleID AS return_value
FROM	libertypower..[Role] r,
		lp_common.dbo.common_retail_market m
WHERE	r.RoleName LIKE '%Utility Access%'
--AND		SUBSTRING(RoleName, 1, 3) <> 'All'
AND		m.retail_mkt_id = SUBSTRING(r.RoleName, 1, 2)
AND		m.inactive_ind = 0
ORDER BY m.retail_mkt_descp

-- omitted per Douglas 10/26/2011
--UNION

--SELECT	RoleName AS option_id, RoleID AS return_value
--FROM	libertypower..[Role] 
--WHERE	RoleName = 'All Utility Access'
