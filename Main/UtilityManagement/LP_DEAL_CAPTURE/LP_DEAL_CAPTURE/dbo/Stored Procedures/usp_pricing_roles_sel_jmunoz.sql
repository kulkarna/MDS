/*
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/24/2008
-- Description:	
-- =============================================
*******************************************************************************
* 04/26/2012 - Jose Munoz - SWCS
* Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
		and use the new table in libertypower database
*******************************************************************************

*/
CREATE PROCEDURE [dbo].[usp_pricing_roles_sel_jmunoz]

AS

SET NOCOUNT ON

SELECT		RoleID, RoleName
FROM		libertypower..[Role] WITH (NOLOCK)
WHERE		RoleName NOT LIKE '%Admin%'
ORDER BY	RoleName

SET NOCOUNT OFF

