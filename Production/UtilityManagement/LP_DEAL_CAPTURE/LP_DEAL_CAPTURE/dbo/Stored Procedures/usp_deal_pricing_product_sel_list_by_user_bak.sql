-- exec usp_deal_pricing_product_sel_list_by_user '' , 3 , 'libertypower\e3hernandez'

-- =================================================
-- Created By: Gail Mangaroo 
-- Date Created: 9/17/2008
-- =================================================

CREATE procedure [dbo].[usp_deal_pricing_product_sel_list_by_user_bak]
(
 @p_utility_id        varchar(50) = '',
 @p_account_type_id		int = 0 ,
 @p_username			varchar(50)  = ''
) 

as
BEGIN 
   SELECT  DISTINCT
        p.product_id,
        p.product_descp,
        p.product_category,
        p.utility_id,
        p.frecuency,
        p.db_number,
        p.date_created,
        p.username,
        p.inactive_ind,   
        p.active_date,
		p.product_sub_category,
		product_descp_combined = product_descp + '  (' + utility_id + ')' ,
		p.account_type_id ,
		user_access = u.username
   from lp_common..common_product p with (NOLOCK INDEX = common_product_idx) 
	JOIN lp_security..security_role_product rp WITH (NOLOCK) ON p.product_id = rp.product_id
	JOIN lp_portal..UserRoles ur WITH (NOLOCK) ON rp.role_id = ur.roleid
	JOIN lp_portal..Users u WITH (NOLOCK) ON ur.userid = u.userid
   where
	--(	ticket 11084 - By AT 11/11/2009
	--	(product_category  = 'FIXED' OR product_sub_category = 'FIXED ADDER')
	--	OR 
	--	-- account type = LCI 
	--	 p.account_type_id = 3 
	-- ) 
	--AND 
	p.inactive_ind = 0 
	AND ( u.username = @p_username OR ltrim(rtrim(isnull(@p_username,''))) = '' )
	AND ( p.utility_id = @p_utility_id OR ltrim(rtrim(isnull(@p_utility_id,''))) = '' )
	AND (p.account_type_id = @p_account_type_id OR isnull(@p_account_type_id, 0) = 0 ) 
	AND	IsCustom = 1
	order by product_descp
END 
 

