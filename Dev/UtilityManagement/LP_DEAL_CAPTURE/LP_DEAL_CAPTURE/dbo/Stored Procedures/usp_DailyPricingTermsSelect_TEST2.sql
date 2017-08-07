-- Stored Procedure

/*******************************************************************************
 * usp_DailyPricingTermsSelect
 * Gets terms for specified parameters
 *
 * History
 *******************************************************************************
 * 7/22/2010 - Rick Deigsler
 * Created.
 *
 *******************************************************************************
 * 9/9/10 Updated: To accomodate "Hybrid" ChannelTypes
 *******************************************************************************
 * Updated: 11/1/2010
 * Ticket 19091
 * Get Channel group from SalesChannelChannelGroup table.
 *******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingTermsSelect_TEST2]
	@p_username					nchar(100),
	@p_product_id				char(20),
	@p_union_select				varchar(15)	= ' ',
	@p_show_active_flag			tinyint		= 0,
	@p_deal_price_id			int			= 0 ,
	@p_contract_nbr				varchar(20)	= '',
	@p_contract_eff_start_date	datetime	= null,
	@p_contract_type			varchar(20)	= '',
	@p_account_type				varchar(50),
	@p_contract_date			datetime			/* Ticket 17543*/
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FirstDayOfMonth DATETIME
    SET @FirstDayOfMonth = dateadd(mm,datediff(mm,0,@p_contract_eff_start_date),0)
    
	SELECT	distinct option_id = h.term_months, return_value = h.term_months
    FROM lp_common..product_rate_history h (NOLOCK)
    JOIN lp_common..common_product p (NOLOCK) ON h.product_id = p.product_id
    WHERE h.eff_date = @p_contract_date
    AND h.product_id = @p_product_id
    AND (p.iscustom = 1 -- For custom products, start month matching is not enforced.
		OR @p_contract_eff_start_date is null 
		OR contract_eff_start_date = @FirstDayOfMonth)
    
    
    
