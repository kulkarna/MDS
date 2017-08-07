/*
-- Created By: Eric Hernandez
-- Created On: 2010-12-17
-- Use: select * from dbo.ufn_account_as_of('1-12-2007') where status='999999'

-- Note that when you pass in a date, SQL will assume that the time portion is 00:00:000 unless specified.  
-- So passing in 1-12-2007 would give data as of 1-12-2007 00:00:000 which would not include data from 1-12-2007

 *******************************************************************************
 * 04/26/2012 - Jose Munoz - SWCS
 * Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
			and use the new table in libertypower database
 *******************************************************************************
*/   
 

-- select * from dbo.ufn_custom_rates_sel('libertypower\outboundtelesales')
CREATE FUNCTION [dbo].[ufn_custom_rates_sel_jmunoz] ( @Username	nchar(100) )
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
	FROM	lp_common..common_product_rate pr WITH (NOLOCK)
			INNER JOIN lp_deal_capture..deal_pricing_detail dpd WITH (NOLOCK)
			ON dpd.product_id		= pr.product_id 
			AND dpd.rate_id			= pr.rate_id 
			INNER JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK)
			ON dp.deal_pricing_id	= dpd.deal_pricing_id
	WHERE 1=1
   	AND		dp.date_expired	>= CONVERT(char(08), GETDATE(), 112)  -- custom rate has not expired 
	AND		(	-- user has access to custom rate	
				dp.sales_channel_role		= @Username 
				OR dp.sales_channel_role	= REPLACE(@Username , 'libertypower\', 'SALES CHANNEL') 
				OR dp.sales_channel_role IN 
				(	SELECT	b.RoleName 
					FROM	libertypower..[UserRole] a WITH (NOLOCK)
							INNER JOIN libertypower..[Role] b WITH (NOLOCK)
							ON a.RoleID = b.RoleID  
							INNER JOIN libertypower..[User] u WITH (NOLOCK)
							ON a.userID = u.UserID
					WHERE	Username	= @Username
					AND		b.RoleName	LIKE LTRIM(RTRIM('SALES CHANNEL')) + '%' 
				)
				 OR lp_common.dbo.ufn_is_liberty_employee(@Username) = 1 
			 ) 
	-- rate has not already been submitted or exists on the current contract
	AND dpd.rate_submit_ind = 0 		

)