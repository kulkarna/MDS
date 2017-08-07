-- Stored Procedure

/*******************************************************************************
 * usp_DailyPricingTermsForPrintSelect
 * Gets terms for specified parameters
 *
 * History
 *******************************************************************************
 * 8/13/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 9/22/10 Updated: To accomodate "Hybrid" ChannelTypes
 *******************************************************************************
 * Updated: 11/1/2010
 * Ticket 19091
 * Get Channel group from SalesChannelChannelGroup table.
 *******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingTermsForPrintSelect]
	@p_username					nchar(100),
	@p_product_id				char(20),
	@p_union_select				varchar(15)	= ' ',
	@p_show_active_flag			tinyint		= 0,
	@p_deal_price_id			int			= 0 ,
	@p_contract_nbr				varchar(20)	= '',
	@p_contract_type			varchar(20)	= '',
	@p_account_type				varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @Today DATETIME
	SELECT @Today = lp_enrollment.dbo.ufn_date_format(getdate(),'<YYYY>-<MM>-<DD>')

	exec usp_DailyPricingTermsSelect 
	 @p_username = @p_username
	,@p_product_id = @p_product_id
	,@p_account_type = @p_account_type
	,@p_contract_date = @Today

	/*
	DECLARE	@v_contract_type			varchar(5) /* Ticket 11176 */ 

	CREATE TABLE #ProductRate ( seq int, term_months int)
	DECLARE @SalesChannel	varchar(50),
			@ChannelID			int,
			@ChannelGroupID		int,
			@ChannelTypeID		int,
			@ChannelGroupIDLen	int

	SET		@SalesChannel	= REPLACE(@p_username , 'libertypower\', '') 

	SELECT	@ChannelID = sc.ChannelID, @ChannelTypeID = ct.ID
	FROM	LibertyPower..SalesChannel sc WITH (NOLOCK)
			INNER JOIN lp_commissions..vendor v WITH (NOLOCK) ON sc.ChannelID = v.ChannelID
			INNER JOIN lp_commissions..vendor_category vc WITH (NOLOCK) ON v.vendor_category_id = vc.vendor_category_id
			INNER JOIN LibertyPower..ChannelType ct WITH (NOLOCK) ON vc.vendor_category_code = ct.Name	
	WHERE	ChannelName = @SalesChannel
	
	-- This will determine the Channel Group that the Sales Channel was in based on the Current Date /* Ticket 19091  */
	SELECT @ChannelGroupID = sccg.[ChannelGroupId]      
	FROM [LibertyPower].[dbo].[SalesChannelChannelGroup] sccg WITH (NOLOCK)
		Join [LibertyPower].[dbo].[ChannelGroup] cg WITH (NOLOCK) on sccg.ChannelGroupId = cg.ChannelGroupID
			AND sccg.EffectiveDate <= GETDATE()
			AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > GETDATE()
	WHERE ChannelID = @ChannelID

	SET		@ChannelGroupIDLen = LEN(@ChannelGroupID)


	--- Get rates
	--- =================================================
	INSERT INTO	#ProductRate (seq, term_months)
	SELECT	DISTINCT 2, pr.term_months
	FROM	lp_common..common_product_rate pr with (NOLOCK INDEX = common_product_rate_idx)
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
	WHERE	pr.product_id					= @p_product_id
	AND		pr.Inactive_ind					= 0
	AND		cat.account_type_id				= @p_account_type
--	AND		pc.ChannelTypeID				= @ChannelTypeID
	AND		LEN(pr.rate_id)					= 9  
	AND		@ChannelGroupID					=   LEFT(pr.rate_id, 3) % 100

	-- custom rates
	INSERT INTO	#ProductRate (seq, term_months)
	SELECT	DISTINCT 2, pr.term_months
	FROM	lp_common..common_product_rate pr with (NOLOCK INDEX = common_product_rate_idx)
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

    SET NOCOUNT OFF;
    
    */
END
-- Copyright 2010 Liberty Power