/*
	DECLARE	@v_contract_type			varchar(5) /* Ticket 11176 */ 

	CREATE TABLE #ProductRate ( seq int, term_months int)
	DECLARE @SalesChannel			varchar(50),
			@ChannelID				int,	/* Ticket 19091  */
			@ChannelGroupID			int,
			@ChannelTypeID			int,
			@ChannelGroupIDLen		int,
			@StartMonth				int,
			@StartYear				int,
			@w_sales_channel_prefix	varchar(100),
			@SalesChannelRole		varchar(50)			

	SET		@SalesChannel	= REPLACE(@p_username , 'libertypower\', '') 
	SET		@StartMonth		= DATEPART(mm, @p_contract_eff_start_date)
	SET		@StartYear		= DATEPART(yyyy, @p_contract_eff_start_date)

	SELECT	@w_sales_channel_prefix = sales_channel_prefix  
	FROM	lp_common..common_config with (NOLOCK)  

	SELECT	@SalesChannelRole = replace(@p_username , 'libertypower\', @w_sales_channel_prefix)		


	SELECT	@ChannelID = sc.ChannelID, @ChannelTypeID = ct.ID
	FROM	LibertyPower..SalesChannel sc WITH (NOLOCK)
			INNER JOIN lp_commissions..vendor v WITH (NOLOCK) ON sc.ChannelID = v.ChannelID
			INNER JOIN lp_commissions..vendor_category vc WITH (NOLOCK) ON v.vendor_category_id = vc.vendor_category_id
			INNER JOIN LibertyPower..ChannelType ct WITH (NOLOCK) ON vc.vendor_category_code = ct.Name	
	WHERE	ChannelName = @SalesChannel

	-- This will determine the Channel Group that the Sales Channel was in based on the Contract Date /* Ticket 19091  */
	SELECT @ChannelGroupID = sccg.[ChannelGroupId]      
	FROM [LibertyPower].[dbo].[SalesChannelChannelGroup] sccg (NOLOCK)
		Join [LibertyPower].[dbo].[ChannelGroup] cg (NOLOCK) on sccg.ChannelGroupId = cg.ChannelGroupID
			AND sccg.EffectiveDate <= @p_contract_date
			AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > @p_contract_date
	WHERE ChannelID = @ChannelID


	SET		@ChannelGroupIDLen = LEN(@ChannelGroupID)

	/* Ticket 17543 */
    CREATE TABLE #common_product_rate (product_id char(20), rate_id int, eff_date datetime, rate decimal(12,5), rate_descp varchar(250), due_date datetime, grace_period int, contract_eff_start_date datetime, val_01 varchar(10),
		input_01 varchar(10), process_01 varchar(10), val_02 varchar(10), input_02 varchar(10), process_02 varchar(10), service_rate_class_id int, zone_id int, date_created datetime, username nchar(100),
		inactive_ind char(1), active_date datetime, chgstamp smallint, term_months int, fixed_end_date tinyint, GrossMargin decimal(9,6), IndexType varchar(50))

	IF (CONVERT(CHAR(8), @p_contract_date, 1) = CONVERT(CHAR(8), getdate(), 1))
			INSERT INTO #common_product_rate
            SELECT *
            FROM lp_common..common_product_rate WITH (NOLOCK)
    ELSE
			INSERT INTO #common_product_rate
            SELECT	pr.product_id, pr.rate_id, ph.eff_date, ph.rate, pr.rate_descp, pr.due_date, pr.grace_period, ph.contract_eff_start_date, pr.val_01,
					pr.input_01, pr.process_01, pr.val_02, pr.input_02, pr.process_02, pr.service_rate_class_id, pr.zone_id, ph.date_created, ph.username,0
					--pr.inactive_ind
					, pr.active_date, pr.chgstamp, ph.term_months, pr.fixed_end_date, ph.GrossMargin, pr.IndexType           
            FROM lp_common..common_product_rate pr WITH (NOLOCK)
            JOIN lp_common..product_rate_history ph WITH (NOLOCK) on pr.product_id = ph.product_id and pr.rate_id = ph.rate_id
            WHERE ph.eff_date = @p_contract_date	

	--- Get rates
	--- =================================================
	INSERT INTO	#ProductRate (seq, term_months)
	SELECT	DISTINCT 2, pr.term_months
	FROM	#common_product_rate pr WITH (NOLOCK)
			INNER JOIN lp_common..common_product p WITH (NOLOCK) ON pr.product_id = p.product_id 
			INNER JOIN lp_common..product_account_type cat WITH (NOLOCK)
			ON cat.account_type_id = p.account_type_id
			INNER JOIN LibertyPower..AccountType lat WITH (NOLOCK)
			ON LEFT(lat.AccountType, 3) = LEFT(cat.account_type, 3)			
			INNER JOIN lp_common..common_utility u WITH (NOLOCK) ON p.utility_id  = u.utility_id		
			INNER JOIN LibertyPower..ProductConfiguration pc WITH (NOLOCK)
			ON	pr.zone_id					= pc.ZoneID
			AND	pr.service_rate_class_id	= pc.ServiceClassID	
			AND	u.ID						= pc.UtilityID	
			LEFT JOIN lp_deal_capture..deal_pricing_detail dpd WITH (NOLOCK) ON dpd.product_id = pr.product_id and dpd.rate_id = pr.rate_id 
			LEFT JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK) ON dp.deal_pricing_id = dpd.deal_pricing_id				
	WHERE	pr.product_id					= @p_product_id
	AND		pr.Inactive_ind					= 0
	AND		cat.account_type_id				= @p_account_type
	--AND		pc.ChannelTypeID				= @ChannelTypeID
	AND		LEN(pr.rate_id)					= 9  
	AND		@ChannelGroupID					=   LEFT(pr.rate_id, 3) % 100
	AND (
			(p.product_category = 'VARIABLE' AND p.product_category in ('PORTFOLIO','CUSTOM')) OR
			dp.deal_pricing_id is not null OR
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,@p_contract_eff_start_date) OR
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,1,@p_contract_eff_start_date)) OR
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,2,@p_contract_eff_start_date)) OR
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,3,@p_contract_eff_start_date)) OR
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,4,@p_contract_eff_start_date)) OR /* Ticket 17511 */
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,5,@p_contract_eff_start_date)) OR /* Ticket 17511 */
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,6,@p_contract_eff_start_date))	  /* Ticket 17511 */
		)
	AND	(
		-- not custom pricing 
		dp.deal_pricing_id is null 

		OR ( -- rate has not expired 
			dp.date_expired > convert(char(08), getdate(), 112)
			-- user has access to deal pricing
			AND (
				 dp.sales_channel_role = @p_username 
				 OR dp.sales_channel_role = @SalesChannelRole 
				 OR dp.sales_channel_role in 
					(SELECT b.RoleName 
						FROM lp_portal..UserRoles a WITH (NOLOCK)
							JOIN lp_portal..Roles b WITH (NOLOCK) ON a.RoleID = b.RoleID  
							JOIN lp_portal..Users u with (NOLOCK INDEX = IX_Users)  ON a.userID = u.UserID
						WHERE Username = @p_username
							AND b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%' 
					 )
				 OR lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1 
				) 
			-- rate has not already been submitted or exists on the current contract
			AND ( dpd.rate_submit_ind = 0 OR  EXISTS ( Select contract_nbr from deal_contract WITH (NOLOCK) where contract_nbr = @p_contract_nbr and @p_contract_nbr <> '' and product_id = dpd.product_id and rate_id = dpd.rate_id UNION 
														Select contract_nbr from deal_contract_account WITH (NOLOCK) where contract_nbr = @p_contract_nbr and  @p_contract_nbr <> '' and product_id = dpd.product_id and rate_id = dpd.rate_id
													) 
				)  
			)
		  )	
	--AND		DATEPART(mm, pr.contract_eff_start_date)	= @StartMonth
	--AND		DATEPART(yyyy, pr.contract_eff_start_date)	= @StartYear


	-- custom rates
	INSERT INTO	#ProductRate (seq, term_months)
	SELECT	DISTINCT 2, pr.term_months
	FROM	#common_product_rate pr WITH (NOLOCK)
			INNER JOIN lp_common..common_product p WITH (NOLOCK) ON pr.product_id = p.product_id 							
			INNER JOIN lp_deal_capture..deal_pricing_detail dpd WITH (NOLOCK) ON dpd.product_id = pr.product_id and dpd.rate_id = pr.rate_id 
			INNER JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK) ON dp.deal_pricing_id = dpd.deal_pricing_id
	WHERE	pr.product_id = @p_product_id	
	AND dp.date_expired > CONVERT(char(08), GETDATE(), 112)	
	AND dpd.rate_submit_ind = 0 
	OR  EXISTS (	SELECT contract_nbr FROM lp_deal_capture..deal_contract WITH (NOLOCK) WHERE contract_nbr = @p_contract_nbr AND @p_contract_nbr <> '' AND product_id = dpd.product_id AND rate_id = dpd.rate_id UNION 
					SELECT contract_nbr FROM lp_deal_capture..deal_contract_account WITH (NOLOCK) WHERE contract_nbr = @p_contract_nbr AND @p_contract_nbr <> '' AND product_id = dpd.product_id AND rate_id = dpd.rate_id
				)						

	SELECT	option_id = term_months, return_value = term_months
	FROM	#ProductRate 
	ORDER BY seq, option_id

	DROP TABLE #ProductRate
	DROP TABLE #common_product_rate

    SET NOCOUNT OFF;
    */
END
-- Copyright 2010 Liberty Power

