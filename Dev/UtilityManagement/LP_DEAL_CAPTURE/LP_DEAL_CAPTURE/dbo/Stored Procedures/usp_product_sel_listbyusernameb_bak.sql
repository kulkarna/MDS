-- For active products   exec usp_product_sel_listbyusername 'admin', 'CONED'
-- For all products      exec usp_product_sel_listbyusername 'admin', 'CONED', @p_show_active_flag = null

-- 2007-03-09 Change by Eric Hernandez
-- Added parameter to indicate to control whether inactive products are shown.
-- The default will be to show only active products, since this is the standard expectation of this stored procedure.
 
-- Modified 9/12/2007
-- Rick Deigsler
-- Added parameter and if/else for enforcing product security

CREATE procedure [dbo].[usp_product_sel_listbyusernameb_bak]
(		@Username				nchar(100),
		@ContractNumber			varchar(50) = '',
		@UtilityCode			char(15),
		@ChannelGroupID			int = 0,
		@ChannelTypeID			int = 0,
		@ProductCrossPriceSetID	int = 0,
		@p_show_active_flag		tinyint = 0
)
AS

		
DECLARE @issuperuser TINYINT
SELECT @issuperuser = issuperuser FROM lp_portal..Users WHERE username = @Username

SELECT DISTINCT p.product_id as ProductID, 
			    t.retail_mkt_id as MarketCode,
			    p.product_category as  ProductCategory, 
			    p.product_descp as ProductDescription,
			    account_type_id as AccountTypeID 
FROM lp_common..common_product p
	 JOIN lp_common..common_utility t ON p.utility_id = t.utility_id
	 JOIN lp_security..security_role_product rp ON p.product_id = rp.product_id OR @issuperuser = 1
	 JOIN lp_portal..UserRoles ur ON rp.role_id = ur.roleid OR @issuperuser = 1
	 JOIN lp_portal..Users u ON ur.userid = u.userid
WHERE  (u.username = @Username) 
	and p.utility_id = @UtilityCode 
	and p.inactive_ind = isnull(@p_show_active_flag,p.inactive_ind)
	and (@p_show_active_flag is null OR p.product_id not in ('CONED-PWRM-3','CONED_PM_RES'))
