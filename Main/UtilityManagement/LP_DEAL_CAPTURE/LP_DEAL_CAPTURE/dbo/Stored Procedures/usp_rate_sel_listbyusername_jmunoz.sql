/*

-- ======================================================
-- Modified Gail Mangaroo 
-- 1/21/2008
-- modified to select custom rates for custom products
-- ======================================================
-- Modified: Gail Mangaroo
-- 05/12/2008 
-- modified to reterive selected rates from deal capture tables
-- ======================================================
-- Modified: Gail Mangaroo 
-- 9/10/2008
-- Removed check for pre-selected rates in deal_contract and deal_contract_account 
-- ======================================================
-- Modified by Eric Hernandez
-- 5/6/2009
-- Added ability to select future rates and modified stored procedure to be backwards compatible.
-- ======================================================
-- Modified by Diogo Lima
-- 1/19/2010
-- Added a new filter for where of line 127
-- AND pr2.contract_eff_start_date >= dateadd(mm,datediff(mm,0,getdate()),0)
-- ======================================================
-- Modified by Sofia Melo
-- 1/3/2011
-- Added parameter contract_date and the ability to select historical rates.
-- ======================================================
*******************************************************************************
* 04/26/2012 - Jose Munoz - SWCS
* Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
		and use the new table in libertypower database
*******************************************************************************

-- exec usp_rate_sel_listbyusername 'libertypower\e3hernandez', 'CONED_IP' , 12, ' ' , null , null, @p_contract_eff_start_date = '2009-08-10', @p_show_startdate_flag = 1

*/

