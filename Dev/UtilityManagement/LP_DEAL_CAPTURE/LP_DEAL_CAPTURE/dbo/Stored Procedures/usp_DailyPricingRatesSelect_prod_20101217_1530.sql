-- Stored Procedure

/*******************************************************************************
 * usp_DailyPricingRatesSelect
 * Gets rates for specified parameters
 *
 * History
 *******************************************************************************
 * 7/22/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 9/9/10 Updated: To accommodate "Hybrid" ChannelTypes
 *******************************************************************************
 * Updated: 9/21/2010
 * Migrated table product_transition from [Workspace] to [LibertyPower]
 *******************************************************************************
 *******************************************************************************
 * Updated: 10/26/2010
 * Ticket 19192
 * Comments this condition:
 * --	AND		pr.due_date		>= CONVERT(char(08), GETDATE(), 112) -- Comments ticket 19192
 *******************************************************************************
 * Updated: 11/1/2010
 * Ticket 19091
 * Get Channel group from SalesChannelChannelGroup table.
 *******************************************************************************/


CREATE PROCEDURE [dbo].[usp_DailyPricingRatesSelect_prod_20101217_1530]
	@Username					nchar(100),
	@ContractNumber				varchar(50),
	@UtilityCode				varchar(50),
	@p_product_id				char(20),
	@p_term_months				int				= NULL,  
	@p_union_select				varchar(15)		= ' ',
	@p_show_active_flag			tinyint			= 0,
	@p_deal_price_id			int				= 0,
	@p_contract_eff_start_date	datetime		= NULL,
	@p_show_startdate_flag		tinyint			= 0,
	@p_zone						varchar(20)		= 'NONE',
	@p_service_class			varchar(20)		= 'NONE',
	@p_contract_date			datetime			/* Ticket 17543*/
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @ChannelName			varchar(50),
			@ChannelID				int,	/* Ticket 19091  */
			@ChannelGroupID			int,
			@SalesChannelRole		varchar(50),
			@SalesChannelPrefix		varchar(100),			
			@ChannelTypeID			int,
			@UtilityID				int,
			@ProductCrossPriceSetID	int,
			@StartMonth				int,
			@StartYear				int				

	SET		@ChannelName	= REPLACE(@Username , 'libertypower\', '') 
	SET		@StartMonth		= DATEPART(mm, @p_contract_eff_start_date)
	SET		@StartYear		= DATEPART(yyyy, @p_contract_eff_start_date)		

	SELECT	@SalesChannelPrefix= sales_channel_prefix  FROM lp_common..common_config WITH (NOLOCK)  
	SELECT	@SalesChannelRole = REPLACE(@Username , 'libertypower\', @SalesChannelPrefix)	

	SELECT	@UtilityID	= ID
	FROM	LibertyPower..Utility
	WHERE	UtilityCode	= @UtilityCode

	SELECT	@ProductCrossPriceSetID	= ProductCrossPriceSetID
	FROM	LibertyPower..ProductCrossPriceSet
	WHERE	EffectiveDate = (	SELECT MAX(EffectiveDate)
								FROM LibertyPower..ProductCrossPriceSet 
								WHERE EffectiveDate <= GETDATE()
							)		

	CREATE TABLE	#SalesChannel (ChannelID int, ChannelTypeID int)
	CREATE TABLE	#ActivePrices (MarketID int, UtilityID int, ProductTypeID int, SegmentID int, 
					ZoneID int, ServiceClassID int, ChannelTypeID int, Term int)
	CREATE TABLE	#ProductRateIds (ProductID varchar(50), RateID int)
	CREATE TABLE	#ProductRates (ProductID varchar(50), return_value int, Rate decimal(12, 5), option_id varchar(250), IsCustom tinyint)

---------- 	Sales Channel  --------------------------------------------------------------------------------------------
	INSERT	INTO #SalesChannel
	SELECT	sc.ChannelID, ct.ID
	FROM	LibertyPower..SalesChannel sc WITH (NOLOCK)
			INNER JOIN lp_commissions..vendor v WITH (NOLOCK) ON sc.ChannelID = v.ChannelID
			INNER JOIN lp_commissions..vendor_category vc WITH (NOLOCK) ON v.vendor_category_id = vc.vendor_category_id
			INNER JOIN LibertyPower..ChannelType ct WITH (NOLOCK) ON vc.vendor_category_code = ct.Name	
	WHERE	ChannelName = @ChannelName


	SELECT	@ChannelID = ChannelID , @ChannelTypeID = ChannelTypeID
	FROM	#SalesChannel WITH (NOLOCK)

	-- This will determine the Channel Group that the Sales Channel was in based on the Contract Date /* Ticket 19091  */
	SELECT @ChannelGroupID = sccg.[ChannelGroupId]      
	FROM [LibertyPower].[dbo].[SalesChannelChannelGroup] sccg WITH (NOLOCK)
		Join [LibertyPower].[dbo].[ChannelGroup] cg WITH (NOLOCK) on sccg.ChannelGroupId = cg.ChannelGroupID
			AND sccg.EffectiveDate <= @p_contract_date
			AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > @p_contract_date
	WHERE ChannelID = @ChannelID

---------- 	Active Prices  --------------------------------------------------------------------------------------------	
	INSERT	INTO #ActivePrices
	SELECT	DISTINCT pc.MarketID, pc.UtilityID, pc. ProductTypeID, pc.SegmentID, pc.ZoneID, 
			pc.ServiceClassID, pc.ChannelTypeID, oa.Term
	FROM	LibertyPower..ProductConfiguration pc WITH (NOLOCK)
			INNER JOIN LibertyPower..OfferActivation oa WITH (NOLOCK) ON pc.ProductConfigurationID = oa.ProductConfigurationID
			INNER JOIN LibertyPower..ProductCrossPrice pcp WITH (NOLOCK) 
				ON	pcp.MarketID			= pc.MarketID 
				AND	pcp.UtilityID			= pc.UtilityID
				AND	pcp.ProductTypeID		= pc.ProductTypeID
				AND	pcp.SegmentID			= pc.SegmentID	
				AND	pcp.ZoneID				= pc.ZoneID
				AND	pcp.ServiceClassID		= pc.ServiceClassID	
				AND	pcp.ChannelTypeID		= pc.ChannelTypeID
	WHERE	oa.IsActive					= 1	
	AND		pc.UtilityID				= @UtilityID
	AND		pcp.ProductCrossPriceSetID	= @ProductCrossPriceSetID
	AND		pcp.ChannelGroupID			= @ChannelGroupID
	--	AND		pcp.ChannelTypeID			= @ChannelTypeID
	AND		(
				pcp.ChannelTypeID			= @ChannelTypeID								 -- Type is equal to  Channel's type.
				OR (@ChannelTypeID = 4 and (pcp.ChannelTypeID = 1 OR pcp.ChannelTypeID = 2)) -- If Type is Hybrid (id=4) then get abc and telesales.
			)

---------- 	Product Rate IDs  -----------------------------------------------------------------------------------------	
	INSERT	INTO #ProductRateIds
	SELECT	DISTINCT product_id, rate_id
	FROM	#ActivePrices p WITH (NOLOCK)
			INNER JOIN [LibertyPower].[dbo].[product_transition] t WITH (NOLOCK)
				ON	p.MarketID			= t.MarketID
				AND	p.UtilityID			= t.UtilityID
				AND	p.ProductTypeID		= t.ProductTypeID
				AND	p.SegmentID			= t.AccountTypeID
				AND	p.ZoneID			= t.ZoneID
				AND	p.ServiceClassID	= t.ServiceClassID
				AND	p.ChannelTypeID		= t.ChannelTypeID
				AND	p.Term				= t.Term		

	/* Ticket 17543 */
    CREATE TABLE #common_product_rate (product_id char(20), rate_id int, eff_date datetime, rate decimal(12,5), rate_descp varchar(250), due_date datetime, grace_period int, contract_eff_start_date datetime, val_01 varchar(10),
		input_01 varchar(10), process_01 varchar(10), val_02 varchar(10), input_02 varchar(10), process_02 varchar(10), service_rate_class_id int, zone_id int, date_created datetime, username nchar(100),
		inactive_ind char(1), active_date datetime, chgstamp smallint, term_months int, fixed_end_date tinyint, GrossMargin decimal(9,6), IndexType varchar(50))

	IF (CONVERT(CHAR(8), @p_contract_date, 1) = CONVERT(CHAR(8), getdate(), 1))
			INSERT INTO #common_product_rate
            SELECT *
            FROM lp_common..common_product_rate
    ELSE
			INSERT INTO #common_product_rate
            SELECT	pr.product_id, pr.rate_id, ph.eff_date, ph.rate, pr.rate_descp, pr.due_date, pr.grace_period, ph.contract_eff_start_date, pr.val_01,
					pr.input_01, pr.process_01, pr.val_02, pr.input_02, pr.process_02, pr.service_rate_class_id, pr.zone_id, ph.date_created, ph.username,
					ph.inactive_ind, pr.active_date, pr.chgstamp, ph.term_months, pr.fixed_end_date, ph.GrossMargin, pr.IndexType           
            FROM lp_common..common_product_rate pr
            JOIN lp_common..product_rate_history ph on pr.product_id = ph.product_id and pr.rate_id = ph.rate_id
            WHERE ph.eff_date = @p_contract_date	


