﻿/*
-- For active products   exec usp_product_sel_listbyusername 'admin', 'CONED'
-- For all products      exec usp_product_sel_listbyusername 'admin', 'CONED', @p_show_active_flag = null

-- 2007-03-09 Change by Eric Hernandez
-- Added parameter to indicate to control whether inactive products are shown.
-- The default will be to show only active products, since this is the standard expectation of this stored procedure.
 
-- Modified 9/12/2007
-- Rick Deigsler
-- Added parameter and if/else for enforcing product security
*******************************************************************************
* 04/26/2012 - Jose Munoz - SWCS
* Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
		and use the new table in libertypower database
*******************************************************************************

exec usp_product_sel_listbyusername 'libertypower\dmarino', 'BGE'
exec usp_product_sel_listbyusername_jmunoz 'libertypower\dmarino', 'BGE'

*/
CREATE procedure [dbo].[usp_product_sel_listbyusername_jmunoz]
	(@p_username								nchar(100),
	@p_utility_id								char(15),
	@p_account_type								varchar(50) = null,
	@p_union_select                             varchar(15) = ' ',
	@p_show_active_flag							tinyint		= 0,
	@p_enforce_security							varchar(5)	= 'TRUE'
)
AS

--DECLARE @issuperuser TINYINT, @ProductCategory VARCHAR(30)

--SELECT @issuperuser			= issuperuser 
--FROM libertypower..[User] WITH (NOLOCK INDEX = User__Username_I)
--WHERE username				= @p_username

SELECT distinct seq = 2
	, option_id = 
		CASE WHEN t.retail_mkt_id in ('NY','TX','MD','DC') and p.product_category = 'FIXED' THEN 'FIXED - ' + product_descp
		ELSE product_descp END
	, return_value = ltrim(rtrim(p.product_id))
	,p.product_category
INTO #productlist
FROM lp_common..common_product p WITH (NOLOCK)
JOIN lp_common..common_utility t WITH (NOLOCK)
ON p.utility_id				= t.utility_id
JOIN lp_security..security_role_product rp WITH (NOLOCK)
ON p.product_id		= rp.product_id 
--OR @issuperuser		= 1
JOIN libertypower..[UserRole] ur WITH (NOLOCK)
ON rp.role_id		= ur.roleid 
--OR @issuperuser		= 1
JOIN libertypower..[User] u WITH (NOLOCK)
ON ur.userid		= u.userid
WHERE u.username			= @p_username
and p.utility_id			= @p_utility_id 
and p.inactive_ind			= isnull(@p_show_active_flag,p.inactive_ind)
and p.account_type_id		= isnull(@p_account_type,account_type_id)
and (@p_show_active_flag	is null OR p.product_id not in ('CONED-PWRM-3','CONED_PM_RES'))
ORDER BY 2

IF @p_union_select = 'NONE'
BEGIN
	INSERT INTO #productlist
	SELECT DISTINCT seq = 1, option_id = 'None', return_value = 'NONE', ''
END

SELECT option_id, return_value, product_category 
FROM #productlist
ORDER BY seq, option_id