CREATE procedure [dbo].[usp_rate_sel_listbyusername_jmunoz]
(@p_username                            nchar(100),
 @p_product_id                          char(20),
 @p_term_months							int = null,  
 @p_union_select                        varchar(15) = ' ',
 @p_show_active_flag					tinyint = 0,
 @p_deal_price_id						int = 0 ,
 @p_contract_nbr						varchar(20) = '',
 @p_contract_eff_start_date				Datetime = null,
 @p_show_startdate_flag					tinyint = 0,
 @p_zone								varchar(20) = 'NONE',
 @p_service_class						varchar(20) = 'NONE',
 @p_contract_date						datetime = null,		/* Ticket 20505 */
 @p_Sales_channel						varchar(50) = null

)
AS
BEGIN 
	DECLARE @ChannelGroupID				INT
		,@selected_count				int 
		,@w_sales_channel_prefix		varchar(100)
		,@w_sales_channel_role			varchar(50) 

	DECLARE @product_rate table ( seq int, rate_id int, rate_descp varchar(250), product_id varchar(30) )
	DECLARE @selected_rate table ( rate_id int )

	-- This will determine the Channel Group that the Sales Channel was in based on the Contract Date.
	SELECT @ChannelGroupID = sccg.ChannelGroupID
	FROM LibertyPower..SalesChannel sc WITH (NOLOCK)
	JOIN LibertyPower.dbo.SalesChannelChannelGroup sccg (NOLOCK)
		ON sc.ChannelID = sccg.ChannelID AND sccg.EffectiveDate <= @p_contract_date	
		AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > @p_contract_date
	WHERE ChannelName = REPLACE(@p_Sales_channel , 'SALES CHANNEL', '')

	IF @p_contract_eff_start_date is null
		SET @p_contract_eff_start_date = getdate()

	SET @selected_count = 0 
	SELECT @w_sales_channel_prefix	= sales_channel_prefix  FROM lp_common..common_config with (NOLOCK)  
	SELECT @w_sales_channel_role	= replace(@p_username , 'libertypower\', @w_sales_channel_prefix) 

	-- If contract number provided - check if in deal capture 
	-- Get previously selected rates 
	-- =====================================================
	IF ltrim(rtrim(isnull(@p_contract_nbr, ''))) <> '' 
	begin 
		INSERT INTO @selected_rate 
		SELECT distinct rate_id from deal_contract_print WITH (NOLOCK)
		WHERE contract_nbr	= @p_contract_nbr 
		and product_id		= @p_product_id
		
--		INSERT INTO @selected_rate 
--		SELECT distinct rate_id from deal_contract where contract_nbr = @p_contract_nbr and product_id = @p_product_id
--
--		INSERT INTO @selected_rate 
--		SELECT distinct rate_id from deal_contract_account where contract_nbr = @p_contract_nbr and product_id = @p_product_id

		INSERT INTO @selected_rate 
		SELECT DISTINCT rate_id 
		FROM multi_rates WITH (NOLOCK)
		WHERE contract_nbr	= @p_contract_nbr 
		AND product_id		= @p_product_id

		SELECT @selected_count = count(*) 
		FROM @selected_rate 
		WHERE rate_id <> 999999999
	end 

	--- Get regular daily rates
	--- =================================================
	INSERT INTO @product_rate (seq, rate_id, rate_descp , product_id)
	SELECT DISTINCT datepart(mm,contract_eff_start_date)
		, pr.rate_id
		, ltrim(rtrim(pr.rate_descp)) + 
		  case when @p_show_startdate_flag = 1 AND NOT (p.product_category = 'VARIABLE' AND p.product_sub_category in ('','PORTFOLIO','CUSTOM'))
		       then '  ( ' + datename(mm,contract_eff_start_date) + ' Start )' else '' end
		, pr.product_id
	FROM lp_common..common_product_rate pr WITH (NOLOCK INDEX = common_product_rate_idx)
	JOIN lp_common..common_product p WITH (NOLOCK)
	ON p.product_id			= pr.product_id
	LEFT JOIN lp_deal_capture..deal_pricing_detail dpd WITH (NOLOCK)
	ON dpd.product_id		= pr.product_id 
	AND dpd.rate_id			= pr.rate_id 
    WHERE pr.product_id		= @p_product_id
	AND pr.term_months		= isnull(@p_term_months,pr.term_months)
	AND pr.eff_date			<= convert(char(08), getdate(), 112) 
	AND pr.due_date			>= convert(char(08), getdate(), 112) 
	AND pr.inactive_ind		= isnull(@p_show_active_flag,pr.inactive_ind)
	AND	dpd.deal_pricing_id is null -- no custom pricing 
	AND pr.contract_eff_start_date >= dateadd(mm,datediff(mm,0,getdate()),0)
	AND @ChannelGroupID		= LEFT(pr.rate_id, 3) % 100
	-- If zone is provided as filter, show all products for that zone and all non-zone specific products.
	AND (@p_zone = 'NONE' OR @p_zone is null OR zone_id is null OR zone_id=0 
		 OR zone_id = (SELECT zone_id FROM lp_common..zone WITH (NOLOCK) WHERE zone = @p_zone))
	-- If service class is provided as filter, show all products for that class and all non-class specific products.
	AND (@p_service_class = 'NONE' OR @p_service_class is null OR service_rate_class_id is null OR service_rate_class_id=0 
		 OR service_rate_class_id = (SELECT service_rate_class_id FROM lp_common..service_rate_class WITH (NOLOCK) WHERE service_rate_class = @p_service_class AND utility_id = (SELECT utility_id FROM lp_common..common_product WHERE product_id = @p_product_id))
		 )
	AND 
		(
			@p_show_startdate_flag=1 OR -- if this flag is turned on, then show all future rates
			DATEPART(mm,pr.contract_eff_start_date) = 
			(
				SELECT TOP 1 DATEPART(mm,pr2.contract_eff_start_date )
				FROM lp_common..common_product_rate pr2 with (NOLOCK INDEX = common_product_rate_idx)
				JOIN lp_common..common_product p2 WITH (NOLOCK)
				ON pr2.product_id = p2.product_id 
				LEFT JOIN lp_deal_capture..deal_pricing_detail dpd2 WITH (NOLOCK)
				ON dpd2.product_id	= pr2.product_id 
				AND dpd2.rate_id	= pr2.rate_id 
				WHERE pr2.product_id	= @p_product_id
				AND pr2.term_months		= isnull(@p_term_months,pr.term_months)
				AND pr2.eff_date		<= convert(char(08), getdate(), 112) 
				AND pr2.due_date		>= convert(char(08), getdate(), 112) 
				AND pr2.inactive_ind	= isnull(@p_show_active_flag,pr.inactive_ind)
				AND	dpd2.deal_pricing_id is null -- no custom pricing
				AND pr2.contract_eff_start_date >= dateadd(mm,datediff(mm,0,getdate()),0)
				AND DATEPART(mm,pr2.contract_eff_Start_date) = 
				CASE 
					WHEN DATEPART(mm,pr2.contract_eff_start_date) = DATEPART(mm,@p_contract_eff_start_date)
							THEN DATEPART(mm,@p_contract_eff_start_date) 
					WHEN DATEPART(mm,DATEADD(MONTH,-1,pr2.contract_eff_start_date)) = DATEPART(mm,@p_contract_eff_start_date) AND
						 DATEPART(mm,pr2.contract_eff_start_date) <> DATEPART(mm,@p_contract_eff_start_date)
							THEN DATEPART(mm,DATEADD(MONTH,1,@p_contract_eff_start_date)) 
					WHEN DATEPART(mm,DATEADD(MONTH,-2,pr2.contract_eff_start_date)) = DATEPART(mm,@p_contract_eff_start_date) AND 
						 DATEPART(mm,pr2.contract_eff_start_date) <> DATEPART(mm,@p_contract_eff_start_date)
							THEN DATEPART(mm,DATEADD(MONTH,2,@p_contract_eff_start_date)) 
				END 
			)
		)			
		-- if contract nbr passed in from deal capture -- rate shld be pre-selected
		--AND (pr.rate_id in (SELECT rate_id FROM @selected_rate) 
		--		OR 
		--	 @selected_count = 0 
		--	) 

	--- Get historical rates
	--- =================================================
	IF ((@p_contract_date IS NOT NULL) AND (NOT EXISTS (select * from @product_rate)))
	BEGIN		
		INSERT INTO @product_rate (seq, rate_id, rate_descp , product_id)
		SELECT DATEPART(mm,ph.contract_eff_start_date ), ph.rate_id, pr.rate_descp, ph.product_id        
		FROM lp_common.dbo.product_rate_history ph WITH (NOLOCK)
		JOIN lp_common.dbo.common_product_rate pr WITH (NOLOCK) 
		on pr.product_id		= ph.product_id 
		and pr.rate_id			= ph.rate_id
		WHERE ph.contract_eff_start_date		>= dateadd(mm,datediff(mm,0,@p_contract_eff_start_date),0)
			and ph.product_id	= @p_product_id
			and ph.eff_date		= convert(char(08), @p_contract_date, 112)
			and convert(char(08), ph.date_created, 112) = 
			(
				select top 1 convert(char(08), date_created, 112) 
				from lp_common.dbo.product_rate_history WITH (NOLOCK)
				where contract_eff_start_date		>= dateadd(mm,datediff(mm,0,@p_contract_eff_start_date),0)
				and product_id						= @p_product_id
				and eff_date						= convert(char(08), @p_contract_date, 112)
				order by date_created desc
			)
	END		
		
	
	
	--- Get custom rates
	--- =================================================	
	INSERT INTO @product_rate (seq, rate_id, rate_descp , product_id)
	SELECT DISTINCT  13, pr.rate_id, ltrim(rtrim(pr.rate_descp)), pr.product_id 
	FROM lp_common..common_product_rate pr with (NOLOCK INDEX = common_product_rate_idx)
	JOIN lp_common..common_product p WITH (NOLOCK)
	ON pr.product_id		= p.product_id 
	LEFT JOIN lp_deal_capture..deal_pricing_detail dpd WITH (NOLOCK)
	ON dpd.product_id		= pr.product_id AND dpd.rate_id = pr.rate_id 
	LEFT JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK)
	ON dp.deal_pricing_id	= dpd.deal_pricing_id
    WHERE pr.product_id		= @p_product_id
	AND pr.term_months		= isnull(@p_term_months,pr.term_months)
	AND pr.eff_date			<= convert(char(08), getdate(), 112) 
	AND pr.due_date			>= convert(char(08), getdate(), 112) 
	AND pr.inactive_ind		= isnull(@p_show_active_flag,pr.inactive_ind)
	AND	dp.date_expired		>= convert(char(08), getdate(), 112)  -- custom rate has not expired 
	AND (	-- user has access to custom rate	
		 dp.sales_channel_role		= @p_username 
		 OR dp.sales_channel_role	= @w_sales_channel_role 
		 OR dp.sales_channel_role in 
			(SELECT b.RoleName 
				FROM libertypower..[UserRole] a WITH (NOLOCK)
				INNER JOIN libertypower..[Role] b WITH (NOLOCK)
				ON b.RoleID				= a.RoleID
				INNER JOIN libertypower..[User] u WITH (NOLOCK INDEX = User__Username_I)  
				ON u.UserID				= a.userID 
				WHERE Username			= @p_username
				AND b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%' 
			 )
		 OR lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1 
		 ) 
	-- rate has not already been submitted or exists on the current contract
	AND ( dpd.rate_submit_ind = 0 
			OR  EXISTS ( SELECT contract_nbr FROM deal_contract WITH (NOLOCK) WHERE contract_nbr = @p_contract_nbr and @p_contract_nbr <> '' and product_id = dpd.product_id and rate_id = dpd.rate_id 
							UNION 
						 SELECT contract_nbr FROM deal_contract_account WITH (NOLOCK) WHERE contract_nbr = @p_contract_nbr and  @p_contract_nbr <> '' and product_id = dpd.product_id and rate_id = dpd.rate_id
						) 
		)  
			
									
	--- Get NONE selection if necessary
	--- =================================================
	IF @p_union_select = 'NONE'
	BEGIN
		INSERT INTO @product_rate ( seq, rate_id, rate_descp )
		SELECT DISTINCT  0, 999999999, 'None'
	END 

	--- Final Select
	--- ==================================================== 
	SELECT option_id = ltrim(rtrim(rate_descp)), return_value = rate_id , *
	FROM @product_rate 
	ORDER BY seq, option_id


END 
