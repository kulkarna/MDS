/*
-- ===============================
-- Modified: 8/20/2008
-- Modified By: Gail Mangaroo 
-- Added utility param 
--================================

-- =================================================
-- Modified: Gail Mangaroo 
-- Date Modified: 9/16/2008
-- Added account type param.
-- =================================================
*******************************************************************************
* 04/26/2012 - Jose Munoz - SWCS
* Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
		and use the new table in libertypower database
*******************************************************************************
*/
CREATE procedure [dbo].[usp_product_sel_list_by_user_category_jmunoz]
(
	@p_product_category			varchar(20) = '',
	@p_product_sub_category		varchar(50) = '',
	@p_inactive_ind				tinyint		= 0,
	@p_username					varchar(50)  ='',
	@p_is_flexible				int = null ,
	@p_utility_id				varchar(50) = '',
	@p_account_type_id			int = 0 
) 

as
BEGIN 

	SELECT DISTINCT
        a.product_id,
        a.product_descp,
        a.product_category,
        a.utility_id,
        a.frecuency,
        a.db_number,
        a.date_created,
        a.username,
        inactive_ind            = b.option_id, 
        a.active_date,
		a.product_sub_category,
		option_id				= product_descp, 
		return_value			= ltrim(rtrim(a.product_id))
	FROM lp_common..common_product a WITH (NOLOCK INDEX = common_product_idx) 
	INNER JOIN  lp_common..common_views b WITH (NOLOCK INDEX = common_views_idx1)  
	ON b.process_id			= 'INACTIVE IND'  
	AND b.return_value		= a.inactive_ind
	INNER JOIN lp_security..security_role_product rp WITH (NOLOCK)
	ON a.product_id			= rp.product_id
	INNER JOIN libertypower..[UserRole] ur WITH (NOLOCK)
	ON ur.roleid			= rp.role_id
	INNER JOIN libertypower..[User] u WITH (NOLOCK)
	ON u.userid				= ur.userid
	WHERE
	 ( product_category  = @p_product_category or ltrim(rtrim(isnull(@p_product_category, ''))) = '' ) 
	AND ( product_sub_category = @p_product_sub_category or ltrim(rtrim(isnull(@p_product_sub_category, ''))) = '' )
	AND a.inactive_ind = isnull( @p_inactive_ind , a.inactive_ind ) 
	AND ( u.username = @p_username OR ltrim(rtrim(isnull(@p_username,''))) = '' )
	AND a.is_flexible = isnull(@p_is_flexible,  a.is_flexible)
	AND ( a.utility_id = @p_utility_id OR ltrim(rtrim(isnull(@p_utility_id,''))) = '' )
	AND (a.account_type_id = @p_account_type_id OR @p_account_type_id = 0 ) 

	order by product_descp

END 
 



--ALTER procedure [dbo].[usp_product_sel_list_by_user_category]
--(
-- @p_product_category varchar(20) = '',
-- @p_product_sub_category varchar(50) = '',
-- @p_inactive_ind			tinyint		= 0,
-- @p_username			varchar(50)  ='',
-- @p_is_flexible       int = null 
--) 
--
--as
--BEGIN 
--
--   select distinct
--        a.product_id,
--        a.product_descp,
--        a.product_category,
--        a.utility_id,
--        a.frecuency,
--        a.db_number,
--        a.date_created,
--        a.username,
--        inactive_ind                              = b.option_id, 
--        a.active_date,
--		a.product_sub_category,
--
--		option_id = product_descp, 
--		return_value = ltrim(rtrim(a.product_id))
--
--
--   from lp_common..common_product a with (NOLOCK INDEX = common_product_idx) 
--    JOIN  lp_common..common_views b with (NOLOCK INDEX = common_views_idx1)  ON b.process_id = 'INACTIVE IND'  
--			AND   b.return_value = a.inactive_ind
--	JOIN lp_security..security_role_product rp ON a.product_id = rp.product_id
--	JOIN lp_portal..UserRoles ur ON rp.role_id = ur.roleid
--	JOIN lp_portal..Users u ON ur.userid = u.userid
--
--   where
--	 ( product_category  = @p_product_category or ltrim(rtrim(isnull(@p_product_category, ''))) = '' ) 
--	AND ( product_sub_category = @p_product_sub_category or ltrim(rtrim(isnull(@p_product_sub_category, ''))) = '' )
--	AND a.inactive_ind = isnull( @p_inactive_ind , a.inactive_ind ) 
--	AND ( u.username = @p_username OR ltrim(rtrim(isnull(@p_username,''))) = '' )
--	AND a.is_flexible = isnull(@p_is_flexible,  a.is_flexible)
--
--	order by product_descp
--
--END 
 