---------- 	Product Rates  --------------------------------------------------------------------------------------------				

	INSERT	INTO #ProductRates
	SELECT	DISTINCT p.product_id, r.rate_id, r.rate, 
			r.rate_descp,
			p.IsCustom
	FROM	#common_product_rate r
			INNER JOIN lp_common..common_product p ON r.product_id = p.product_id 
			INNER JOIN lp_common..product_account_type cat
			ON cat.account_type_id = p.account_type_id
			INNER JOIN LibertyPower..AccountType lat
			ON LEFT(lat.AccountType, 3) = LEFT(cat.account_type, 3)			
			INNER JOIN lp_common..common_utility u ON p.utility_id  = u.utility_id		
			INNER JOIN LibertyPower..ProductConfiguration pc WITH (NOLOCK)
			ON	r.zone_id					= pc.ZoneID
			AND	r.service_rate_class_id	= pc.ServiceClassID	
			AND	u.ID						= pc.UtilityID		
	WHERE	r.term_months		= @p_term_months
	AND		r.product_id		= @p_product_id
	AND		r.Inactive_ind		= 0
--  AND		pc.ChannelTypeID	= @ChannelTypeID
	AND		(
				pc.ChannelTypeID	= @ChannelTypeID 	 -- Type is equal to  Channel's type.
				OR (@ChannelTypeID = 4 and (pc.ChannelTypeID = 1 OR pc.ChannelTypeID = 2)) -- If Type is Hybrid (id=4) then get abc and telesales.
			)
	AND		LEN(r.rate_id)		= 9  
	AND		@ChannelGroupID		=   LEFT(r.rate_id, 3) % 100
	AND		DATEPART(mm, r.contract_eff_start_date)	= @StartMonth
	AND		DATEPART(yyyy, r.contract_eff_start_date)	= @StartYear	

	-- custom prices
	INSERT	INTO #ProductRates
	SELECT	DISTINCT  pr.product_id, pr.rate_id, pr.rate, LTRIM(RTRIM(pr.rate_descp)), p.IsCustom
	FROM	#common_product_rate pr
			INNER JOIN lp_common..common_product p ON pr.product_id = p.product_id 
			INNER JOIN lp_deal_capture..deal_pricing_detail dpd ON dpd.product_id = pr.product_id AND dpd.rate_id = pr.rate_id 
			INNER JOIN lp_deal_capture..deal_pricing dp ON dp.deal_pricing_id = dpd.deal_pricing_id
    WHERE	pr.term_months	= @p_term_months
	AND		p.product_id	= @p_product_id
	AND		pr.eff_date		<= CONVERT(char(08), GETDATE(), 112) 
