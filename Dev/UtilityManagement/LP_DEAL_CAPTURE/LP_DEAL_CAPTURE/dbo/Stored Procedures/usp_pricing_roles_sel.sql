
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/24/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_roles_sel]

AS

SELECT		RoleID, RoleName
FROM		lp_portal..Roles
WHERE		RoleName NOT LIKE '%Admin%'
ORDER BY	RoleName