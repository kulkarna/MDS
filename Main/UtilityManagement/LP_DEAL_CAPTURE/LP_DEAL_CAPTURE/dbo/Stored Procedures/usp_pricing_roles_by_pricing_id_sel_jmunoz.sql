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
CREATE PROCEDURE [dbo].[usp_pricing_roles_by_pricing_id_sel_jmunoz]

@p_pricing_id	int

AS

SET NOCOUNT ON 

SELECT	r.RoleID, r.RoleName
FROM	pricing_role p WITH (NOLOCK)
INNER JOIN libertypower..[Role] r WITH (NOLOCK)
ON p.role_id = r.RoleID
WHERE	p.pricing_id = @p_pricing_id

SET NOCOUNT OFF