--	AND		pr.due_date		>= CONVERT(char(08), GETDATE(), 112) -- Comments ticket 19192
	AND		pr.inactive_ind	= 0
	AND		dp.date_expired	>= CONVERT(char(08), GETDATE(), 112)  -- custom rate has not expired 
	AND		(	-- user has access to custom rate	
				dp.sales_channel_role		= @Username 
				OR dp.sales_channel_role	= @SalesChannelRole 
				OR dp.sales_channel_role IN 
				(	SELECT	b.RoleName 
					FROM	lp_portal..UserRoles a
							JOIN lp_portal..Roles b ON a.RoleID = b.RoleID  
							JOIN lp_portal..Users u ON a.userID = u.UserID
					WHERE	Username	= @Username
					AND		b.RoleName	LIKE LTRIM(RTRIM(@SalesChannelPrefix)) + '%' 
				)
				 OR lp_common.dbo.ufn_is_liberty_employee(@Username) = 1 
			 ) 
		-- rate has not already been submitted or exists on the current contract
		AND (	dpd.rate_submit_ind = 0 
				OR  EXISTS (	SELECT	contract_nbr 
								FROM	deal_contract 
								WHERE	contract_nbr	= @ContractNumber 
								AND		@ContractNumber	<> '' 
								AND		product_id		= dpd.product_id 
								AND		rate_id			= dpd.rate_id 
								UNION 
								SELECT	contract_nbr 
								FROM	deal_contract_account 
								WHERE	contract_nbr	= @ContractNumber 
								AND		@ContractNumber	<> '' 
								AND		product_id		= dpd.product_id 
								AND		rate_id			= dpd.rate_id
							) 
			) 		


	SELECT	*
	FROM	#ProductRates

	DROP TABLE #SalesChannel
	DROP TABLE #ActivePrices
	DROP TABLE #ProductRateIds
	DROP TABLE #ProductRates
	DROP TABLE #common_product_rate

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
