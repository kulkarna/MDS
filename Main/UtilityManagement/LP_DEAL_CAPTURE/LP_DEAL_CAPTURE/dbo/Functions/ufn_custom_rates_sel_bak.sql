-- Created By: Eric Hernandez
-- Created On: 2010-12-17
-- Use: select * from dbo.ufn_account_as_of('1-12-2007') where status='999999'

-- Note that when you pass in a date, SQL will assume that the time portion is 00:00:000 unless specified.  
-- So passing in 1-12-2007 would give data as of 1-12-2007 00:00:000 which would not include data from 1-12-2007



-- select * from dbo.ufn_custom_rates_sel('libertypower\outboundtelesales')
CREATE FUNCTION [dbo].[ufn_custom_rates_sel_bak] ( @Username	nchar(100) )
RETURNS Table
AS


RETURN
(
	--DECLARE @SalesChannelRole VARCHAR(50)
	--DECLARE @SalesChannelPrefix VARCHAR(100)
	
	--SELECT	@SalesChannelPrefix = sales_channel_prefix  FROM lp_common..common_config WITH (NOLOCK)  
	--SELECT	@SalesChannelRole = REPLACE(@Username , 'libertypower\', 'SALES CHANNEL')	


    -- Custom Pricing
	SELECT	DISTINCT  pr.product_id, pr.rate_id
	FROM	lp_common..common_product_rate pr
			INNER JOIN lp_deal_capture..deal_pricing_detail dpd ON dpd.product_id = pr.product_id AND dpd.rate_id = pr.rate_id 
			INNER JOIN lp_deal_capture..deal_pricing dp ON dp.deal_pricing_id = dpd.deal_pricing_id
	WHERE 1=1
   	AND		dp.date_expired	>= CONVERT(char(08), GETDATE(), 112)  -- custom rate has not expired 
	AND		(	-- user has access to custom rate	
				dp.sales_channel_role		= @Username 
				OR dp.sales_channel_role	= REPLACE(@Username , 'libertypower\', 'SALES CHANNEL') 
				OR dp.sales_channel_role IN 
				(	SELECT	b.RoleName 
					FROM	lp_portal..UserRoles a
							JOIN lp_portal..Roles b ON a.RoleID = b.RoleID  
							JOIN lp_portal..Users u ON a.userID = u.UserID
					WHERE	Username	= @Username
					AND		b.RoleName	LIKE LTRIM(RTRIM('SALES CHANNEL')) + '%' 
				)
				 OR lp_common.dbo.ufn_is_liberty_employee(@Username) = 1 
			 ) 
	-- rate has not already been submitted or exists on the current contract
	AND dpd.rate_submit_ind = 0 		

)