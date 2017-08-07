-- =============================================
-- Author:		Rick Deigsler
-- Create date: 1/15/2008
-- Description:	
-- =============================================
CREATE PROCEDURE usp_utility_sel_listbyusername_for_scraper

@p_username                                    nchar(100)

AS

DECLARE	@w_user_id                              int

SELECT	@w_user_id                               = UserID
FROM	lp_portal..Users WITH (NOLOCK INDEX = IX_Users)
WHERE	Username                                  = @p_username 


SELECT	DISTINCT 
		option_id                                 = d.utility_descp,
		return_value                              = LTRIM(RTRIM(c.utility_id))
FROM	lp_portal..UserRoles a WITH (NOLOCK INDEX = IX_UserRoles_1),
		lp_portal..Roles b WITH (NOLOCK INDEX = IX_RoleName),
		lp_security..security_role_utility c WITH (NOLOCK INDEX = security_role_utility_idx),
		lp_common..common_utility d WITH (NOLOCK INDEX = common_utility_idx),
		lp_historical_info..zScraperUtilities z
WHERE	(a.UserID									= @w_user_id 
		and a.RoleID                                = b.RoleID
		and b.RoleName                              = c.role_name)
		and c.utility_id                            = d.utility_id
		and d.utility_id							= z.utility_id
		and z.is_sales_channel_available			= 1
		and d.inactive_ind							= '0'
ORDER BY option_id