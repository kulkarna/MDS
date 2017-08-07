-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/24/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_roles_by_pricing_id_sel_bak]

@p_pricing_id	int

AS

SELECT	r.RoleID, r.RoleName
FROM	pricing_role p
		INNER JOIN lp_portal..Roles r ON p.role_id = r.RoleID
WHERE	p.pricing_id = @p_pricing_id

